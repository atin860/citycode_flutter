/// status : 200
/// error : null
/// messages : {"success":"My Order list successfully.."}
/// product_image_base_url : "http://cp.citycode.om/public/product/"
/// company_image_base_url : "http://cp.citycode.om/public/company/"
/// myOrder : [{"order_id":"77","user_id":"22064","payment_status":"","company_id":"278","branch_id":"291","transaction_id":"","product_id":"1032","qty":"4","actual_price":"7.200","afterdiscount_price":"","discount_percent":"20.000","discount_offer_citycode":"0.000","total_amount":"6.048","product_cost_mobile":"","product_discount_mobile":"","created_date":"2023-03-29 13:40:42","suppliervat_charges":"0.000","appService_charge":"0.000","cityCodeVat_Charge":"0.000","delivery_charge":"0.000","total_cost_mobile":"0.000","total_cost_mobile_without_deilvery_charges":"0.000","point":"","company_name":"Roub","company_arb_name":"روب","companyImage":"1676478081_a7c71907211c6fc46bc2.jpg","name":"rohan","vip_code":"U0707","city_code":"G1985","mobile":"69696969","discount_offer":"20","product_name":"Roub Cup","picture":"c6bc5fc9-f560-48ea-b3b9-383f4b90beff.jpg","service_charge":"0.000","citycode_vat":"0.000","supplierVat_charges":"0.072","original_price":"1.800","cityCode_benefits":"0.000","price":"1.512","delivery_km":"0.000","arb_product_name":"","branch_name":"Muscat Mull"},{"order_id":"76","user_id":"22064","payment_status":"","company_id":"199","branch_id":"131,133","transaction_id":"","product_id":"1002","qty":"5","actual_price":"12.000","afterdiscount_price":"","discount_percent":"25.000","discount_offer_citycode":"0.000","total_amount":"9.450","product_cost_mobile":"","product_discount_mobile":"","created_date":"2023-03-29 13:16:31","suppliervat_charges":"0.000","appService_charge":"0.000","cityCodeVat_Charge":"0.000","delivery_charge":"0.000","total_cost_mobile":"0.000","total_cost_mobile_without_deilvery_charges":"0.000","point":"","company_name":"Acai","company_arb_name":"آساي","companyImage":"1649937872_86479a46a53ac309e672.jpg","name":"rohan","vip_code":"U0707","city_code":"G1985","mobile":"69696969","discount_offer":"25","product_name":"Mango Cheesecake","picture":"b8accfb1-109d-460f-9b6c-c7afb64d4424.jpg","service_charge":"0.000","citycode_vat":"0.000","supplierVat_charges":"0.090","original_price":"2.400","cityCode_benefits":"0.000","price":"1.890","delivery_km":"0.000","arb_product_name":"","branch_name":"Al Koudh"}]

