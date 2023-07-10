/// status : 201
/// error : null
/// messages : {"success":"User detail"}
/// image_base_url : "http://185.188.127.11/public/users/"
/// code : "V.I.P Code"
/// userdetail : [{"id":"327","city_code":"U3859","vip_code":"M8000","vip_plus":"false","name":"وزارة العمل","customer_type":"vip","arb_name":"","username":"","family_name":"","mobile":"24344025","password":"","email":"","language":"arabic","interest":"1,2,4,5,6,7,8,9,10,11,12,13,14,15","gender":"Male","profile":"download.png","date_of_birth":"","governorate":"","nationality":"0","state":"","stateid":"1010","cityid":"0","commission":"0","totalpoint":"50","totalsaveamount":"0","start_date":"2021-09-01","end_date":"2021-12-31","android_token":"","status":"1","created_date":"2021-09-02 20:19:16","updated_date":"0000-00-00 00:00:00","device":"","operating_system":"","phone_model":"","latitude":"","longitude":"","location":"","delete_status":"0","new_mob_no":"","state_name":"Muscat","arb_state_name":"محافظة مسقط","city_name":"","city_arb_name":"","country_enNationality":"","country_arNationality":""}]

// ignore_for_file: non_constant_identifier_names

class CodeDetailsModel {
  CodeDetailsModel({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageBaseUrl,
    String? code,
    List<Userdetail>? userdetail,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _code = code;
    _userdetail = userdetail;
  }

  CodeDetailsModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    _code = json['code'];
    if (json['userdetail'] != null) {
      _userdetail = [];
      json['userdetail'].forEach((v) {
        _userdetail?.add(Userdetail.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  String? _code;
  List<Userdetail>? _userdetail;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  String? get code => _code;
  List<Userdetail>? get userdetail => _userdetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    map['code'] = _code;
    if (_userdetail != null) {
      map['userdetail'] = _userdetail?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "327"
/// city_code : "U3859"
/// vip_code : "M8000"
/// vip_plus : "false"
/// name : "وزارة العمل"
/// customer_type : "vip"
/// arb_name : ""
/// username : ""
/// family_name : ""
/// mobile : "24344025"
/// password : ""
/// email : ""
/// language : "arabic"
/// interest : "1,2,4,5,6,7,8,9,10,11,12,13,14,15"
/// gender : "Male"
/// profile : "download.png"
/// date_of_birth : ""
/// governorate : ""
/// nationality : "0"
/// state : ""
/// stateid : "1010"
/// cityid : "0"
/// commission : "0"
/// totalpoint : "50"
/// totalsaveamount : "0"
/// start_date : "2021-09-01"
/// end_date : "2021-12-31"
/// android_token : ""
/// status : "1"
/// created_date : "2021-09-02 20:19:16"
/// updated_date : "0000-00-00 00:00:00"
/// device : ""
/// operating_system : ""
/// phone_model : ""
/// latitude : ""
/// longitude : ""
/// location : ""
/// delete_status : "0"
/// new_mob_no : ""
/// state_name : "Muscat"
/// arb_state_name : "محافظة مسقط"
/// city_name : ""
/// city_arb_name : ""
/// country_enNationality : ""
/// country_arNationality : ""

class Userdetail {
  Userdetail(
      {String? id,
      String? cityCode,
      String? vipCode,
      String? vipPlus,
      String? name,
      String? customerType,
      String? arbName,
      String? username,
      String? familyName,
      String? mobile,
      String? password,
      String? email,
      String? language,
      String? interest,
      String? gender,
      String? profile,
      String? dateOfBirth,
      String? governorate,
      String? nationality,
      String? state,
      String? stateid,
      String? cityid,
      String? commission,
      String? totalpoint,
      String? totalsaveamount,
      String? startDate,
      String? endDate,
      String? androidToken,
      String? status,
      String? createdDate,
      String? updatedDate,
      String? device,
      String? operatingSystem,
      String? phoneModel,
      String? latitude,
      String? longitude,
      String? location,
      String? deleteStatus,
      String? newMobNo,
      String? stateName,
      String? arbStateName,
      String? cityName,
      String? cityArbName,
      String? countryEnNationality,
      String? countryArNationality,
      String? org_status}) {
    _id = id;
    _cityCode = cityCode;
    _vipCode = vipCode;
    _vipPlus = vipPlus;
    _name = name;
    _customerType = customerType;
    _arbName = arbName;
    _username = username;
    _familyName = familyName;
    _mobile = mobile;
    _password = password;
    _email = email;
    _language = language;
    _interest = interest;
    _gender = gender;
    _profile = profile;
    _dateOfBirth = dateOfBirth;
    _governorate = governorate;
    _nationality = nationality;
    _state = state;
    _stateid = stateid;
    _cityid = cityid;
    _commission = commission;
    _totalpoint = totalpoint;
    _totalsaveamount = totalsaveamount;
    _startDate = startDate;
    _endDate = endDate;
    _androidToken = androidToken;
    _status = status;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
    _device = device;
    _operatingSystem = operatingSystem;
    _phoneModel = phoneModel;
    _latitude = latitude;
    _longitude = longitude;
    _location = location;
    _deleteStatus = deleteStatus;
    _newMobNo = newMobNo;
    _stateName = stateName;
    _arbStateName = arbStateName;
    _cityName = cityName;
    _cityArbName = cityArbName;
    _countryEnNationality = countryEnNationality;
    _countryArNationality = countryArNationality;
    _orgstatus = org_status;
  }

  Userdetail.fromJson(dynamic json) {
    _id = json['id'];
    _cityCode = json['city_code'];
    _vipCode = json['vip_code'];
    _vipPlus = json['vip_plus'];
    _name = json['name'];
    _customerType = json['customer_type'];
    _arbName = json['arb_name'];
    _username = json['username'];
    _familyName = json['family_name'];
    _mobile = json['mobile'];
    _password = json['password'];
    _email = json['email'];
    _language = json['language'];
    _interest = json['interest'];
    _gender = json['gender'];
    _profile = json['profile'];
    _dateOfBirth = json['date_of_birth'];
    _governorate = json['governorate'];
    _nationality = json['nationality'];
    _state = json['state'];
    _stateid = json['stateid'];
    _cityid = json['cityid'];
    _commission = json['commission'];
    _totalpoint = json['totalpoint'];
    _totalsaveamount = json['totalsaveamount'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _androidToken = json['android_token'];
    _status = json['status'];
    _createdDate = json['created_date'];
    _updatedDate = json['updated_date'];
    _device = json['device'];
    _operatingSystem = json['operating_system'];
    _phoneModel = json['phone_model'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _location = json['location'];
    _deleteStatus = json['delete_status'];
    _newMobNo = json['new_mob_no'];
    _stateName = json['state_name'];
    _arbStateName = json['arb_state_name'];
    _cityName = json['city_name'];
    _cityArbName = json['city_arb_name'];
    _countryEnNationality = json['country_enNationality'];
    _countryArNationality = json['country_arNationality'];
    _orgstatus = json['org_status'];
  }
  String? _id;
  String? _cityCode;
  String? _vipCode;
  String? _vipPlus;
  String? _name;
  String? _customerType;
  String? _arbName;
  String? _username;
  String? _familyName;
  String? _mobile;
  String? _password;
  String? _email;
  String? _language;
  String? _interest;
  String? _gender;
  String? _profile;
  String? _dateOfBirth;
  String? _governorate;
  String? _nationality;
  String? _state;
  String? _stateid;
  String? _cityid;
  String? _commission;
  String? _totalpoint;
  String? _totalsaveamount;
  String? _startDate;
  String? _endDate;
  String? _androidToken;
  String? _status;
  String? _createdDate;
  String? _updatedDate;
  String? _device;
  String? _operatingSystem;
  String? _phoneModel;
  String? _latitude;
  String? _longitude;
  String? _location;
  String? _deleteStatus;
  String? _newMobNo;
  String? _stateName;
  String? _arbStateName;
  String? _cityName;
  String? _cityArbName;
  String? _countryEnNationality;
  String? _countryArNationality;
  String? _orgstatus;

  String? get id => _id;
  String? get cityCode => _cityCode;
  String? get vipCode => _vipCode;
  String? get vipPlus => _vipPlus;
  String? get name => _name;
  String? get customerType => _customerType;
  String? get arbName => _arbName;
  String? get username => _username;
  String? get familyName => _familyName;
  String? get mobile => _mobile;
  String? get password => _password;
  String? get email => _email;
  String? get language => _language;
  String? get interest => _interest;
  String? get gender => _gender;
  String? get profile => _profile;
  String? get dateOfBirth => _dateOfBirth;
  String? get governorate => _governorate;
  String? get nationality => _nationality;
  String? get state => _state;
  String? get stateid => _stateid;
  String? get cityid => _cityid;
  String? get commission => _commission;
  String? get totalpoint => _totalpoint;
  String? get totalsaveamount => _totalsaveamount;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get androidToken => _androidToken;
  String? get status => _status;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;
  String? get device => _device;
  String? get operatingSystem => _operatingSystem;
  String? get phoneModel => _phoneModel;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get location => _location;
  String? get deleteStatus => _deleteStatus;
  String? get newMobNo => _newMobNo;
  String? get stateName => _stateName;
  String? get arbStateName => _arbStateName;
  String? get cityName => _cityName;
  String? get cityArbName => _cityArbName;
  String? get countryEnNationality => _countryEnNationality;
  String? get countryArNationality => _countryArNationality;
  String? get org_status => _orgstatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['city_code'] = _cityCode;
    map['vip_code'] = _vipCode;
    map['vip_plus'] = _vipPlus;
    map['name'] = _name;
    map['customer_type'] = _customerType;
    map['arb_name'] = _arbName;
    map['username'] = _username;
    map['family_name'] = _familyName;
    map['mobile'] = _mobile;
    map['password'] = _password;
    map['email'] = _email;
    map['language'] = _language;
    map['interest'] = _interest;
    map['gender'] = _gender;
    map['profile'] = _profile;
    map['date_of_birth'] = _dateOfBirth;
    map['governorate'] = _governorate;
    map['nationality'] = _nationality;
    map['state'] = _state;
    map['stateid'] = _stateid;
    map['cityid'] = _cityid;
    map['commission'] = _commission;
    map['totalpoint'] = _totalpoint;
    map['totalsaveamount'] = _totalsaveamount;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['android_token'] = _androidToken;
    map['status'] = _status;
    map['created_date'] = _createdDate;
    map['updated_date'] = _updatedDate;
    map['device'] = _device;
    map['operating_system'] = _operatingSystem;
    map['phone_model'] = _phoneModel;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['location'] = _location;
    map['delete_status'] = _deleteStatus;
    map['new_mob_no'] = _newMobNo;
    map['state_name'] = _stateName;
    map['arb_state_name'] = _arbStateName;
    map['city_name'] = _cityName;
    map['city_arb_name'] = _cityArbName;
    map['country_enNationality'] = _countryEnNationality;
    map['country_arNationality'] = _countryArNationality;
    map['org_status'] = _orgstatus;
    return map;
  }
}

/// success : "User detail"

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
