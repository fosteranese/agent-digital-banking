import 'dart:core';

import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/models/response.modal.dart';
import 'package:my_sage_agent/data/remote/main.remote.dart';

class RegistrationRepo {
  final _fbl = MainRemote();

  Future<String> savePersonalInfo({
    required String firstName,
    required String lastName,
    required String gender,
    required String phoneNumber,
    required String emailAddress,
    required String cardNumber,
  }) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/initiateAccountOpening',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'emailAddress': emailAddress,
        'cardNumber': cardNumber,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data;
  }

  Future<String> saveResidentialAddress({
    required String address1,
    required String? address2,
    required String cityOrTown,
    required String region,
    required String token,
  }) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/AccountOpeningAddress',
      body: {
        'id': token,
        'address1': address1,
        'address2': address2,
        'region': region,
        'cityOrTown': cityOrTown,
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data as String;
  }

  Future<Response> verifyPicture({required String token, required String picture}) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/AccountOpeningVerification',
      body: {'id': token, 'picture': picture},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response;
  }

  Future<Response> manualVerification({
    required String token,
    required String cardFront,
    required String cardBack,
  }) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/AccountOpeningManualVerify',
      body: {'id': token, 'cardFront': cardFront, 'cardBack': cardBack},
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response;
  }
}
