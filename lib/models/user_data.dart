/// status : 201
/// error : null
/// messages : {"success":"Data Find successfully"}
/// user_data : {"id":"238","city_code":"X7689","vip_code":"","vip_plus":"","name":"Shivangi anand","customer_type":"customer","arb_name":"","username":"","family_name":"","mobile":"25252525","password":"$2y$10$nQ1d5to2FtzymNNr..28jura.mMttpwGE38USmHjKWLUltPom7tyy","email":"shivangi@gmail.com","language":"arabic","interest":"customer","gender":"Male","profile":"2041028174_Capture001.png","date_of_birth":"2021-08-19","governorate":"1010","nationality":"2","state":"","stateid":"1004","cityid":"22","commission":"0","totalpoint":"3404040","totalsaveamount":"45379","start_date":"","end_date":"","android_token":"d27pPNqjeJI:APA91bGW0nK8uz97FQBO1ZBkvtnBUPzUGzNpneLwEZSsyi3iLvRrnN0D0Sgj5uAFMT0ef0eN6lL9iPCgYy5O_-qL_oLxwecSqYdiwLnv89OKYavHCj8MKaRAcx4y5B19Fx5BwOw0ggVM","status":"1","created_date":"2021-08-19 20:16:21","updated_date":"2021-12-17 13:33:35","device":"","operating_system":"","phone_model":"","latitude":"","longitude":"","location":"","delete_status":"0","new_mob_no":"25252525"}

// ignore_for_file: camel_case_types

class User_data {
  User_data({
    int? status,
    dynamic error,
    Messages? messages,
    User_data? userData,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _userData = userData;
  }

  User_data.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _userData =
        json['user_data'] != null ? User_data.fromJson(json['userData']) : null;
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  User_data? _userData;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  User_data? get userData => _userData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_userData != null) {
      map['user_data'] = _userData?.toJson();
    }
    return map;
  }
}

/// id : "238"
/// city_code : "X7689"
/// vip_code : ""
/// vip_plus : ""
/// name : "Shivangi anand"
/// customer_type : "customer"
/// arb_name : ""
/// username : ""
/// family_name : ""
/// mobile : "25252525"
/// password : "$2y$10$nQ1d5to2FtzymNNr..28jura.mMttpwGE38USmHjKWLUltPom7tyy"
/// email : "shivangi@gmail.com"
/// language : "arabic"
/// interest : "customer"
/// gender : "Male"
/// profile : "2041028174_Capture001.png"
/// date_of_birth : "2021-08-19"
/// governorate : "1010"
/// nationality : "2"
/// state : ""
/// stateid : "1004"
/// cityid : "22"
/// commission : "0"
/// totalpoint : "3404040"
/// totalsaveamount : "45379"
/// start_date : ""
/// end_date : ""
/// android_token : "d27pPNqjeJI:APA91bGW0nK8uz97FQBO1ZBkvtnBUPzUGzNpneLwEZSsyi3iLvRrnN0D0Sgj5uAFMT0ef0eN6lL9iPCgYy5O_-qL_oLxwecSqYdiwLnv89OKYavHCj8MKaRAcx4y5B19Fx5BwOw0ggVM"
/// status : "1"
/// created_date : "2021-08-19 20:16:21"
/// updated_date : "2021-12-17 13:33:35"
/// device : ""
/// operating_system : ""
/// phone_model : ""
/// latitude : ""
/// longitude : ""
/// location : ""
/// delete_status : "0"
/// new_mob_no : "25252525"

class UserData {
  UserData({
    String? id,
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
    int? status,
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
  }) {
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
  }

  UserData.fromJson(dynamic json) {
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
  int? _status;
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
  int? get status => _status;
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
    return map;
  }
}

/// success : "Data Find successfully"

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
