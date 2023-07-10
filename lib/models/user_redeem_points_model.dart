/// status : 201
/// error : null
/// messages : {"success":"Products listed successfully"}
/// image_base_url : "http://185.188.127.11/public/product/"
/// company_base_url : "http://185.188.127.11/public/company/"
/// companylist : [{"id":"484","company_id":"171","branch_id":"","product_name":"TEST 2","description":".","picture":"2ee90097-1295-4e8e-8107-bd5c5b49110b.jpg","quantity":"","price":"3.000","pr_redeempoint":"3000","show_inredeem":"1","status":"1","created_date":"2021-12-23 18:26:43","updated_date":"0000-00-00 00:00:00","created_by":"0","arb_product_name":"تجربة 2 ","arb_description":"","arb_picture":"","original_price":"0","discount_per":"0","company_name":"city code Tickets ","company_arb_name":"تذاكر ستي كود","display_name":"city code ","display_arb_name":"ستي كود","company_picture":"download_5.jpg"},{"id":"483","company_id":"171","branch_id":"","product_name":"TEST ","description":".","picture":"7aa32111-6d34-417e-ab34-709dc078e7de_1.jpg","quantity":"","price":"2.000","pr_redeempoint":"2000","show_inredeem":"1","status":"1","created_date":"2021-12-23 18:25:30","updated_date":"0000-00-00 00:00:00","created_by":"0","arb_product_name":"تجربة ","arb_description":"","arb_picture":"","original_price":"0","discount_per":"0","company_name":"city code Tickets ","company_arb_name":"تذاكر ستي كود","display_name":"city code ","display_arb_name":"ستي كود","company_picture":"download_5.jpg"},{"id":"480","company_id":"167","branch_id":"","product_name":"Baby Set ","description":"Baby boy 0-6 months old ","picture":"1deb9452-5c11-4048-bd45-6850721d1dc9.jpg","quantity":"","price":"2.500","pr_redeempoint":"2500","show_inredeem":"1","status":"1","created_date":"2021-11-30 19:44:44","updated_date":"0000-00-00 00:00:00","created_by":"0","arb_product_name":"طقم اطفال ","arb_description":"اولاد من 0-6 اشهر ","arb_picture":"","original_price":"4","discount_per":"0","company_name":"Mamitoo Baby","company_arb_name":"Mamitoo Baby","display_name":"Mamitoo Baby","display_arb_name":"Mamitoo Baby","company_picture":"mamitii logo.jpg"},{"id":"406","company_id":"167","branch_id":"","product_name":"Baby Set ","description":"12-24 months old ","picture":"804a150e-fd51-4526-812b-2e3f94f84fb6_1.jpg","quantity":"","price":"2.000","pr_redeempoint":"2000","show_inredeem":"1","status":"1","created_date":"2021-11-10 20:16:49","updated_date":"0000-00-00 00:00:00","created_by":"0","arb_product_name":"طقم اطفال ","arb_description":"12-24 شهور","arb_picture":"","original_price":"2","discount_per":"0","company_name":"Mamitoo Baby","company_arb_name":"Mamitoo Baby","display_name":"Mamitoo Baby","display_arb_name":"Mamitoo Baby","company_picture":"mamitii logo.jpg"},{"id":"35","company_id":"114","branch_id":"","product_name":"Backup Charger","description":"Backup Charger Details","picture":"61raeuS0FfL._AC_SX425_.jpg","quantity":"","price":"3.000","pr_redeempoint":"3000","show_inredeem":"1","status":"1","created_date":"2021-08-25 12:18:41","updated_date":"0000-00-00 00:00:00","created_by":"0","arb_product_name":"Backup Charger","arb_description":"Backup Charger Details","arb_picture":"","original_price":"2000","discount_per":"0","company_name":"Tech Store","company_arb_name":"متجر التقنية","display_name":"Tech Store","display_arb_name":"متجر التقنية","company_picture":"WhatsApp Image 2021-08-11 at 12.29.50 PM.jpeg"},{"id":"32","company_id":"112","branch_id":"","product_name":"Pizza","description":"pizza details","picture":"domino-s-pizza.jpg","quantity":"","price":"1.000","pr_redeempoint":"1000","show_inredeem":"1","status":"1","created_date":"2021-08-23 15:45:23","updated_date":"0000-00-00 00:00:00","created_by":"0","arb_product_name":"Pizza","arb_description":"pizza details","arb_picture":"","original_price":"100","discount_per":"0","company_name":"Tiptara","company_arb_name":"تبــتارا","display_name":"Tiptara","display_arb_name":"تبــتارا","company_picture":"ACE8905D-58D0-4E02-B768-B4450493B1AC.jpeg"}]

// ignore_for_file: camel_case_types

