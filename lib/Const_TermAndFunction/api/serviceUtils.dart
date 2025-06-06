import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHeaders {
  // Default constructor - no parameters
  ApiHeaders();

  Map<String, String> get header =>
      {
        'Authorization': 'Bearer ${UserData().accessToken}',
        'Content-Type': 'application/json',
      };
}

class ApiEndpoints {
  static const String _devBaseUrl = 'https://dev.optipace.in';
  static const String _prodBaseUrl = 'https://optipace.in';

  static const bool _isProd = true;

  static String get baseUrl => _isProd ? _prodBaseUrl : _devBaseUrl;

  static const String login = '/app/login';
  static const String getEmployee = '/app/employee';

  static String fullUrl(String endpoint) => '$baseUrl$endpoint';
}

String getUrl(String endpoint) => ApiEndpoints.fullUrl(endpoint); //getUrl(ApiEndpoints.login);

class ApiService {
  static Future<void> callApi({
    required String method,
    required String endpoint,
    Map<String, dynamic>? bodyOrParams,
    required Function(dynamic data) onSuccess,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = ApiHeaders().header;

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

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 && responseBody['code'] == 1) {
        onSuccess(responseBody['data']);
      } else {
        print('API call failed: ${responseBody['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in API call: $e');
    }
  }

  // Helper to encode query parameters for GET
  static String _encodeParams(Map<String, dynamic>? params) {
    if (params == null || params.isEmpty) return '';
    final query = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');
    return '?$query';
  }
}
// ✅ Usage Example:
//
// ApiService.callApi(
// method: 'POST',
// endpoint: ApiEndpoints.login,
// bodyOrParams: {
// 'email': 'test@abc.com',
// 'password': '123456'
// },
// onSuccess: (data) {
// // Automatically called when code == 1
// setUserData(data);
// },
// );
