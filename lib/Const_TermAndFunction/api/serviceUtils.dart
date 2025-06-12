import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/Const_TermAndFunction/session.dart';
import 'package:tracker_firmware/widgets/alertBoxes.dart';

class ApiHeaders {
  // Default constructor - no parameters
  ApiHeaders();

  Map<String, String> get authHeader => {
        'Authorization': 'Bearer ${UserData().accessToken}',
        'Content-Type': 'application/json',
      };

  Map<String, String> get header => {
        'Content-Type': 'application/json',
      };
}

class ApiEndpoints {
  static const String _devBaseUrl = 'http://192.168.130.138:8080';
  static const String _prodBaseUrl = 'http://192.168.130.138:8080';
  static const bool _isProd = true;

  static String get baseUrl => _isProd ? _prodBaseUrl : _devBaseUrl;

  // Helper method to get full URL
  static String fullUrl(String endpoint) => '$baseUrl$endpoint';

  // Auth
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String refresh = '/api/auth/refresh';

  // Non-auth
  static const String checkAuth = '/api/non-auth/check-auth';
  static const String saveDesignation = '/api/non-auth/save_designation';
  static const String saveEmployee = '/api/non-auth/save_employee';
  static const String updateEmployee = '/api/non-auth/update_employee';
  static const String updateDeactive = '/api/non-auth/update_deactive';
  static const String updateActive = '/api/non-auth/update_active';
  static const String getProfileByContact = '/api/non-auth/getProfileInformationByContactNumber';

  // Hardware
  static const String saveDeviceTypes = '/api/non-auth/hardware/save_deviceTypes';
  static const String saveHardwareIds = '/api/non-auth/hardware/save_hardwareIds';
  static const String saveFirmware = '/api/non-auth/hardware/save_firmware';
  static const String saveHardware = '/api/non-auth/hardware/save_hardware';
  static const String saveProfile = '/api/non-auth/hardware/save_profile';
  static const String getHardwareNumber =
      '/api/non-auth/hardware/getnumber/'; // append ID like getHardwareNumber + "5"
  static const String saveClient = '/api/non-auth/hardware/save_client';
  static const String getAllFirmwareDetails = '/api/non-auth/hardware/getAllFirmwareDetails';
  static const String getAllProfileDetails = '/api/non-auth/hardware/getAllProfileDetails';
  static const String saveBatch = '/api/non-auth/hardware/save_batch';
  static const String getAllBatchDetails = '/api/non-auth/hardware/getAllBatchDetails';
}

String getUrl(String endpoint) => ApiEndpoints.fullUrl(endpoint); //getUrl(ApiEndpoints.login);

class ApiService {
  static Future<void> callApi({
    required BuildContext context,
    required String method,
    required String endpoint,
    Map<String, dynamic>? bodyOrParams,
    bool errorDisplay = true,
    bool headerAuth = true,
    required Function(dynamic data) onSuccess,
    bool isRetry = false, // prevents infinite loop
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = headerAuth ? ApiHeaders().authHeader : ApiHeaders().header;

    http.Response response;

    try {
      if (method.toUpperCase() == 'POST') {
        response = await http.post(
          url,
          headers: headers,
          body: jsonEncode(bodyOrParams ?? {}),
        );
      } else if (method.toUpperCase() == 'PUT') {
        response = await http.put(
          url,
          headers: headers,
          body: jsonEncode(bodyOrParams ?? {}),
        );
      } else if (method.toUpperCase() == 'GET') {
        final uriWithParams = Uri.parse(
          '${ApiEndpoints.baseUrl}$endpoint${_encodeParams(bodyOrParams)}',
        );
        response = await http.get(uriWithParams, headers: headers);
      } else {
        throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode == 401 && !isRetry) {
        //
        // && jsonDecode(response.body)['response']==-5) {
        // Unauthorized: try to refresh token
        bool success = await refreshAccessToken(context);
        if (success) {
          // Retry once with new token
          await callApi(
            context: context,
            method: method,
            endpoint: endpoint,
            bodyOrParams: bodyOrParams,
            errorDisplay: errorDisplay,
            onSuccess: onSuccess,
            isRetry: true,
          );
          return;
        } else {
          ShowSnackBarMessage(
            context,
            'Session expired. Please log in again.',
            false,
          );

          await forceLogOut(context);
        }
      }

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['response']["code"] == 1) {
        onSuccess(responseBody['data']);
      } else {
        if (errorDisplay) {
          ShowSnackBarMessage(
            context,
            responseBody['message'] ?? 'Something went wrong!',
            false,
          );
        }
        printFunc('API call failed: ${responseBody['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      printFunc('Error in API call: $e');
      if (errorDisplay) {
        ShowSnackBarMessage(context, 'Network error: $e', false);
      }
    }
  }

  static Future<bool> refreshAccessToken(BuildContext context) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.refresh}');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': UserData().refreshToken}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['response']["code"] == 1) {
        setTokenInfo(responseBody);
        return true;
      } else {
        ShowSnackBarMessage(context, 'Session expired. Please log in again.', false);
        return false;
      }
    } catch (e) {
      ShowSnackBarMessage(context, 'Token refresh failed: $e', false);
      return false;
    }
  }

  static Future<void> performLogoutApiCall(BuildContext context) async {
    final url = Uri.parse(ApiEndpoints.fullUrl(ApiEndpoints.logout));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'accessToken': UserData.instance.accessToken ?? "",
          'refreshToken': UserData.instance.refreshToken ?? "",
        }),
      );

      if (response.statusCode == 200 && jsonDecode(response.body)['response']["code"] == 1) {
        // Logout successful
        ShowSnackBarMessage(context, 'Logged out successfully.', true);
      } else {
        ShowSnackBarMessage(context, 'Logout failed.', false);
      }
    } catch (e) {
      ShowSnackBarMessage(context, 'Error logging out: $e', false);
    } finally {
      // Clear user data always
      UserData.instance.clear();

      // Optionally: Navigate to login screen
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (_) => LoginScreen()),
      //   (route) => false,
      // );
    }
  }

  static String _encodeParams(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return '';
    final query = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    return '?$query';
  }
}
