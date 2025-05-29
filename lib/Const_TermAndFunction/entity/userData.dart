class UserData {
  static final UserData _instance = UserData._internal();

  @override
  String toString() {
    return 'UserData{_userId: $_userId, _name: $_name, _email: $_email, _phone: $_phone, '
        '_designationCode: $_designationCode, _empRegisteredId: $_empRegisteredId,'
        ' _designation: $_designation, _UUID: $_UUID, _accessToken: $_accessToken, '
        '_refreshToken: $_refreshToken, _status: $_status _deviceModel: $_deviceModel, _osVersion: $_osVersion}';
  }

  factory UserData() => _instance;

  UserData._internal();

  // User data fields

  String _userId = '';
  String _name = '';
  String _email = '';
  String _phone = '';
  String _designationCode = '';
  String _empRegisteredId = "";
  String _designation = '';
  String _UUID = "";
  String _accessToken = "";
  String _refreshToken = "";
  String _status = "";
  String _deviceModel = "";
  String _osVersion = "";

  // Optional: Reset all fields on logout
  // Clear all fields
  void clear() {
    _userId = '';
    _name = '';
    _email = '';
    _phone = '';
    _designationCode = '';
    _empRegisteredId = '';
    _designation = '';
    _UUID = '';
    _accessToken = '';
    _refreshToken = '';
    _status = '';
  }

  // Load from JSON
  void fromJson(Map<String, dynamic> json) {
    _userId = json['userId'] ?? '';
    _name = json['name'] ?? '';
    _email = json['email'] ?? '';
    _phone = json['phone'] ?? '';
    _designationCode = json['designationCode'] ?? '';
    _empRegisteredId = json['empRegisteredId'] ?? '';
    _designation = json['designation'] ?? '';
    _UUID = json['UUID'] ?? '';
    _accessToken = json['accessToken'] ?? '';
    _refreshToken = json['refreshToken'] ?? '';
    _status = json['status'] ?? '';
    _osVersion = json['osVersion'] ?? '';
    _deviceModel = json['deviceModel'] ?? '';
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': _userId,
      'name': _name,
      'email': _email,
      'phone': _phone,
      'designationCode': _designationCode,
      'empRegisteredId': _empRegisteredId,
      'designation': _designation,
      'UUID': _UUID,
      'accessToken': _accessToken,
      'refreshToken': _refreshToken,
      'status': _status,
      'deviceModel': _deviceModel,
      'osVersion': _osVersion,
    };
  }

  //getters
  static UserData get instance => _instance;

  String get UUID => _UUID;

  String get status => _status;

  String get refreshToken => _refreshToken;

  String get accessToken => _accessToken;

  String get designation => _designation;

  String get empRegisteredId => _empRegisteredId;

  String get designationCode => _designationCode;

  String get phone => _phone;

  String get email => _email;

  String get name => _name;

  String get userId => _userId;

  String get deviceModel => _deviceModel;

  String get osVersion => _osVersion;

  // Setters
  set userId(String value) {
    _userId = value;
  }

  set refreshToken(String value) {
    _refreshToken = value;
  }

  set status(String value) {
    _status = value;
  }

  set accessToken(String value) {
    _accessToken = value;
  }

  set designation(String value) {
    _designation = value;
  }

  set empRegisteredId(String value) {
    _empRegisteredId = value;
  }

  set designationCode(String value) {
    _designationCode = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set email(String value) {
    _email = value;
  }

  set name(String value) {
    _name = value;
  }

  set UUID(String value) {
    _UUID = value;
  }

  set osVersion(String value) {
    _osVersion = value;
  }

  set deviceModel(String value) {
    _deviceModel = value;
  }
}
