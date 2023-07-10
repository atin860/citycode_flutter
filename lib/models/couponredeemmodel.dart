/// status : 201
/// error : null
/// messages : {"success":"successfully"}
/// coupon_status : "Used"

class Couponredeemmodel {
  Couponredeemmodel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? couponStatus,}){
    _status = status;
    _error = error;
    _messages = messages;
    _couponStatus = couponStatus;
}

  Couponredeemmodel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _couponStatus = json['coupon_status'];
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _couponStatus;
Couponredeemmodel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  String? couponStatus,
}) => Couponredeemmodel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  couponStatus: couponStatus ?? _couponStatus,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get couponStatus => _couponStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['coupon_status'] = _couponStatus;
    return map;
  }

}

/// success : "successfully"

class Messages {
  Messages({
      String? success,}){
    _success = success;
}

  Messages.fromJson(dynamic json) {
    _success = json['success'];
  }
  String? _success;
Messages copyWith({  String? success,
}) => Messages(  success: success ?? _success,
);
  String? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    return map;
  }

}