/// status : 201
/// error : null
/// messages : {"success":"Account created successfully"}
/// userdetail : {"email":"  ","mobile":"00000126","name":"test user","family_name":"test user","gender":"male","date_of_birth":"21-09-2021","nationality":"168","stateid":"1006","cityid":"30","language":"english","device":"moto","operating_system":"8.1","phone_model":"infinix","latitude":"12345.12345","longitude":"123567.123567","location":"xyz","city_code":"C3216","profile":"","customer_type":"customer","id":981}
/// image_base_url : "http://185.188.127.11/public/users/"

// ignore_for_file: camel_case_types

class Registration_model {
  Registration_model({
    int? status,
    dynamic error,
    Messages? messages,
    Userdetail? userdetail,
    String? imageBaseUrl,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _userdetail = userdetail;
    _imageBaseUrl = imageBaseUrl;
  }

  Registration_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _userdetail = json['userdetail'] != null
        ? Userdetail.fromJson(json['userdetail'])
        : null;
    _imageBaseUrl = json['image_base_url'];
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  Userdetail? _userdetail;
  String? _imageBaseUrl;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  Userdetail? get userdetail => _userdetail;
  String? get imageBaseUrl => _imageBaseUrl;

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
    map['image_base_url'] = _imageBaseUrl;
    return map;
  }
}

/// email : "  "
/// mobile : "00000126"
/// name : "test user"
/// family_name : "test user"
/// gender : "male"
/// date_of_birth : "21-09-2021"
/// nationality : "168"
/// stateid : "1006"
/// cityid : "30"
/// language : "english"
/// device : "moto"
/// operating_system : "8.1"
/// phone_model : "infinix"
/// latitude : "12345.12345"
/// longitude : "123567.123567"
/// location : "xyz"
/// city_code : "C3216"
/// profile : ""
/// customer_type : "customer"
/// id : 981

class Userdetail {
  Userdetail({
    String? email,
    String? mobile,
    String? name,
    String? familyName,
    String? gender,
    String? dateOfBirth,
    String? nationality,
    String? stateid,
    String? cityid,
    String? language,
    String? device,
    String? operatingSystem,
    String? phoneModel,
    String? latitude,
    String? longitude,
    String? location,
    String? cityCode,
    String? profile,
    String? customerType,
    int? id,
  }) {
    _email = email;
    _mobile = mobile;
    _name = name;
    _familyName = familyName;
    _gender = gender;
    _dateOfBirth = dateOfBirth;
    _nationality = nationality;
    _stateid = stateid;
    _cityid = cityid;
    _language = language;
    _device = device;
    _operatingSystem = operatingSystem;
    _phoneModel = phoneModel;
    _latitude = latitude;
    _longitude = longitude;
    _location = location;
    _cityCode = cityCode;
    _profile = profile;
    _customerType = customerType;
    _id = id;
  }

  Userdetail.fromJson(dynamic json) {
    _email = json['email'];
    _mobile = json['mobile'];
    _name = json['name'];
    _familyName = json['family_name'];
    _gender = json['gender'];
    _dateOfBirth = json['date_of_birth'];
    _nationality = json['nationality'];
    _stateid = json['stateid'];
    _cityid = json['cityid'];
    _language = json['language'];
    _device = json['device'];
    _operatingSystem = json['operating_system'];
    _phoneModel = json['phone_model'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _location = json['location'];
    _cityCode = json['city_code'];
    _profile = json['profile'];
    _customerType = json['customer_type'];
    _id = json['id'];
  }
  String? _email;
  String? _mobile;
  String? _name;
  String? _familyName;
  String? _gender;
  String? _dateOfBirth;
  String? _nationality;
  String? _stateid;
  String? _cityid;
  String? _language;
  String? _device;
  String? _operatingSystem;
  String? _phoneModel;
  String? _latitude;
  String? _longitude;
  String? _location;
  String? _cityCode;
  String? _profile;
  String? _customerType;
  int? _id;

  String? get email => _email;
  String? get mobile => _mobile;
  String? get name => _name;
  String? get familyName => _familyName;
  String? get gender => _gender;
  String? get dateOfBirth => _dateOfBirth;
  String? get nationality => _nationality;
  String? get stateid => _stateid;
  String? get cityid => _cityid;
  String? get language => _language;
  String? get device => _device;
  String? get operatingSystem => _operatingSystem;
  String? get phoneModel => _phoneModel;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get location => _location;
  String? get cityCode => _cityCode;
  String? get profile => _profile;
  String? get customerType => _customerType;
  int? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['name'] = _name;
    map['family_name'] = _familyName;
    map['gender'] = _gender;
    map['date_of_birth'] = _dateOfBirth;
    map['nationality'] = _nationality;
    map['stateid'] = _stateid;
    map['cityid'] = _cityid;
    map['language'] = _language;
    map['device'] = _device;
    map['operating_system'] = _operatingSystem;
    map['phone_model'] = _phoneModel;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['location'] = _location;
    map['city_code'] = _cityCode;
    map['profile'] = _profile;
    map['customer_type'] = _customerType;
    map['id'] = _id;
    return map;
  }
}

/// success : "Account created successfully"

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