class OrderListModel {
  OrderListModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? productImageBaseUrl, 
      String? companyImageBaseUrl, 
      List<MyOrder>? myOrder,}){
    _status = status;
    _error = error;
    _messages = messages;
    _productImageBaseUrl = productImageBaseUrl;
    _companyImageBaseUrl = companyImageBaseUrl;
    _myOrder = myOrder;
}

  OrderListModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _productImageBaseUrl = json['product_image_base_url'];
    _companyImageBaseUrl = json['company_image_base_url'];
    if (json['myOrder'] != null) {
      _myOrder = [];
      json['myOrder'].forEach((v) {
        _myOrder?.add(MyOrder.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _productImageBaseUrl;
  String? _companyImageBaseUrl;
  List<MyOrder>? _myOrder;
OrderListModel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  String? productImageBaseUrl,
  String? companyImageBaseUrl,
  List<MyOrder>? myOrder,
}) => OrderListModel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  productImageBaseUrl: productImageBaseUrl ?? _productImageBaseUrl,
  companyImageBaseUrl: companyImageBaseUrl ?? _companyImageBaseUrl,
  myOrder: myOrder ?? _myOrder,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get productImageBaseUrl => _productImageBaseUrl;
  String? get companyImageBaseUrl => _companyImageBaseUrl;
  List<MyOrder>? get myOrder => _myOrder;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['product_image_base_url'] = _productImageBaseUrl;
    map['company_image_base_url'] = _companyImageBaseUrl;
    if (_myOrder != null) {
      map['myOrder'] = _myOrder?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// order_id : "77"
/// user_id : "22064"
/// payment_status : ""
/// company_id : "278"
/// branch_id : "291"
/// transaction_id : ""
/// product_id : "1032"
/// qty : "4"
/// actual_price : "7.200"
/// afterdiscount_price : ""
/// discount_percent : "20.000"
/// discount_offer_citycode : "0.000"
/// total_amount : "6.048"
/// product_cost_mobile : ""
/// product_discount_mobile : ""
/// created_date : "2023-03-29 13:40:42"
/// suppliervat_charges : "0.000"
/// appService_charge : "0.000"
/// cityCodeVat_Charge : "0.000"
/// delivery_charge : "0.000"
/// total_cost_mobile : "0.000"
/// total_cost_mobile_without_deilvery_charges : "0.000"
/// point : ""
/// company_name : "Roub"
/// company_arb_name : "روب"
/// companyImage : "1676478081_a7c71907211c6fc46bc2.jpg"
/// name : "rohan"
/// vip_code : "U0707"
/// city_code : "G1985"
/// mobile : "69696969"
/// discount_offer : "20"
/// product_name : "Roub Cup"
/// picture : "c6bc5fc9-f560-48ea-b3b9-383f4b90beff.jpg"
/// service_charge : "0.000"
/// citycode_vat : "0.000"
/// supplierVat_charges : "0.072"
/// original_price : "1.800"
/// cityCode_benefits : "0.000"
/// price : "1.512"
/// delivery_km : "0.000"
/// arb_product_name : ""
/// branch_name : "Muscat Mull"

class MyOrder {
  MyOrder({
      String? orderId, 
      String? userId, 
      String? paymentStatus, 
      String? companyId, 
      String? branchId, 
      String? transactionId, 
      String? productId, 
      String? qty, 
      String? actualPrice, 
      String? afterdiscountPrice, 
      String? discountPercent, 
      String? discountOfferCitycode, 
      String? totalAmount, 
      String? productCostMobile, 
      String? productDiscountMobile, 
      String? createdDate, 
      String? suppliervatCharges, 
      String? appServiceCharge, 
      String? cityCodeVatCharge, 
      String? deliveryCharge, 
      String? totalCostMobile, 
      String? totalCostMobileWithoutDeilveryCharges, 
      String? point, 
      String? companyName, 
      String? companyArbName, 
      String? companyImage, 
      String? name, 
      String? vipCode, 
      String? cityCode, 
      String? mobile, 
      String? discountOffer, 
      String? productName, 
      String? picture, 
      String? serviceCharge, 
      String? citycodeVat, 
      String? supplierVatCharges, 
      String? originalPrice, 
      String? cityCodeBenefits, 
      String? price, 
      String? deliveryKm, 
      String? arbProductName, 
      String? branchName,}){
    _orderId = orderId;
    _userId = userId;
    _paymentStatus = paymentStatus;
    _companyId = companyId;
    _branchId = branchId;
    _transactionId = transactionId;
    _productId = productId;
    _qty = qty;
    _actualPrice = actualPrice;
    _afterdiscountPrice = afterdiscountPrice;
    _discountPercent = discountPercent;
    _discountOfferCitycode = discountOfferCitycode;
    _totalAmount = totalAmount;
    _productCostMobile = productCostMobile;
    _productDiscountMobile = productDiscountMobile;
    _createdDate = createdDate;
    _suppliervatCharges = suppliervatCharges;
    _appServiceCharge = appServiceCharge;
    _cityCodeVatCharge = cityCodeVatCharge;
    _deliveryCharge = deliveryCharge;
    _totalCostMobile = totalCostMobile;
    _totalCostMobileWithoutDeilveryCharges = totalCostMobileWithoutDeilveryCharges;
    _point = point;
    _companyName = companyName;
    _companyArbName = companyArbName;
    _companyImage = companyImage;
    _name = name;
    _vipCode = vipCode;
    _cityCode = cityCode;
    _mobile = mobile;
    _discountOffer = discountOffer;
    _productName = productName;
    _picture = picture;
    _serviceCharge = serviceCharge;
    _citycodeVat = citycodeVat;
    _supplierVatCharges = supplierVatCharges;
    _originalPrice = originalPrice;
    _cityCodeBenefits = cityCodeBenefits;
    _price = price;
    _deliveryKm = deliveryKm;
    _arbProductName = arbProductName;
    _branchName = branchName;
}

  MyOrder.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _userId = json['user_id'];
    _paymentStatus = json['payment_status'];
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _transactionId = json['transaction_id'];
    _productId = json['product_id'];
    _qty = json['qty'];
    _actualPrice = json['actual_price'];
    _afterdiscountPrice = json['afterdiscount_price'];
    _discountPercent = json['discount_percent'];
    _discountOfferCitycode = json['discount_offer_citycode'];
    _totalAmount = json['total_amount'];
    _productCostMobile = json['product_cost_mobile'];
    _productDiscountMobile = json['product_discount_mobile'];
    _createdDate = json['created_date'];
    _suppliervatCharges = json['suppliervat_charges'];
    _appServiceCharge = json['appService_charge'];
    _cityCodeVatCharge = json['cityCodeVat_Charge'];
    _deliveryCharge = json['delivery_charge'];
    _totalCostMobile = json['total_cost_mobile'];
    _totalCostMobileWithoutDeilveryCharges = json['total_cost_mobile_without_deilvery_charges'];
    _point = json['point'];
    _companyName = json['company_name'];
    _companyArbName = json['company_arb_name'];
    _companyImage = json['companyImage'];
    _name = json['name'];
    _vipCode = json['vip_code'];
    _cityCode = json['city_code'];
    _mobile = json['mobile'];
    _discountOffer = json['discount_offer'];
    _productName = json['product_name'];
    _picture = json['picture'];
    _serviceCharge = json['service_charge'];
    _citycodeVat = json['citycode_vat'];
    _supplierVatCharges = json['supplierVat_charges'];
    _originalPrice = json['original_price'];
    _cityCodeBenefits = json['cityCode_benefits'];
    _price = json['price'];
    _deliveryKm = json['delivery_km'];
    _arbProductName = json['arb_product_name'];
    _branchName = json['branch_name'];
  }
  String? _orderId;
  String? _userId;
  String? _paymentStatus;
  String? _companyId;
  String? _branchId;
  String? _transactionId;
  String? _productId;
  String? _qty;
  String? _actualPrice;
  String? _afterdiscountPrice;
  String? _discountPercent;
  String? _discountOfferCitycode;
  String? _totalAmount;
  String? _productCostMobile;
  String? _productDiscountMobile;
  String? _createdDate;
  String? _suppliervatCharges;
  String? _appServiceCharge;
  String? _cityCodeVatCharge;
  String? _deliveryCharge;
  String? _totalCostMobile;
  String? _totalCostMobileWithoutDeilveryCharges;
  String? _point;
  String? _companyName;
  String? _companyArbName;
  String? _companyImage;
  String? _name;
  String? _vipCode;
  String? _cityCode;
  String? _mobile;
  String? _discountOffer;
  String? _productName;
  String? _picture;
  String? _serviceCharge;
  String? _citycodeVat;
  String? _supplierVatCharges;
  String? _originalPrice;
  String? _cityCodeBenefits;
  String? _price;
  String? _deliveryKm;
  String? _arbProductName;
  String? _branchName;
MyOrder copyWith({  String? orderId,
  String? userId,
  String? paymentStatus,
  String? companyId,
  String? branchId,
  String? transactionId,
  String? productId,
  String? qty,
  String? actualPrice,
  String? afterdiscountPrice,
  String? discountPercent,
  String? discountOfferCitycode,
  String? totalAmount,
  String? productCostMobile,
  String? productDiscountMobile,
  String? createdDate,
  String? suppliervatCharges,
  String? appServiceCharge,
  String? cityCodeVatCharge,
  String? deliveryCharge,
  String? totalCostMobile,
  String? totalCostMobileWithoutDeilveryCharges,
  String? point,
  String? companyName,
  String? companyArbName,
  String? companyImage,
  String? name,
  String? vipCode,
  String? cityCode,
  String? mobile,
  String? discountOffer,
  String? productName,
  String? picture,
  String? serviceCharge,
  String? citycodeVat,
  String? supplierVatCharges,
  String? originalPrice,
  String? cityCodeBenefits,
  String? price,
  String? deliveryKm,
  String? arbProductName,
  String? branchName,
}) => MyOrder(  orderId: orderId ?? _orderId,
  userId: userId ?? _userId,
  paymentStatus: paymentStatus ?? _paymentStatus,
  companyId: companyId ?? _companyId,
  branchId: branchId ?? _branchId,
  transactionId: transactionId ?? _transactionId,
  productId: productId ?? _productId,
  qty: qty ?? _qty,
  actualPrice: actualPrice ?? _actualPrice,
  afterdiscountPrice: afterdiscountPrice ?? _afterdiscountPrice,
  discountPercent: discountPercent ?? _discountPercent,
  discountOfferCitycode: discountOfferCitycode ?? _discountOfferCitycode,
  totalAmount: totalAmount ?? _totalAmount,
  productCostMobile: productCostMobile ?? _productCostMobile,
  productDiscountMobile: productDiscountMobile ?? _productDiscountMobile,
  createdDate: createdDate ?? _createdDate,
  suppliervatCharges: suppliervatCharges ?? _suppliervatCharges,
  appServiceCharge: appServiceCharge ?? _appServiceCharge,
  cityCodeVatCharge: cityCodeVatCharge ?? _cityCodeVatCharge,
  deliveryCharge: deliveryCharge ?? _deliveryCharge,
  totalCostMobile: totalCostMobile ?? _totalCostMobile,
  totalCostMobileWithoutDeilveryCharges: totalCostMobileWithoutDeilveryCharges ?? _totalCostMobileWithoutDeilveryCharges,
  point: point ?? _point,
  companyName: companyName ?? _companyName,
  companyArbName: companyArbName ?? _companyArbName,
  companyImage: companyImage ?? _companyImage,
  name: name ?? _name,
  vipCode: vipCode ?? _vipCode,
  cityCode: cityCode ?? _cityCode,
  mobile: mobile ?? _mobile,
  discountOffer: discountOffer ?? _discountOffer,
  productName: productName ?? _productName,
  picture: picture ?? _picture,
  serviceCharge: serviceCharge ?? _serviceCharge,
  citycodeVat: citycodeVat ?? _citycodeVat,
  supplierVatCharges: supplierVatCharges ?? _supplierVatCharges,
  originalPrice: originalPrice ?? _originalPrice,
  cityCodeBenefits: cityCodeBenefits ?? _cityCodeBenefits,
  price: price ?? _price,
  deliveryKm: deliveryKm ?? _deliveryKm,
  arbProductName: arbProductName ?? _arbProductName,
  branchName: branchName ?? _branchName,
);
  String? get orderId => _orderId;
  String? get userId => _userId;
  String? get paymentStatus => _paymentStatus;
  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get transactionId => _transactionId;
  String? get productId => _productId;
  String? get qty => _qty;
  String? get actualPrice => _actualPrice;
  String? get afterdiscountPrice => _afterdiscountPrice;
  String? get discountPercent => _discountPercent;
  String? get discountOfferCitycode => _discountOfferCitycode;
  String? get totalAmount => _totalAmount;
  String? get productCostMobile => _productCostMobile;
  String? get productDiscountMobile => _productDiscountMobile;
  String? get createdDate => _createdDate;
  String? get suppliervatCharges => _suppliervatCharges;
  String? get appServiceCharge => _appServiceCharge;
  String? get cityCodeVatCharge => _cityCodeVatCharge;
  String? get deliveryCharge => _deliveryCharge;
  String? get totalCostMobile => _totalCostMobile;
  String? get totalCostMobileWithoutDeilveryCharges => _totalCostMobileWithoutDeilveryCharges;
  String? get point => _point;
  String? get companyName => _companyName;
  String? get companyArbName => _companyArbName;
  String? get companyImage => _companyImage;
  String? get name => _name;
  String? get vipCode => _vipCode;
  String? get cityCode => _cityCode;
  String? get mobile => _mobile;
  String? get discountOffer => _discountOffer;
  String? get productName => _productName;
  String? get picture => _picture;
  String? get serviceCharge => _serviceCharge;
  String? get citycodeVat => _citycodeVat;
  String? get supplierVatCharges => _supplierVatCharges;
  String? get originalPrice => _originalPrice;
  String? get cityCodeBenefits => _cityCodeBenefits;
  String? get price => _price;
  String? get deliveryKm => _deliveryKm;
  String? get arbProductName => _arbProductName;
  String? get branchName => _branchName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['user_id'] = _userId;
    map['payment_status'] = _paymentStatus;
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['transaction_id'] = _transactionId;
    map['product_id'] = _productId;
    map['qty'] = _qty;
    map['actual_price'] = _actualPrice;
    map['afterdiscount_price'] = _afterdiscountPrice;
    map['discount_percent'] = _discountPercent;
    map['discount_offer_citycode'] = _discountOfferCitycode;
    map['total_amount'] = _totalAmount;
    map['product_cost_mobile'] = _productCostMobile;
    map['product_discount_mobile'] = _productDiscountMobile;
    map['created_date'] = _createdDate;
    map['suppliervat_charges'] = _suppliervatCharges;
    map['appService_charge'] = _appServiceCharge;
    map['cityCodeVat_Charge'] = _cityCodeVatCharge;
    map['delivery_charge'] = _deliveryCharge;
    map['total_cost_mobile'] = _totalCostMobile;
    map['total_cost_mobile_without_deilvery_charges'] = _totalCostMobileWithoutDeilveryCharges;
    map['point'] = _point;
    map['company_name'] = _companyName;
    map['company_arb_name'] = _companyArbName;
    map['companyImage'] = _companyImage;
    map['name'] = _name;
    map['vip_code'] = _vipCode;
    map['city_code'] = _cityCode;
    map['mobile'] = _mobile;
    map['discount_offer'] = _discountOffer;
    map['product_name'] = _productName;
    map['picture'] = _picture;
    map['service_charge'] = _serviceCharge;
    map['citycode_vat'] = _citycodeVat;
    map['supplierVat_charges'] = _supplierVatCharges;
    map['original_price'] = _originalPrice;
    map['cityCode_benefits'] = _cityCodeBenefits;
    map['price'] = _price;
    map['delivery_km'] = _deliveryKm;
    map['arb_product_name'] = _arbProductName;
    map['branch_name'] = _branchName;
    return map;
  }

}

/// success : "My Order list successfully.."

class Messages {
  Messages({
      String? success,}){
    _success = success;
}

  Messages.fromJson(dynamic json) {
    _success = json['success'];
  }
  String? _success;
Messages copyWith({  String? success,
}) => Messages(  success: success ?? _success,
);
  String? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    return map;
  }

}