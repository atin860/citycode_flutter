/// status : 201
/// error : null
/// messages : {"success":"Add listed successfully"}
/// image_base_url : "http://185.188.127.11/public/advertisement/"
/// banner_default_url : "https://instagram.com/citycode?utm_medium=copy_link"
/// banner_list : [{"add_id":"1","add_name":"test","add_image":"banner-6617550__340.png","url":"https://geniesoftsystem.com/index.php","status":"1","created_date":"2022-04-03 19:32:57","updated_date":"2022-04-03 19:32:57"}]

// ignore_for_file: non_constant_identifier_names

class AdvertisementModel {
  AdvertisementModel({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageBaseUrl,
    String? bannerDefaultUrl,
    List<AdsList>? adsList,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _bannerDefaultUrl = bannerDefaultUrl;
    _adsList = adsList;
  }

  AdvertisementModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    _bannerDefaultUrl = json['banner_default_url'];
    if (json['banner_list'] != null) {
      _adsList = [];
      json['banner_list'].forEach((v) {
        _adsList?.add(AdsList.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  String? _bannerDefaultUrl;
  List<AdsList>? _adsList;
  AdvertisementModel copyWith({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageBaseUrl,
    String? bannerDefaultUrl,
    List<AdsList>? adsList,
  }) =>
      AdvertisementModel(
        status: status ?? _status,
        error: error ?? _error,
        messages: messages ?? _messages,
        imageBaseUrl: imageBaseUrl ?? _imageBaseUrl,
        bannerDefaultUrl: bannerDefaultUrl ?? _bannerDefaultUrl,
        adsList: adsList ?? _adsList,
      );
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  String? get bannerDefaultUrl => _bannerDefaultUrl;
  List<AdsList>? get adsList => _adsList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    map['banner_default_url'] = _bannerDefaultUrl;
    if (_adsList != null) {
      map['banner_list'] = _adsList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// add_id : "1"
/// add_name : "test"
/// add_image : "banner-6617550__340.png"
/// url : "https://geniesoftsystem.com/index.php"
/// status : "1"
/// created_date : "2022-04-03 19:32:57"
/// updated_date : "2022-04-03 19:32:57"

class AdsList {
  BannerList({
    String? addId,
    String? addName,
    String? addImage,
    String? url,
    String? status,
    String? createdDate,
    String? updatedDate,
  }) {
    _addId = addId;
    _addName = addName;
    _addImage = addImage;
    _url = url;
    _status = status;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
  }

  AdsList.fromJson(dynamic json) {
    _addId = json['add_id'];
    _addName = json['add_name'];
    _addImage = json['add_image'];
    _url = json['url'];
    _status = json['status'];
    _createdDate = json['created_date'];
    _updatedDate = json['updated_date'];
  }
  String? _addId;
  String? _addName;
  String? _addImage;
  String? _url;
  String? _status;
  String? _createdDate;
  String? _updatedDate;
  AdsList copyWith({
    String? addId,
    String? addName,
    String? addImage,
    String? url,
    String? status,
    String? createdDate,
    String? updatedDate,
  }) =>
      BannerList(
        addId: addId ?? _addId,
        addName: addName ?? _addName,
        addImage: addImage ?? _addImage,
        url: url ?? _url,
        status: status ?? _status,
        createdDate: createdDate ?? _createdDate,
        updatedDate: updatedDate ?? _updatedDate,
      );
  String? get addId => _addId;
  String? get addName => _addName;
  String? get addImage => _addImage;
  String? get url => _url;
  String? get status => _status;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['add_id'] = _addId;
    map['add_name'] = _addName;
    map['add_image'] = _addImage;
    map['url'] = _url;
    map['status'] = _status;
    map['created_date'] = _createdDate;
    map['updated_date'] = _updatedDate;
    return map;
  }
}

/// success : "Add listed successfully"

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
  Messages copyWith({
    String? success,
  }) =>
      Messages(
        success: success ?? _success,
      );
  String? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    return map;
  }
}
