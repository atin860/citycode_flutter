/// status : 201
/// error : null
/// messages : {"success":"points updated successfully"}

class TransferPointsModel {
  TransferPointsModel({
      int? status, 
      dynamic error, 
      Messages? messages,}){
    _status = status;
    _error = error;
    _messages = messages;
}

  TransferPointsModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
  }
  int? _status;
  dynamic _error;
  Messages? _messages;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    return map;
  }

}

/// success : "points updated successfully"

class Messages {
  Messages({
      String? success,}){
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