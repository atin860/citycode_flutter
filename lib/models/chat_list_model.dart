/// status : 201
/// error : null
/// messages : {"success":"User listed successfully"}
/// image_url : "http://185.188.127.11/public/users/"
/// Userlist : [{"id":"238","city_code":"X7689","username":"","name":"Shivangi anand","arb_name":"","profile":"772249619_scaled_image_picker7480021561637361202.jpg","mobile":"25252525"},{"id":"463","city_code":"C6853","username":"","name":"test user","arb_name":"","profile":"429545592_Screenshot_20211112_195323.jpg","mobile":"00000078"},{"id":"595","city_code":"A4567","username":"","name":"abdullah","arb_name":"","profile":"1067186485_jujutsukaisen.jpg","mobile":"79977557"},{"id":"499","city_code":"N5893","username":"","name":"test user","arb_name":"","profile":"","mobile":"00000079"}]

// ignore_for_file: non_constant_identifier_names

class ChatListModel {
  ChatListModel({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageUrl,
    List<Userlist>? userlist,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageUrl = imageUrl;
    _userlist = userlist;
  }

  ChatListModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageUrl = json['image_url'];
    if (json['Userlist'] != null) {
      _userlist = [];
      json['Userlist'].forEach((v) {
        _userlist?.add(Userlist.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageUrl;
  List<Userlist>? _userlist;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageUrl => _imageUrl;
  List<Userlist>? get userlist => _userlist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_url'] = _imageUrl;
    if (_userlist != null) {
      map['Userlist'] = _userlist?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "238"
/// city_code : "X7689"
/// username : ""
/// name : "Shivangi anand"
/// arb_name : ""
/// profile : "772249619_scaled_image_picker7480021561637361202.jpg"
/// mobile : "25252525"

class Userlist {
  Userlist({
    String? id,
    String? cityCode,
    String? username,
    String? name,
    String? arbName,
    String? profile,
    String? mobile,
    int? unread_status,
  }) {
    _id = id;
    _cityCode = cityCode;
    _username = username;
    _name = name;
    _arbName = arbName;
    _profile = profile;
    _mobile = mobile;
    _unread_status = unread_status;
  }

  Userlist.fromJson(dynamic json) {
    _id = json['id'];
    _cityCode = json['city_code'];
    _username = json['username'];
    _name = json['name'];
    _arbName = json['arb_name'];
    _profile = json['profile'];
    _mobile = json['mobile'];
    _unread_status = json['unread_status'];
  }
  String? _id;
  String? _cityCode;
  String? _username;
  String? _name;
  String? _arbName;
  String? _profile;
  String? _mobile;
  int? _unread_status;

  String? get id => _id;
  String? get cityCode => _cityCode;
  String? get username => _username;
  String? get name => _name;
  String? get arbName => _arbName;
  String? get profile => _profile;
  String? get mobile => _mobile;
  int? get unread_status => _unread_status;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['city_code'] = _cityCode;
    map['username'] = _username;
    map['name'] = _name;
    map['arb_name'] = _arbName;
    map['profile'] = _profile;
    map['mobile'] = _mobile;
    map['unread_status'] = _unread_status;
    return map;
  }
}

/// success : "User listed successfully"

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
