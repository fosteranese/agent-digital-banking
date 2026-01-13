import 'dart:convert';
import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../../env/env.dart';
import '../../logger.dart';
import '../../utils/app.util.dart';
import '../../utils/encryption.util.dart';
import '../../utils/response.util.dart';
import '../models/response.modal.dart';
import '../responses/general.responses.dart';

class MainRemote {
  Future<SecurityContext> get _globalContext async {
    final sslCert = await rootBundle.load('assets/certificate.pem');
    SecurityContext securityContext = SecurityContext();
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  Future<http.Client> _getSSLPinningClient() async {
    HttpClient client = HttpClient(context: await _globalContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }

  Future<Map<String, dynamic>> _formatRequestPayload({
    required String path,
    required Map<String, dynamic>? body,
    required bool isAuthenticated,
    bool encrypt = true,
  }) async {
    final appInfo = AppUtil.info;
    Map<String, dynamic> data = {
      'meta': appInfo.toMap(),
      // 'EndPoint': path,
    };

    if (body != null) {
      body["channel"] = appInfo.channel;
      body["deviceId"] = appInfo.deviceId;

      data['payLoad'] = body;
    }

    if (isAuthenticated) {
      data['meta']['sessionId'] = AppUtil.currentUser.sessionId;
    }

    if (encrypt) {
      final jsonText = json.encode(data);
      logger.i(jsonText);
      final (String cipher, Key key, IV iv) = await EncryptionUtil.encrypt(jsonText);

      final finalCipher = json.encode(cipher);
      logger.i('Encrypted payload');
      logger.i(finalCipher);
      return {
        'payload': finalCipher,
        // 'payload': cipher,
        'key': key,
        'iv': iv,
      };
    }

    final payload = json.encode(data);
    return {'payload': json.encode(payload)};
  }

  Future<Response<dynamic>> _decodeResponse({
    required String cipherText,
    Key? key,
    IV? iv,
    bool isEncrypted = true,
  }) async {
    final responseBody = isEncrypted
        ? await EncryptionUtil.decrypt(cipherText, key!, iv!)
        : cipherText;

    logger.i(responseBody);

    var info = json.decode(responseBody);
    var result = Response<dynamic>(
      code: info['status'].toString(),
      status: ResponseUtil.convertFromStatusCode(info['status'] as int),
      message: info['message'].toString(),
      data: info['data'] is! List<dynamic> ? info['data'] : {'list': info['data']},
      timeStamp: info['timeStamp']?.toString(),
      imageBaseUrl: info['imageBaseUrl']?.toString(),
      imageDirectory: info['imageDirectory']?.toString(),
    );

    if (result.data != null && result.data is! String) {
      if (info['timeStamp'] != null) {
        result.data['timeStamp'] = info['timeStamp'];
      }
      if (info['imageBaseUrl'] != null) {
        result.data['imageBaseUrl'] = info['imageBaseUrl'];
      }
      if (info['imageDirectory'] != null) {
        result.data['imageDirectory'] = info['imageDirectory'];
      }
      if (info['extra'] != null) {
        result.data['extra'] = info['extra'];
      }
    }

    return result;
  }

  Uri _postUrl({required bool mockUp, required String path}) {
    if (mockUp) {
      return Uri.https(Env.mockMainBaseUrl, "${Env.mockMainRootPath}/$path");
    }

    return Uri.https(Env.mainBaseUrl, "${Env.mainRootPath}/$path");
  }

  Future<Response<dynamic>> post({
    required String path,
    Map<String, dynamic>? body,
    bool isAuthenticated = false,
    bool encrypt = true,
  }) async {
    try {
      logger.i('url: $path');
      var request = await _formatRequestPayload(
        body: body,
        path: path,
        isAuthenticated: isAuthenticated,
        encrypt: encrypt,
      );
      logger.i(body);

      final payload = request['payload'];
      final iv = request.containsKey('iv') ? (request['iv'] as IV) : null;
      final key = request.containsKey('key') ? (request['key'] as Key) : null;

      // SSL Pinned client for api calls
      final client = await _getSSLPinningClient();
      var url = _postUrl(mockUp: false, path: path);
      // url = Uri.https("google.com", "");
      var rsaAv = await EncryptionUtil.encryptRSA(iv?.base64 ?? '');
      var rsaKey = await EncryptionUtil.encryptRSA(key?.base64 ?? '');
      var response = await client.post(
        url,
        headers: {"Content-Type": "application/json", "av": rsaAv, "key": rsaKey},
        body: payload,
      );

      final result = await _decodeResponse(
        cipherText: response.body,
        isEncrypted: encrypt,
        iv: iv,
        key: key,
      );
      logger.i(result);

      return result;
    } on SocketException catch (e) {
      logger.e(e);
      AppUtil.deviceStatus = GeneralResponse.offline;
      return GeneralResponse.offline;
    } on HandshakeException catch (e) {
      logger.e(e);
      AppUtil.deviceStatus = GeneralResponse.forceUpdate;
      return GeneralResponse.forceUpdate;
    } catch (e) {
      logger.e(e);
      AppUtil.deviceStatus = GeneralResponse.unknown;
      return GeneralResponse.unknown;
    }
  }

  Future<Response<dynamic>> postMockUp({
    required String path,
    Map<String, dynamic>? body,
    bool isAuthenticated = false,
    bool encrypt = true,
  }) async {
    try {
      logger.i('url: $path');
      logger.i(body);

      // SSL Pinned client for api calls
      final client = await _getSSLPinningClient();
      var url = _postUrl(mockUp: true, path: path);
      var response = await client.post(url, body: body);

      final result = json.decode(response.body);
      logger.i(result);

      return Response(
        code: result['status'].toString(),
        status: ResponseUtil.convertFromStatusCode(result['status'] as int),
        message: result['message'].toString(),
        data: result['data'],
      );
    } on SocketException catch (e) {
      logger.e(e);
      AppUtil.deviceStatus = GeneralResponse.offline;
      return GeneralResponse.offline;
    } on HandshakeException catch (e) {
      logger.e(e);
      AppUtil.deviceStatus = GeneralResponse.forceUpdate;
      return GeneralResponse.forceUpdate;
    } catch (e) {
      logger.e(e);
      AppUtil.deviceStatus = GeneralResponse.unknown;
      return GeneralResponse.unknown;
    }
  }
}
