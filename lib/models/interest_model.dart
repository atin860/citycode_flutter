/// status : 201
/// error : null
/// messages : {"success":"Filters listed successfully"}
/// category_base_url : "http://185.188.127.11/public/category/"
/// category_list : [{"cat_id":"6","cat_name":"Perfume","cat_arbname":"العطور","cat_image":"perfume.jpg","cat_arb_image":"arb_perfume.jpg","cat_status":"1","cat_order":"1"},{"cat_id":"1","cat_name":"Clinics","cat_arbname":"عيادات","cat_image":"clinics.jpg","cat_arb_image":"arb_clinics.jpg","cat_status":"1","cat_order":"2"},{"cat_id":"15","cat_name":"Hotels","cat_arbname":"الفنادق","cat_image":"hotels.jpg","cat_arb_image":"arb_hotel.jpg","cat_status":"1","cat_order":"3"},{"cat_id":"2","cat_name":"Restaurant","cat_arbname":"المطاعم","cat_image":"restaurants.jpg","cat_arb_image":"arb_restaurants.jpg","cat_status":"1","cat_order":"4"},{"cat_id":"4","cat_name":"Beauty","cat_arbname":"التجميل","cat_image":"beauty.jpg","cat_arb_image":"arb_beauty.jpg","cat_status":"1","cat_order":"5"},{"cat_id":"12","cat_name":"Flowers & Gifts","cat_arbname":"الورد والهدايا","cat_image":"flower_gift.jpg","cat_arb_image":"arb_flower_gift.jpeg","cat_status":"1","cat_order":"6"},{"cat_id":"5","cat_name":"Clothes & Shoes","cat_arbname":"الملابس","cat_image":"clothing.jpg","cat_arb_image":"arb_clothing.jpg","cat_status":"1","cat_order":"7"},{"cat_id":"8","cat_name":"Electronic & Devices","cat_arbname":"الاجهزة والادوات المنزلية","cat_image":"electronicdevice.jpg","cat_arb_image":"arb_electronicdevice.jpg","cat_status":"1","cat_order":"7"},{"cat_id":"10","cat_name":"Gym","cat_arbname":"الصالات الرياضية","cat_image":"gym.jpg","cat_arb_image":"arb_gym.jpg","cat_status":"1","cat_order":"9"},{"cat_id":"7","cat_name":"Furniture & Lighting","cat_arbname":"الأثاث والإضاءة","cat_image":"furniture_lighting.jpg","cat_arb_image":"arb_furniture_lighting.jpg","cat_status":"1","cat_order":"10"},{"cat_id":"13","cat_name":"Entertainment","cat_arbname":"الترفيه والالعاب","cat_image":"entertainment.jpg","cat_arb_image":"arb_entertainment.jpg","cat_status":"1","cat_order":"11"},{"cat_id":"9","cat_name":"Insurance","cat_arbname":"تـامين","cat_image":"insurance.jpg","cat_arb_image":"arb_insurance.jpg","cat_status":"1","cat_order":"12"},{"cat_id":"11","cat_name":"Laundries","cat_arbname":"المغاسل","cat_image":"laundries.jpg","cat_arb_image":"arb_laundries.jpg","cat_status":"1","cat_order":"13"},{"cat_id":"14","cat_name":"Other","cat_arbname":"اخرى","cat_image":"other.jpg","cat_arb_image":"arb_other.jpg","cat_status":"1","cat_order":"14"}]

// ignore_for_file: camel_case_types

class Interest_model {
  Interest_model({
    int? status,
    dynamic error,
    Messages? messages,
    String? categoryBaseUrl,
    List<Category_list>? categoryList,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _categoryBaseUrl = categoryBaseUrl;
    _categoryList = categoryList;
  }

  Interest_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _categoryBaseUrl = json['category_base_url'];
    if (json['category_list'] != null) {
      _categoryList = [];
      json['category_list'].forEach((v) {
        _categoryList?.add(Category_list.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _categoryBaseUrl;
  List<Category_list>? _categoryList;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get categoryBaseUrl => _categoryBaseUrl;
  List<Category_list>? get categoryList => _categoryList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['category_base_url'] = _categoryBaseUrl;
    if (_categoryList != null) {
      map['category_list'] = _categoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// cat_id : "6"
/// cat_name : "Perfume"
/// cat_arbname : "العطور"
/// cat_image : "perfume.jpg"
/// cat_arb_image : "arb_perfume.jpg"
/// cat_status : "1"
/// cat_order : "1"

class Category_list {
  Category_list({
    String? catId,
    String? catName,
    String? catArbname,
    String? catImage,
    String? catArbImage,
    String? catStatus,
    String? catOrder,
  }) {
    _catId = catId;
    _catName = catName;
    _catArbname = catArbname;
    _catImage = catImage;
    _catArbImage = catArbImage;
    _catStatus = catStatus;
    _catOrder = catOrder;
  }

  Category_list.fromJson(dynamic json) {
    _catId = json['cat_id'];
    _catName = json['cat_name'];
    _catArbname = json['cat_arbname'];
    _catImage = json['cat_image'];
    _catArbImage = json['cat_arb_image'];
    _catStatus = json['cat_status'];
    _catOrder = json['cat_order'];
  }
  String? _catId;
  String? _catName;
  String? _catArbname;
  String? _catImage;
  String? _catArbImage;
  String? _catStatus;
  String? _catOrder;

  String? get catId => _catId;
  String? get catName => _catName;
  String? get catArbname => _catArbname;
  String? get catImage => _catImage;
  String? get catArbImage => _catArbImage;
  String? get catStatus => _catStatus;
  String? get catOrder => _catOrder;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cat_id'] = _catId;
    map['cat_name'] = _catName;
    map['cat_arbname'] = _catArbname;
    map['cat_image'] = _catImage;
    map['cat_arb_image'] = _catArbImage;
    map['cat_status'] = _catStatus;
    map['cat_order'] = _catOrder;
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
