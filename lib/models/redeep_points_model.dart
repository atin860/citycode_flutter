/// status : 201
/// error : null
/// messages : {"success":"Redeem Products listed successfully"}
/// image_base_url : "http://185.188.127.11/public/product/"
/// company_image_base_url : "http://185.188.127.11/public/company/"
/// RedeemProduct : [{"id":"498","company_id":"167","branch_id":"","product_name":"abc","description":"abcde","picture":"Scan.jpeg","quantity":"","price":"5.000","pr_redeempoint":"5000","show_inredeem":"1","status":"1","created_date":"2022-01-30 18:54:06","updated_date":"0000-00-00 00:00:00","created_by":"0","arb_product_name":"ا ب ت","arb_description":"ا ب ت ث ج","arb_picture":"","original_price":"0","discount_per":"0","company_name":"Mamitoo Baby","company_arb_name":"Mamitoo Baby","display_name":"Mamitoo Baby","display_arb_name":"Mamitoo Baby","company_picture":"mamitii logo.jpg"}]

class RedeepPointsModel {
  RedeepPointsModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? imageBaseUrl, 
      String? companyImageBaseUrl, 
      List<RedeemProduct>? redeemProduct,}){
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _companyImageBaseUrl = companyImageBaseUrl;
    _redeemProduct = redeemProduct;
}

  RedeepPointsModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    _companyImageBaseUrl = json['company_image_base_url'];
    if (json['RedeemProduct'] != null) {
      _redeemProduct = [];
      json['RedeemProduct'].forEach((v) {
        _redeemProduct?.add(RedeemProduct.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  String? _companyImageBaseUrl;
  List<RedeemProduct>? _redeemProduct;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  String? get companyImageBaseUrl => _companyImageBaseUrl;
  List<RedeemProduct>? get redeemProduct => _redeemProduct;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    map['company_image_base_url'] = _companyImageBaseUrl;
    if (_redeemProduct != null) {
      map['RedeemProduct'] = _redeemProduct?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "498"
/// company_id : "167"
/// branch_id : ""
/// product_name : "abc"
/// description : "abcde"
/// picture : "Scan.jpeg"
/// quantity : ""
/// price : "5.000"
/// pr_redeempoint : "5000"
/// show_inredeem : "1"
/// status : "1"
/// created_date : "2022-01-30 18:54:06"
/// updated_date : "0000-00-00 00:00:00"
/// created_by : "0"
/// arb_product_name : "ا ب ت"
/// arb_description : "ا ب ت ث ج"
/// arb_picture : ""
/// original_price : "0"
/// discount_per : "0"
/// company_name : "Mamitoo Baby"
/// company_arb_name : "Mamitoo Baby"
/// display_name : "Mamitoo Baby"
/// display_arb_name : "Mamitoo Baby"
/// company_picture : "mamitii logo.jpg"

class RedeemProduct {
  RedeemProduct({
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
      String? companyPicture,}){
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

  RedeemProduct.fromJson(dynamic json) {
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

/// success : "Redeem Products listed successfully"

class Messages {
  Messages({
      String? success,}){
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