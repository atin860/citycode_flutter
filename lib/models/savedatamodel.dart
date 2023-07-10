/// status : 201
/// error : null
/// messages : {"success":"Order Save successfully"}
/// userdetail : {"order_id":4}

// ignore_for_file: non_constant_identifier_names

class Savedatamodel {
  Savedatamodel({
    int? status,
    dynamic error,
    Messages? messages,
    Userdetails? userdetail,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _userdetail = userdetail;
  }

  Savedatamodel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _userdetail = json['userdetail'] != null
        ? Userdetails.fromJson(json['userdetail'])
        : null;
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  Userdetails? _userdetail;
  Savedatamodel copyWith({
    int? status,
    dynamic error,
    Messages? messages,
    Userdetails? userdetail,
  }) =>
      Savedatamodel(
        status: status ?? _status,
        error: error ?? _error,
        messages: messages ?? _messages,
        userdetail: userdetail ?? _userdetail,
      );
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  Userdetails? get userdetail => _userdetail;

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

/// order_id : 4

class Userdetails {
  Userdetail({
    int? orderId,
  }) {
    _orderId = orderId;
  }

  Userdetails.fromJson(dynamic json) {
    _orderId = json['order_id'];
  }
  int? _orderId;
  Userdetails copyWith({
    int? orderId,
  }) =>
      Userdetail(
        orderId: orderId ?? _orderId,
      );
  int? get orderId => _orderId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    return map;
  }
}

/// success : "Order Save successfully"

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
