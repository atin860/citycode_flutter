/// status : 201
/// error : null
/// messages : {"success":"City list successfully"}
/// city_list : [{"city_id":"4","city_name":"Adam","city_arb_name":"ولاية أدم","state_id":"1001","status":"1"},{"city_id":"5","city_name":"Al Hamra","city_arb_name":"ولاية الحمراء","state_id":"1001","status":"1"},{"city_id":"3","city_name":"Bahla","city_arb_name":"ولاية بهلا","state_id":"1001","status":"1"},{"city_id":"8","city_name":"Bidbid","city_arb_name":"ولاية بدبد","state_id":"1001","status":"1"},{"city_id":"7","city_name":"Izki","city_arb_name":"ولاية إزكي","state_id":"1001","status":"1"},{"city_id":"6","city_name":"Manah","city_arb_name":"ولاية منح","state_id":"1001","status":"1"},{"city_id":"1","city_name":"Nizwa","city_arb_name":"ولاية نزوى","state_id":"1001","status":"1"},{"city_id":"2","city_name":"Samail","city_arb_name":"ولاية سمائل","state_id":"1001","status":"1"}]

// ignore_for_file: camel_case_types

class City_model {
  City_model({
    int? status,
    dynamic error,
    Messages? messages,
    List<City_list>? cityList,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _cityList = cityList;
  }

  City_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    if (json['city_list'] != null) {
      _cityList = [];
      json['city_list'].forEach((v) {
        _cityList?.add(City_list.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  List<City_list>? _cityList;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  List<City_list>? get cityList => _cityList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_cityList != null) {
      map['city_list'] = _cityList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// city_id : "4"
/// city_name : "Adam"
/// city_arb_name : "ولاية أدم"
/// state_id : "1001"
/// status : "1"

class City_list {
  City_list({
    String? cityId,
    String? cityName,
    String? cityArbName,
    String? stateId,
    String? status,
  }) {
    _cityId = cityId;
    _cityName = cityName;
    _cityArbName = cityArbName;
    _stateId = stateId;
    _status = status;
  }

  City_list.fromJson(dynamic json) {
    _cityId = json['city_id'];
    _cityName = json['city_name'];
    _cityArbName = json['city_arb_name'];
    _stateId = json['state_id'];
    _status = json['status'];
  }
  String? _cityId;
  String? _cityName;
  String? _cityArbName;
  String? _stateId;
  String? _status;

  String? get cityId => _cityId;
  String? get cityName => _cityName;
  String? get cityArbName => _cityArbName;
  String? get stateId => _stateId;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city_id'] = _cityId;
    map['city_name'] = _cityName;
    map['city_arb_name'] = _cityArbName;
    map['state_id'] = _stateId;
    map['status'] = _status;
    return map;
  }
}

/// success : "City list successfully"

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
