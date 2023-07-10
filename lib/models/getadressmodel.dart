// ignore_for_file: prefer_void_to_null, unnecessary_question_mark, duplicate_ignore, dead_code, unnecessary_getters_setters, prefer_collection_literals

class GetAddressModel {
  int? _status;
  Null? _error;
  Messages? _messages;
  List<ListAddress>? _listAddress;

  GetAddressModel({
    int? status,
    Null? error,
    Messages? messages,
    List<ListAddress>? listAddress,
  })  : _status = status,
        _error = error,
        _messages = messages,
        _listAddress = listAddress;

  int? get status => _status;
  set status(int? status) => _status = status;
  Null? get error => _error;
  set error(Null? error) => _error = error;
  Messages? get messages => _messages;
  set messages(Messages? messages) => _messages = messages;
  List<ListAddress>? get listAddress => _listAddress;
  set listAddress(List<ListAddress>? listAddress) => _listAddress = listAddress;

  GetAddressModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'] as int?;
    _error = json['error'] as Null?;
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;

    if (json['list_address'] != null) {
      _listAddress = <ListAddress>[];
      json['list_address'].forEach((v) {
        _listAddress!.add(ListAddress.fromJson(v));
      });
    } else {
      _listAddress = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['error'] = _error;
    if (_messages != null) {
      data['messages'] = _messages!.toJson();
    }
    if (_listAddress != null) {
      data['list_address'] = _listAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Messages {
  String? _success;

  Messages({String? success}) : _success = success;

  String? get success => _success;
  set success(String? success) => _success = success;

  Messages.fromJson(Map<String, dynamic> json) {
    _success = json['success'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = _success;
    return data;
  }
}

class ListAddress {
  String? _id;
  String? _userId;
  String? _name;
  String? _governate;
  String? _state;
  String? _houseNo;
  String? _phone;
  String? _addressType;
  String? _block;
  String? _street;
  String? _way;
  String? _building;
  String? _floor;
  String? _apartmentNo;
  String? _office;
  String? _additionalDirections;
  String? _latitude;
  String? _longitude;

  ListAddress({
    String? id,
    String? userId,
    String? name,
    String? governate,
    String? state,
    String? houseNo,
    String? phone,
    String? addressType,
    String? block,
    String? street,
    String? way,
    String? building,
    String? floor,
    String? apartmentNo,
    String? office,
    String? additionalDirections,
    String? latitude,
    String? longitude,
  })  : _id = id,
        _userId = userId,
        _name = name,
        _governate = governate,
        _state = state,
        _houseNo = houseNo,
        _phone = phone,
        _addressType = addressType,
        _block = block,
        _street = street,
        _way = way,
        _building = building,
        _floor = floor,
        _apartmentNo = apartmentNo,
        _office = office,
        _additionalDirections = additionalDirections,
        _latitude = latitude,
        _longitude = longitude;

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get governate => _governate;
  set governate(String? governate) => _governate = governate;
  String? get state => _state;
  set state(String? state) => _state = state;
  String? get houseNo => _houseNo;
  set houseNo(String? houseNo) => _houseNo = houseNo;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get addressType => _addressType;
  set addressType(String? addressType) => _addressType = addressType;
  String? get block => _block;
  set block(String? block) => _block = block;
  String? get street => _street;
  set street(String? street) => _street = street;
  String? get way => _way;
  set way(String? way) => _way = way;
  String? get building => _building;
  set building(String? building) => _building = building;
  String? get floor => _floor;
  set floor(String? floor) => _floor = floor;
  String? get apartmentNo => _apartmentNo;
  set apartmentNo(String? apartmentNo) => _apartmentNo = apartmentNo;
  String? get office => _office;
  set office(String? office) => _office = office;
  String? get additionalDirections => _additionalDirections;
  set additionalDirections(String? additionalDirections) =>
      _additionalDirections = additionalDirections;
  String? get latitude => _latitude;
  set latitude(String? latitude) => _latitude = latitude;
  String? get longitude => _longitude;
  set longitude(String? longitude) => _longitude = longitude;

  ListAddress.fromJson(Map<String, dynamic> json) {
    _id = json['id'] as String?;
    _userId = json['user_id'] as String?;
    _name = json['name'] as String?;
    _governate = json['governate'] as String?;
    _state = json['state'] as String?;
    _houseNo = json['house_no'] as String?;
    _phone = json['phone'] as String?;
    _addressType = json['address_type'] as String?;
    _block = json['block'] as String?;
    _street = json['street'] as String?;
    _way = json['way'] as String?;
    _building = json['building'] as String?;
    _floor = json['floor'] as String?;
    _apartmentNo = json['apartment_no'] as String?;
    _office = json['office'] as String?;
    _additionalDirections = json['additional_directions'] as String?;
    _latitude = json['latitude'] as String?;
    _longitude = json['longitude'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['name'] = _name;
    data['governate'] = _governate;
    data['state'] = _state;
    data['house_no'] = _houseNo;
    data['phone'] = _phone;
    data['address_type'] = _addressType;
    data['block'] = _block;
    data['street'] = _street;
    data['way'] = _way;
    data['building'] = _building;
    data['floor'] = _floor;
    data['apartment_no'] = _apartmentNo;
    data['office'] = _office;
    data['additional_directions'] = _additionalDirections;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    return data;
  }
}
