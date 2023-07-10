class VipListModel {
  VipListModel({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageBaseUrl,
    String? companyBaseUrl,
    List<Userdetail>? userdetail,
    List<VipOffers>? vipOffers,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _companyBaseUrl = companyBaseUrl;
    _userdetail = userdetail;
    _vipOffers = vipOffers;
  }

  VipListModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    _companyBaseUrl = json['company_base_url'];
    if (json['userdetail'] != null) {
      _userdetail = [];
      json['userdetail'].forEach((v) {
        _userdetail?.add(Userdetail.fromJson(v));
      });
    }
    if (json['vipOffers'] != null) {
      _vipOffers = [];
      json['vipOffers'].forEach((v) {
        _vipOffers?.add(VipOffers.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  String? _companyBaseUrl;
  List<Userdetail>? _userdetail;
  List<VipOffers>? _vipOffers;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  String? get companyBaseUrl => _companyBaseUrl;
  List<Userdetail>? get userdetail => _userdetail;
  List<VipOffers>? get vipOffers => _vipOffers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    map['company_base_url'] = _companyBaseUrl;
    if (_userdetail != null) {
      map['userdetail'] = _userdetail?.map((v) => v.toJson()).toList();
    }
    if (_vipOffers != null) {
      map['vipOffers'] = _vipOffers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VipOffers {
  VipOffers({
    String? id,
    String? companyId,
    String? customerId,
    String? createdDate,
    String? couponType,
    String? discountdisplay,
    String? customerDiscount,
    String? discountDetail,
    String? description,
    String? companyName,
    String? displayName,
    String? companyArbName,
    String? displayArbName,
    String? companylogo,
    String? viewCount,
    String? category,
    String? startDate,
    String? endDate,
    String? discountEnDetail,
    String? discountArbDetail,
    String? remainingday,
    String? remaininghours,
    String? remainingminutes,
  }) {
    _id = id;
    _companyId = companyId;
    _customerId = customerId;
    _createdDate = createdDate;
    _couponType = couponType;
    _discountdisplay = discountdisplay;
    _customerDiscount = customerDiscount;
    _discountDetail = discountDetail;
    _description = description;
    _companyName = companyName;
    _displayName = displayName;
    _companyArbName = companyArbName;
    _displayArbName = displayArbName;
    _companylogo = companylogo;
    _viewCount = viewCount;
    _category = category;
    _startDate = startDate;
    _endDate = endDate;
    _discountEnDetail = discountEnDetail;
    _discountArbDetail = discountArbDetail;
    _remainingday = remainingday;
    _remaininghours = remaininghours;
    _remainingminutes = remainingminutes;
  }

  VipOffers.fromJson(dynamic json) {
    _id = json['id'];
    _companyId = json['company_id'];
    _customerId = json['customer_id'];
    _createdDate = json['created_date'];
    _couponType = json['coupon_type'];
    _discountdisplay = json['discountdisplay'];
    _customerDiscount = json['customer_discount'];
    _discountDetail = json['discount_detail'];
    _description = json['description'];
    _companyName = json['company_name'];
    _displayName = json['display_name'];
    _companyArbName = json['company_arb_name'];
    _displayArbName = json['display_arb_name'];
    _companylogo = json['companylogo'];
    _viewCount = json['view_count'];
    _category = json['category'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _discountEnDetail = json['discount_en_detail'];
    _discountArbDetail = json['discount_arb_detail'];
    _remainingday = json['remainingday'];
    _remaininghours = json['remaininghours'];
    _remainingminutes = json['remainingminutes'];
  }
  String? _id;
  String? _companyId;
  String? _customerId;
  String? _createdDate;
  String? _couponType;
  String? _discountdisplay;
  String? _customerDiscount;
  String? _discountDetail;
  String? _description;
  String? _companyName;
  String? _displayName;
  String? _companyArbName;
  String? _displayArbName;
  String? _companylogo;
  String? _viewCount;
  String? _category;
  String? _startDate;
  String? _endDate;
  String? _discountEnDetail;
  String? _discountArbDetail;
  String? _remainingday;
  String? _remaininghours;
  String? _remainingminutes;

  String? get id => _id;
  String? get companyId => _companyId;
  String? get customerId => _customerId;
  String? get createdDate => _createdDate;
  String? get couponType => _couponType;
  String? get discountdisplay => _discountdisplay;
  String? get customerDiscount => _customerDiscount;
  String? get discountDetail => _discountDetail;
  String? get description => _description;
  String? get companyName => _companyName;
  String? get displayName => _displayName;
  String? get companyArbName => _companyArbName;
  String? get displayArbName => _displayArbName;
  String? get companylogo => _companylogo;
  String? get viewCount => _viewCount;
  String? get category => _category;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get discountEnDetail => _discountEnDetail;
  String? get discountArbDetail => _discountArbDetail;
  String? get remainingday => _remainingday;
  String? get remaininghours => _remaininghours;
  String? get remainingminutes => _remainingminutes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['company_id'] = _companyId;
    map['customer_id'] = _customerId;
    map['created_date'] = _createdDate;
    map['coupon_type'] = _couponType;
    map['discountdisplay'] = _discountdisplay;
    map['customer_discount'] = _customerDiscount;
    map['discount_detail'] = _discountDetail;
    map['description'] = _description;
    map['company_name'] = _companyName;
    map['display_name'] = _displayName;
    map['company_arb_name'] = _companyArbName;
    map['display_arb_name'] = _displayArbName;
    map['companylogo'] = _companylogo;
    map['view_count'] = _viewCount;
    map['category'] = _category;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['discount_en_detail'] = _discountEnDetail;
    map['discount_arb_detail'] = _discountArbDetail;
    map['remainingday'] = _remainingday;
    map['remaininghours'] = _remaininghours;
    map['remainingminutes'] = _remainingminutes;
    return map;
  }
}

class Userdetail {
  Userdetail({
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
    _stateName = stateName;
    _arbStateName = arbStateName;
    _cityName = cityName;
    _cityArbName = cityArbName;
    _countryEnNationality = countryEnNationality;
    _countryArNationality = countryArNationality;
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
    return map;
  }
}

/// success : "Vip detail"

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
