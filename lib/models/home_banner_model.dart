/// status : 201
/// error : null
/// messages : {"success":"Offer listed successfully"}
/// image_base_url : "http://185.188.127.11/public/advertisement/"
/// banner_default_url : "https://instagram.com/citycode?utm_medium=copy_link"
/// banner_list : [{"id":"75","banner_id":"24","banner":"banner cc.jpg","created_by":"1","url":"https://instagram.com/citycode?utm_medium=copy_link","banner_type":"english","governorate":"1001,1003,1004,1005,1002,1006,1007,1008,1009,1011,1010","gender":"Male,Female,Others","start_date":"2021-09-20","end_date":"2023-04-28","in_app":"false","company_id":"0"},{"id":"76","banner_id":"24","banner":"banner cc2.jpg","created_by":"1","url":"https://instagram.com/citycode?utm_medium=copy_link","banner_type":"english","governorate":"1001,1003,1004,1005,1002,1006,1007,1008,1009,1011,1010","gender":"Male,Female,Others","start_date":"2021-09-20","end_date":"2023-04-28","in_app":"false","company_id":"0"},{"id":"77","banner_id":"24","banner":"banner cc1.jpg","created_by":"1","url":"https://instagram.com/citycode?utm_medium=copy_link","banner_type":"english","governorate":"1001,1003,1004,1005,1002,1006,1007,1008,1009,1011,1010","gender":"Male,Female,Others","start_date":"2021-09-20","end_date":"2023-04-28","in_app":"false","company_id":"0"},{"id":"88","banner_id":"35","banner":"الظاهر (1).jpg","created_by":"1","url":"","banner_type":"all","governorate":"1002","gender":"Male,Female,Others","start_date":"2021-09-23","end_date":"2022-05-31","in_app":"","company_id":"122"}]

// ignore_for_file: camel_case_types

class Home_banner_model {
  Home_banner_model({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageBaseUrl,
    String? bannerDefaultUrl,
    List<Banner_list>? bannerList,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _bannerDefaultUrl = bannerDefaultUrl;
    _bannerList = bannerList;
  }

  Home_banner_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    _bannerDefaultUrl = json['banner_default_url'];
    if (json['banner_list'] != null) {
      _bannerList = [];
      json['banner_list'].forEach((v) {
        _bannerList?.add(Banner_list.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  String? _bannerDefaultUrl;
  List<Banner_list>? _bannerList;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  String? get bannerDefaultUrl => _bannerDefaultUrl;
  List<Banner_list>? get bannerList => _bannerList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    map['banner_default_url'] = _bannerDefaultUrl;
    if (_bannerList != null) {
      map['banner_list'] = _bannerList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "75"
/// banner_id : "24"
/// banner : "banner cc.jpg"
/// created_by : "1"
/// url : "https://instagram.com/citycode?utm_medium=copy_link"
/// banner_type : "english"
/// governorate : "1001,1003,1004,1005,1002,1006,1007,1008,1009,1011,1010"
/// gender : "Male,Female,Others"
/// start_date : "2021-09-20"
/// end_date : "2023-04-28"
/// in_app : "false"
/// company_id : "0"

class Banner_list {
  Banner_list({
    String? id,
    String? bannerId,
    String? banner,
    String? createdBy,
    String? url,
    String? bannerType,
    String? governorate,
    String? gender,
    String? startDate,
    String? endDate,
    String? inApp,
    String? companyId,
  }) {
    _id = id;
    _bannerId = bannerId;
    _banner = banner;
    _createdBy = createdBy;
    _url = url;
    _bannerType = bannerType;
    _governorate = governorate;
    _gender = gender;
    _startDate = startDate;
    _endDate = endDate;
    _inApp = inApp;
    _companyId = companyId;
  }

  Banner_list.fromJson(dynamic json) {
    _id = json['id'];
    _bannerId = json['banner_id'];
    _banner = json['banner'];
    _createdBy = json['created_by'];
    _url = json['url'];
    _bannerType = json['banner_type'];
    _governorate = json['governorate'];
    _gender = json['gender'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _inApp = json['in_app'];
    _companyId = json['company_id'];
  }
  String? _id;
  String? _bannerId;
  String? _banner;
  String? _createdBy;
  String? _url;
  String? _bannerType;
  String? _governorate;
  String? _gender;
  String? _startDate;
  String? _endDate;
  String? _inApp;
  String? _companyId;

  String? get id => _id;
  String? get bannerId => _bannerId;
  String? get banner => _banner;
  String? get createdBy => _createdBy;
  String? get url => _url;
  String? get bannerType => _bannerType;
  String? get governorate => _governorate;
  String? get gender => _gender;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get inApp => _inApp;
  String? get companyId => _companyId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['banner_id'] = _bannerId;
    map['banner'] = _banner;
    map['created_by'] = _createdBy;
    map['url'] = _url;
    map['banner_type'] = _bannerType;
    map['governorate'] = _governorate;
    map['gender'] = _gender;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['in_app'] = _inApp;
    map['company_id'] = _companyId;
    return map;
  }
}

/// success : "Offer listed successfully"

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
