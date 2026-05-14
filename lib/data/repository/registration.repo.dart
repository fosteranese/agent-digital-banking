import 'dart:core';

import 'package:my_sage_agent/constants/status.const.dart';
import 'package:my_sage_agent/data/models/next_of_kin_model.dart';
import 'package:my_sage_agent/data/models/place_autocomplete.modal.dart';
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
    required String maritalStatus,
    required String occupation,
    required String sector,
  }) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/initiateAccountOpening',
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'email': emailAddress,
        'cardNumber': cardNumber,
        'maritalStatus': maritalStatus,
        'occupation': occupation,
        'sector': sector,
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
    required PlaceAutocomplete location,
    required String cityOrTown,
    required String region,
    required String token,
    required String withdrawalOption,
    required String transactionNotification,
    required String emergencyContact,
  }) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/AccountOpeningAddress',
      body: {
        'id': token,
        'address1': address1,
        'location': location.description,
        'placeId': location.placeId,
        'latitude': location.location?.latitude,
        'longitude': location.location?.longitude,
        'region': region,
        'cityOrTown': cityOrTown,
        'emergencyContact': emergencyContact,
        'withdrawalOption': withdrawalOption,
        'transactionNotification': transactionNotification,
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

  Future<String> saveNextOfKinInfo({
    required String token,
    required List<NextOfKinModel> list,
  }) async {
    final response = await _fbl.post(
      path: 'FieldExecutive/AccountOpeningNextOfKin',
      body: {
        'id': token,
        'kins': list.map((item) {
          return {
            'id': item.id,
            'fullName': item.fullName,
            'phoneNumber': item.phoneNumber,
            'emailAddress': item.emailAddress,
          };
        }).toList(),
      },
      isAuthenticated: true,
    );

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    return response.data;
  }
}