class User_redeem_points_model {
  User_redeem_points_model({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageBaseUrl,
    String? companyBaseUrl,
    List<Companylist>? companylist,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _companyBaseUrl = companyBaseUrl;
    _companylist = companylist;
  }

  User_redeem_points_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    _companyBaseUrl = json['company_base_url'];
    if (json['companylist'] != null) {
      _companylist = [];
      json['companylist'].forEach((v) {
        _companylist?.add(Companylist.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  String? _companyBaseUrl;
  List<Companylist>? _companylist;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  String? get companyBaseUrl => _companyBaseUrl;
  List<Companylist>? get companylist => _companylist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    map['company_base_url'] = _companyBaseUrl;
    if (_companylist != null) {
      map['companylist'] = _companylist?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "484"
/// company_id : "171"
/// branch_id : ""
/// product_name : "TEST 2"
/// description : "."
/// picture : "2ee90097-1295-4e8e-8107-bd5c5b49110b.jpg"
/// quantity : ""
/// price : "3.000"
/// pr_redeempoint : "3000"
/// show_inredeem : "1"
/// status : "1"
/// created_date : "2021-12-23 18:26:43"
/// updated_date : "0000-00-00 00:00:00"
/// created_by : "0"
/// arb_product_name : "تجربة 2 "
/// arb_description : ""
/// arb_picture : ""
/// original_price : "0"
/// discount_per : "0"
/// company_name : "city code Tickets "
/// company_arb_name : "تذاكر ستي كود"
/// display_name : "city code "
/// display_arb_name : "ستي كود"
/// company_picture : "download_5.jpg"

class Companylist {
  Companylist({
    String? id,
    String? companyId,
    String? branchId,
    String? productName,
    String? description,
    String? picture,
    String? quantity,
    String? price,
    String? prRedeempoint,
    String? showInredeem,
    String? status,
    String? createdDate,
    String? updatedDate,
    String? createdBy,
    String? arbProductName,
    String? arbDescription,
    String? arbPicture,
    String? originalPrice,
    String? discountPer,
    String? companyName,
    String? companyArbName,
    String? displayName,
    String? displayArbName,
    String? companyPicture,
  }) {
    _id = id;
    _companyId = companyId;
    _branchId = branchId;
    _productName = productName;
    _description = description;
    _picture = picture;
    _quantity = quantity;
    _price = price;
    _prRedeempoint = prRedeempoint;
    _showInredeem = showInredeem;
    _status = status;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
    _createdBy = createdBy;
    _arbProductName = arbProductName;
    _arbDescription = arbDescription;
    _arbPicture = arbPicture;
    _originalPrice = originalPrice;
    _discountPer = discountPer;
    _companyName = companyName;
    _companyArbName = companyArbName;
    _displayName = displayName;
    _displayArbName = displayArbName;
    _companyPicture = companyPicture;
  }

  Companylist.fromJson(dynamic json) {
    _id = json['id'];
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _productName = json['product_name'];
    _description = json['description'];
    _picture = json['picture'];
    _quantity = json['quantity'];
    _price = json['price'];
    _prRedeempoint = json['pr_redeempoint'];
    _showInredeem = json['show_inredeem'];
    _status = json['status'];
    _createdDate = json['created_date'];
    _updatedDate = json['updated_date'];
    _createdBy = json['created_by'];
    _arbProductName = json['arb_product_name'];
    _arbDescription = json['arb_description'];
    _arbPicture = json['arb_picture'];
    _originalPrice = json['original_price'];
    _discountPer = json['discount_per'];
    _companyName = json['company_name'];
    _companyArbName = json['company_arb_name'];
    _displayName = json['display_name'];
    _displayArbName = json['display_arb_name'];
    _companyPicture = json['company_picture'];
  }
  String? _id;
  String? _companyId;
  String? _branchId;
  String? _productName;
  String? _description;
  String? _picture;
  String? _quantity;
  String? _price;
  String? _prRedeempoint;
  String? _showInredeem;
  String? _status;
  String? _createdDate;
  String? _updatedDate;
  String? _createdBy;
  String? _arbProductName;
  String? _arbDescription;
  String? _arbPicture;
  String? _originalPrice;
  String? _discountPer;
  String? _companyName;
  String? _companyArbName;
  String? _displayName;
  String? _displayArbName;
  String? _companyPicture;

  String? get id => _id;
  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get productName => _productName;
  String? get description => _description;
  String? get picture => _picture;
  String? get quantity => _quantity;
  String? get price => _price;
  String? get prRedeempoint => _prRedeempoint;
  String? get showInredeem => _showInredeem;
  String? get status => _status;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;
  String? get createdBy => _createdBy;
  String? get arbProductName => _arbProductName;
  String? get arbDescription => _arbDescription;
  String? get arbPicture => _arbPicture;
  String? get originalPrice => _originalPrice;
  String? get discountPer => _discountPer;
  String? get companyName => _companyName;
  String? get companyArbName => _companyArbName;
  String? get displayName => _displayName;
  String? get displayArbName => _displayArbName;
  String? get companyPicture => _companyPicture;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['product_name'] = _productName;
    map['description'] = _description;
    map['picture'] = _picture;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['pr_redeempoint'] = _prRedeempoint;
    map['show_inredeem'] = _showInredeem;
    map['status'] = _status;
    map['created_date'] = _createdDate;
    map['updated_date'] = _updatedDate;
    map['created_by'] = _createdBy;
    map['arb_product_name'] = _arbProductName;
    map['arb_description'] = _arbDescription;
    map['arb_picture'] = _arbPicture;
    map['original_price'] = _originalPrice;
    map['discount_per'] = _discountPer;
    map['company_name'] = _companyName;
    map['company_arb_name'] = _companyArbName;
    map['display_name'] = _displayName;
    map['display_arb_name'] = _displayArbName;
    map['company_picture'] = _companyPicture;
    return map;
  }
}

/// success : "Products listed successfully"

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
