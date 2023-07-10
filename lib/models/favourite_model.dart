/// status : 201
/// error : null
/// messages : {"success":"Favourate listed successfully"}
/// image_base_url : "http://185.188.127.11/public/company/"
/// favouratelist : [{"id":"920","customer_id":"238","company_id":"134","offer_id":"114","add_date":"2022-01-19 03:34:07","company_name":"Fahmy Outlet","company_arb_name":"فهمي أوتليت","display_name":"Fahmy Outlet","display_arb_name":"فهمي أوتليت","companylogo":"117579371_645490929732850_8116395459243575151_n.jpg","view_count":"344","discountdisplay":"25%","customer_discount":"25","discount_detail":"3","description":"Get the advantage when buying a high-quality home and office furniture with a discount of 25% from our selection of products.\r\n\r\n All you got to do is choose a product from the products and prices category and visit the Braka branch to benefit from our discounts by using your code.","discount_en_detail":"Selected Items","discount_arb_detail":"منتجات مختاره","remainingday":"34","remaininghours":"22","remainingminutes":"59"},{"id":"916","customer_id":"238","company_id":"148","offer_id":"169","add_date":"2022-01-19 03:32:29","company_name":"T Broast ","company_arb_name":"تي بروست ","display_name":"T Broast Fried Chicken ","display_arb_name":"تي بروست  ","companylogo":"t broast.jpg","view_count":"143","discountdisplay":"20%","customer_discount":"20","discount_detail":"3","description":"Enjoy crispy chicken family meals and sandwiches with a discount of 20% all  products except drinks.\r\n\r\n All you got to do is choose a product from the products and prices category and visit the AlKhoudh branch to benefit from our discounts by using your code.","discount_en_detail":"Selected Items","discount_arb_detail":"منتجات مختاره","remainingday":"34","remaininghours":"22","remainingminutes":"59"},{"id":"912","customer_id":"238","company_id":"137","offer_id":"121","add_date":"2022-01-19 03:31:48","company_name":"Lash Box","company_arb_name":"لاش بوكس","display_name":"LASH BOX","display_arb_name":"لاش بوكس","companylogo":"lash box logo 2.jpg","view_count":"111","discountdisplay":"15%","customer_discount":"15","discount_detail":"3","description":"Enjoy a Premium Quality of  Authentic Mink Lashes and Human Hair Lashes with 15% discount on our selection of products. \r\n\r\nAll you got to do is choose a product from the products and prices category and visit City Centre Muscat branch to benefit from our discounts using your code.","discount_en_detail":"Selected Items","discount_arb_detail":"منتجات مختاره","remainingday":"34","remaininghours":"22","remainingminutes":"59"}]

// ignore_for_file: camel_case_types

