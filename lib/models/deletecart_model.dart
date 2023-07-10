/// status : 404
/// error : 404
/// messages : {"error":"This User Id Product Not Exist."}

class DeletecartModel {
  DeletecartModel({
      int? status, 
      int? error, 
      Messages? messages,}){
    _status = status;
    _error = error;
    _messages = messages;
}

  DeletecartModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
  }
  int? _status;
  int? _error;
  Messages? _messages;
DeletecartModel copyWith({  int? status,
  int? error,
  Messages? messages,
}) => DeletecartModel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
);
  int? get status => _status;
  int? get error => _error;
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

/// error : "This User Id Product Not Exist."

class Messages {
  Messages({
      String? error,}){
    _error = error;
}

  Messages.fromJson(dynamic json) {
    _error = json['error'];
  }
  String? _error;
Messages copyWith({  String? error,
}) => Messages(  error: error ?? _error,
);
  String? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    return map;
  }

}