/// status : 201
/// error : null
/// messages : {"success":"Mall listed successfully"}
/// mall_data : [{"id":"3","mall_name":"Araimi Boulevard ","arabic_mall_name":"العريمي بوليفارد"},{"id":"8","mall_name":"Araimi Complex Mall","arabic_mall_name":"مجمع العريمي "},{"id":"7","mall_name":"Avenues Mall","arabic_mall_name":"افنيوز مول\t"},{"id":"2","mall_name":"City Centre Muscat ","arabic_mall_name":"ستي سنتر مسقط"},{"id":"4","mall_name":"Grand Mall Muscat ","arabic_mall_name":"مسقط جراند مول "},{"id":"6","mall_name":"Oman Mall","arabic_mall_name":"مول عمان"}]

class MallListModel {
  MallListModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      List<MallData>? mallData,}){
    _status = status;
    _error = error;
    _messages = messages;
    _mallData = mallData;
}

  MallListModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    if (json['mall_data'] != null) {
      _mallData = [];
      json['mall_data'].forEach((v) {
        _mallData?.add(MallData.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  List<MallData>? _mallData;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  List<MallData>? get mallData => _mallData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_mallData != null) {
      map['mall_data'] = _mallData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "3"
/// mall_name : "Araimi Boulevard "
/// arabic_mall_name : "العريمي بوليفارد"

class MallData {
  MallData({
      String? id, 
      String? mallName, 
      String? arabicMallName,}){
    _id = id;
    _mallName = mallName;
    _arabicMallName = arabicMallName;
}

  MallData.fromJson(dynamic json) {
    _id = json['id'];
    _mallName = json['mall_name'];
    _arabicMallName = json['arabic_mall_name'];
  }
  String? _id;
  String? _mallName;
  String? _arabicMallName;

  String? get id => _id;
  String? get mallName => _mallName;
  String? get arabicMallName => _arabicMallName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['mall_name'] = _mallName;
    map['arabic_mall_name'] = _arabicMallName;
    return map;
  }

}

/// success : "Mall listed successfully"

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