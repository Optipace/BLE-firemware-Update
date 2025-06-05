import 'package:tracker_firmware/Const_TermAndFunction/entity/userData.dart';

class ApiHeaders {
  // Default constructor - no parameters
  ApiHeaders();

  Map<String, String> get header => {
        'Authorization': 'Bearer ${UserData().accessToken}',
        'Content-Type': 'application/json',
      };
}
