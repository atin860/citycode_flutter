/// status : 201
/// error : null
/// messages : {"success":"Save successfully"}
/// userdetail : {"id":6}

class Adressmodel {
  Adressmodel({
    int? status,
    dynamic error,
    Messages? messages,
    Userdetail? userdetail,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _userdetail = userdetail;
  }

  Adressmodel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _userdetail = json['userdetail'] != null
        ? Userdetail.fromJson(json['userdetail'])
        : null;
  }

  int? _status;
  dynamic _error;
  Messages? _messages;
  Userdetail? _userdetail;

  Adressmodel copyWith({
    int? status,
    dynamic error,
    Messages? messages,
    Userdetail? userdetail,
  }) =>
      Adressmodel(
        status: status ?? _status,
        error: error ?? _error,
        messages: messages ?? _messages,
        userdetail: userdetail ?? _userdetail,
      );

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  Userdetail? get userdetail => _userdetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_userdetail != null) {
      map['userdetail'] = _userdetail?.toJson();
    }
    return map;
  }
}

/// id : 6

class Userdetail {
  Userdetail({
    int? id,
  }) {
    _id = id;
  }

  Userdetail.fromJson(dynamic json) {
    _id = json['id'];
  }

  int? _id;

  Userdetail copyWith({
    int? id,
  }) =>
      Userdetail(
        id: id ?? _id,
      );

  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }
}

/// success : "Save successfully"

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

  Messages copyWith({
    String? success,
  }) =>
      Messages(
        success: success ?? _success,
      );

  String? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    return map;
  }
}

Adressmodel addressModel = Adressmodel(
  status: 201,
  error: null,
  messages: Messages(success: "Save successfully"),
  userdetail: Userdetail(id: 6),
);
