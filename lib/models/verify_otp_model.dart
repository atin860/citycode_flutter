/// status : 201
/// error : null
/// messages : {"success":"Login successfully"}
/// user_detail : {"id":"992","email":"","name":"test user","city_code":"X7683","interest":"","isUserLoggedIn":true}

// ignore_for_file: camel_case_types

class Verify_otp_model {
  Verify_otp_model({
    int? status,
    dynamic error,
    Messages? messages,
    User_detail? userDetail,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _userDetail = userDetail;
  }

  Verify_otp_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _userDetail = json['user_detail'] != null
        ? User_detail.fromJson(json['userDetail'])
        : null;
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  User_detail? _userDetail;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  User_detail? get userDetail => _userDetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_userDetail != null) {
      map['user_detail'] = _userDetail?.toJson();
    }
    return map;
  }
}

/// id : "992"
/// email : ""
/// name : "test user"
/// city_code : "X7683"
/// interest : ""
/// isUserLoggedIn : true

class User_detail {
  User_detail({
    int? id,
    String? email,
    String? name,
    String? cityCode,
    String? interest,
    bool? isUserLoggedIn,
  }) {
    _id = id;
    _email = email;
    _name = name;
    _cityCode = cityCode;
    _interest = interest;
    _isUserLoggedIn = isUserLoggedIn;
  }

  User_detail.fromJson(dynamic json) {
    _id = json['id'] ?? "";
    _email = json['email'];
    _name = json['name'];
    _cityCode = json['city_code'];
    _interest = json['interest'];
    _isUserLoggedIn = json['isUserLoggedIn'];
  }
  int? _id;
  String? _email;
  String? _name;
  String? _cityCode;
  String? _interest;
  bool? _isUserLoggedIn;

  int? get id => _id;
  String? get email => _email;
  String? get name => _name;
  String? get cityCode => _cityCode;
  String? get interest => _interest;
  bool? get isUserLoggedIn => _isUserLoggedIn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['email'] = _email;
    map['name'] = _name;
    map['city_code'] = _cityCode;
    map['interest'] = _interest;
    map['isUserLoggedIn'] = _isUserLoggedIn;
    return map;
  }
}

/// success : "Login successfully"

class Messages {
  Messages({
    String? success,
  }) {
    _success = success;
  }

  Messages.fromJson(dynamic json) {
    _success = json['success'];
  }
  String? _success;

  String? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    return map;
  }
}
