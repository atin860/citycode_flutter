/// status : 201
/// error : null
/// messages : {"success":"Offer listed successfully"}
/// offerdata_data : [{"st_id":"2","st_name":"All Items","st_arb_name":"جميع المنتجات","st_group":"discounttype"},{"st_id":"1","st_name":"Buy 1 Get 1","st_arb_name":"اشتري 1 واحصل على 1","st_group":"discounttype"},{"st_id":"9","st_name":"COUPONS ","st_arb_name":"كوبون","st_group":"discounttype"},{"st_id":"3","st_name":"Selected Items","st_arb_name":"منتجات مختاره","st_group":"discounttype"}]

class DiscountTypeModel {
  DiscountTypeModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      List<OfferdataData>? offerdataData,}){
    _status = status;
    _error = error;
    _messages = messages;
    _offerdataData = offerdataData;
}

  DiscountTypeModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    if (json['offerdata_data'] != null) {
      _offerdataData = [];
      json['offerdata_data'].forEach((v) {
        _offerdataData?.add(OfferdataData.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  List<OfferdataData>? _offerdataData;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  List<OfferdataData>? get offerdataData => _offerdataData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_offerdataData != null) {
      map['offerdata_data'] = _offerdataData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// st_id : "2"
/// st_name : "All Items"
/// st_arb_name : "جميع المنتجات"
/// st_group : "discounttype"

class OfferdataData {
  OfferdataData({
      String? stId, 
      String? stName, 
      String? stArbName, 
      String? stGroup,}){
    _stId = stId;
    _stName = stName;
    _stArbName = stArbName;
    _stGroup = stGroup;
}

  OfferdataData.fromJson(dynamic json) {
    _stId = json['st_id'];
    _stName = json['st_name'];
    _stArbName = json['st_arb_name'];
    _stGroup = json['st_group'];
  }
  String? _stId;
  String? _stName;
  String? _stArbName;
  String? _stGroup;

  String? get stId => _stId;
  String? get stName => _stName;
  String? get stArbName => _stArbName;
  String? get stGroup => _stGroup;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['st_id'] = _stId;
    map['st_name'] = _stName;
    map['st_arb_name'] = _stArbName;
    map['st_group'] = _stGroup;
    return map;
  }

}

/// success : "Offer listed successfully"

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