/// status : 201
/// error : null
/// messages : {"success":"Otp generated successfully"}
/// optno : "4953"
/// mobile : "96825252525"

// ignore_for_file: camel_case_types

class Otp_model {
  Otp_model({
    int? status,
    dynamic error,
    Messages? messages,
    String? optno,
    String? mobile,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _optno = optno;
    _mobile = mobile;
  }

  Otp_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _optno = json['optno'];
    _mobile = json['mobile'];
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _optno;
  String? _mobile;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get optno => _optno;
  String? get mobile => _mobile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['optno'] = _optno;
    map['mobile'] = _mobile;
    return map;
  }
}

/// success : "Otp generated successfully"

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
