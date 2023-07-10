/// status : 201
/// error : null
/// messages : {"success":"Filters listed successfully"}
/// state_list : [{"state_id":"1001","state_name":"Ad Dakhiliyah","arb_state_name":"محافظة الداخلية","country_id":"165","status":"1"},{"state_id":"1003","state_name":"Al Batinah North","arb_state_name":"محافظة شمال الباطنة","country_id":"165","status":"1"},{"state_id":"1004","state_name":"Al Batinah South","arb_state_name":"محافظة جنوب الباطنة","country_id":"165","status":"1"},{"state_id":"1005","state_name":"Al Buraimi","arb_state_name":"محافظة البريمي","country_id":"165","status":"1"},{"state_id":"1002","state_name":"Al Dhahirah","arb_state_name":"محافظة الظاهرة","country_id":"165","status":"1"},{"state_id":"1006","state_name":"Al Wusta","arb_state_name":"محافظة الوسطى","country_id":"165","status":"1"},{"state_id":"1007","state_name":"Ash Sharqiyah North","arb_state_name":"محافظة شمال الشرقية","country_id":"165","status":"1"},{"state_id":"1008","state_name":"Ash Sharqiyah South","arb_state_name":"محافظة جنوب الشرقية","country_id":"165","status":"1"},{"state_id":"1009","state_name":"Dhofar","arb_state_name":"محافظة ظفار","country_id":"165","status":"1"},{"state_id":"1011","state_name":"Musandam","arb_state_name":"محافظة مسندم","country_id":"165","status":"1"},{"state_id":"1010","state_name":"Muscat","arb_state_name":"محافظة مسقط","country_id":"165","status":"1"}]

// ignore_for_file: camel_case_types

class State_model {
  State_model({
    int? status,
    dynamic error,
    Messages? messages,
    List<State_list>? stateList,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _stateList = stateList;
  }

  State_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    if (json['state_list'] != null) {
      _stateList = [];
      json['state_list'].forEach((v) {
        _stateList?.add(State_list.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  List<State_list>? _stateList;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  List<State_list>? get stateList => _stateList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_stateList != null) {
      map['state_list'] = _stateList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// state_id : "1001"
/// state_name : "Ad Dakhiliyah"
/// arb_state_name : "محافظة الداخلية"
/// country_id : "165"
/// status : "1"

class State_list {
  State_list({
    String? stateId,
    String? stateName,
    String? arbStateName,
    String? countryId,
    String? status,
  }) {
    _stateId = stateId;
    _stateName = stateName;
    _arbStateName = arbStateName;
    _countryId = countryId;
    _status = status;
  }

  State_list.fromJson(dynamic json) {
    _stateId = json['state_id'];
    _stateName = json['state_name'];
    _arbStateName = json['arb_state_name'];
    _countryId = json['country_id'];
    _status = json['status'];
  }
  String? _stateId;
  String? _stateName;
  String? _arbStateName;
  String? _countryId;
  String? _status;

  String? get stateId => _stateId;
  String? get stateName => _stateName;
  String? get arbStateName => _arbStateName;
  String? get countryId => _countryId;
  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['state_id'] = _stateId;
    map['state_name'] = _stateName;
    map['arb_state_name'] = _arbStateName;
    map['country_id'] = _countryId;
    map['status'] = _status;
    return map;
  }
}

/// success : "Filters listed successfully"

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
