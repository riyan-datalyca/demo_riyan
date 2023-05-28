import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginInformation {
  late String countryCode;
  late String phoneNumber;
  late String otp;
  late String userName;
  late String email;
}

class ApiResponse {
  final bool status;
  final bool? profileExists;
  final String? response;
  final String? responseID;
  final String? jwt;

  ApiResponse(
      {required this.status,
      this.profileExists,
      this.response,
      this.responseID,
      this.jwt});

  ApiResponse.fromJson(Map<String, dynamic> response)
      : status = response['status'] ?? false,
        profileExists = response['profile_exists'] ?? false,
        response = response['response'] ?? 'No Response',
        responseID = response['responseID'],
        jwt = response['jwt'];
}

class PasteApi {
  Future<ApiResponse> sendOTP(
      {required LoginInformation inputInformation}) async {
    var url = Uri.https('test-otp-api.7474224.xyz', 'sendotp.php');
    var response =
        await http.post(url, body: {"mobile": inputInformation.phoneNumber});
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> verifyOTP(
      {required LoginInformation loginInformation,
      required ApiResponse apiResponse}) async {
    var url = Uri.https('test-otp-api.7474224.xyz', 'verifyotp.php');
    var response = await http.post(url, body: {
      "request_id": apiResponse.responseID ?? '',
      "code": loginInformation.otp ?? ''
    });
    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> addUser(
      {required ApiResponse apiResponse,
      required LoginInformation loginInformation}) async {
    var url = Uri.https('test-otp-api.7474224.xyz', 'profilesubmit.php');
    var response = await http.post(url, body: {
      "name": loginInformation.userName ?? '',
      "email": loginInformation.email ?? ''
    }, headers: {
      "Token": "jwt1235"
    });
    return ApiResponse.fromJson(jsonDecode(response.body));
  }
}