class Favourite_model {
  Favourite_model({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageBaseUrl,
    List<Favouratelist>? favouratelist,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _favouratelist = favouratelist;
  }

  Favourite_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    if (json['favouratelist'] != null) {
      _favouratelist = [];
      json['favouratelist'].forEach((v) {
        _favouratelist?.add(Favouratelist.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  List<Favouratelist>? _favouratelist;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  List<Favouratelist>? get favouratelist => _favouratelist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    if (_favouratelist != null) {
      map['favouratelist'] = _favouratelist?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "920"
/// customer_id : "238"
/// company_id : "134"
/// offer_id : "114"
/// add_date : "2022-01-19 03:34:07"
/// company_name : "Fahmy Outlet"
/// company_arb_name : "فهمي أوتليت"
/// display_name : "Fahmy Outlet"
/// display_arb_name : "فهمي أوتليت"
/// companylogo : "117579371_645490929732850_8116395459243575151_n.jpg"
/// view_count : "344"
/// discountdisplay : "25%"
/// customer_discount : "25"
/// discount_detail : "3"
/// description : "Get the advantage when buying a high-quality home and office furniture with a discount of 25% from our selection of products.\r\n\r\n All you got to do is choose a product from the products and prices category and visit the Braka branch to benefit from our discounts by using your code."
/// discount_en_detail : "Selected Items"
/// discount_arb_detail : "منتجات مختاره"
/// remainingday : "34"
/// remaininghours : "22"
/// remainingminutes : "59"

class Favouratelist {
  Favouratelist({
    String? id,
    String? customerId,
    String? companyId,
    String? offerId,
    String? addDate,
    String? companyName,
    String? companyArbName,
    String? displayName,
    String? displayArbName,
    String? companylogo,
    String? viewCount,
    String? discountdisplay,
    String? customerDiscount,
    String? discountDetail,
    String? description,
    String? discountEnDetail,
    String? discountArbDetail,
    String? remainingday,
    String? remaininghours,
    String? remainingminutes,
  }) {
    _id = id;
    _customerId = customerId;
    _companyId = companyId;
    _offerId = offerId;
    _addDate = addDate;
    _companyName = companyName;
    _companyArbName = companyArbName;
    _displayName = displayName;
    _displayArbName = displayArbName;
    _companylogo = companylogo;
    _viewCount = viewCount;
    _discountdisplay = discountdisplay;
    _customerDiscount = customerDiscount;
    _discountDetail = discountDetail;
    _description = description;
    _discountEnDetail = discountEnDetail;
    _discountArbDetail = discountArbDetail;
    _remainingday = remainingday;
    _remaininghours = remaininghours;
    _remainingminutes = remainingminutes;
  }

  Favouratelist.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _companyId = json['company_id'];
    _offerId = json['offer_id'];
    _addDate = json['add_date'];
    _companyName = json['company_name'];
    _companyArbName = json['company_arb_name'];
    _displayName = json['display_name'];
    _displayArbName = json['display_arb_name'];
    _companylogo = json['companylogo'];
    _viewCount = json['view_count'];
    _discountdisplay = json['discountdisplay'];
    _customerDiscount = json['customer_discount'];
    _discountDetail = json['discount_detail'];
    _description = json['description'];
    _discountEnDetail = json['discount_en_detail'];
    _discountArbDetail = json['discount_arb_detail'];
    _remainingday = json['remainingday'];
    _remaininghours = json['remaininghours'];
    _remainingminutes = json['remainingminutes'];
  }
  String? _id;
  String? _customerId;
  String? _companyId;
  String? _offerId;
  String? _addDate;
  String? _companyName;
  String? _companyArbName;
  String? _displayName;
  String? _displayArbName;
  String? _companylogo;
  String? _viewCount;
  String? _discountdisplay;
  String? _customerDiscount;
  String? _discountDetail;
  String? _description;
  String? _discountEnDetail;
  String? _discountArbDetail;
  String? _remainingday;
  String? _remaininghours;
  String? _remainingminutes;

  String? get id => _id;
  String? get customerId => _customerId;
  String? get companyId => _companyId;
  String? get offerId => _offerId;
  String? get addDate => _addDate;
  String? get companyName => _companyName;
  String? get companyArbName => _companyArbName;
  String? get displayName => _displayName;
  String? get displayArbName => _displayArbName;
  String? get companylogo => _companylogo;
  String? get viewCount => _viewCount;
  String? get discountdisplay => _discountdisplay;
  String? get customerDiscount => _customerDiscount;
  String? get discountDetail => _discountDetail;
  String? get description => _description;
  String? get discountEnDetail => _discountEnDetail;
  String? get discountArbDetail => _discountArbDetail;
  String? get remainingday => _remainingday;
  String? get remaininghours => _remaininghours;
  String? get remainingminutes => _remainingminutes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['company_id'] = _companyId;
    map['offer_id'] = _offerId;
    map['add_date'] = _addDate;
    map['company_name'] = _companyName;
    map['company_arb_name'] = _companyArbName;
    map['display_name'] = _displayName;
    map['display_arb_name'] = _displayArbName;
    map['companylogo'] = _companylogo;
    map['view_count'] = _viewCount;
    map['discountdisplay'] = _discountdisplay;
    map['customer_discount'] = _customerDiscount;
    map['discount_detail'] = _discountDetail;
    map['description'] = _description;
    map['discount_en_detail'] = _discountEnDetail;
    map['discount_arb_detail'] = _discountArbDetail;
    map['remainingday'] = _remainingday;
    map['remaininghours'] = _remaininghours;
    map['remainingminutes'] = _remainingminutes;
    return map;
  }
}

/// success : "Favourate listed successfully"

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
