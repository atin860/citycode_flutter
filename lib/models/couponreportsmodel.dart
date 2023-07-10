/// status : 201
/// error : null
/// messages : {"success":"successfully"}
/// userCouponReport : [{"id":"35","user_id":"22064","coupon_id":"37","purchase_status":"Expire","company_id":"257","branch_id":"263","created":"2022-12-26 17:46:20","coupon_name":"testcoupon","coupon_amount":"20.000","coupon_price":"10.000","start_date":"2022-12-22","end_date":"2022-12-25","arb_coupon_name":"كوبون تجريبي","coupon_details":"This content is not approved by City Code subscribers because it is a trial version through which the application is examined and developed","arb_coupon_details":"هذا المحتوى لا يتم اعتمادة من قبل مشتركين ستي كود لانه عباره عن نسخة تجريبيه يتم من خلالها فحص التطبيق وتطويره","name":"rohan","company_name":"CityCodeCoupon","city_code":"G1985"},{"id":"36","user_id":"22064","coupon_id":"39","purchase_status":"Used","company_id":"103","branch_id":"67","created":"2022-12-26 19:33:22","coupon_name":"test321","coupon_amount":"1.000","coupon_price":"1.000","start_date":"2022-12-26","end_date":"2022-12-28","arb_coupon_name":"coupontest","coupon_details":"detail","arb_coupon_details":"detail","name":"rohan","company_name":"MooChuu","city_code":"G1985"}]

class Couponreportsmodel {
  Couponreportsmodel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      List<UserCouponReport>? userCouponReport,}){
    _status = status;
    _error = error;
    _messages = messages;
    _userCouponReport = userCouponReport;
}

  Couponreportsmodel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    if (json['userCouponReport'] != null) {
      _userCouponReport = [];
      json['userCouponReport'].forEach((v) {
        _userCouponReport?.add(UserCouponReport.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  List<UserCouponReport>? _userCouponReport;
Couponreportsmodel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  List<UserCouponReport>? userCouponReport,
}) => Couponreportsmodel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  userCouponReport: userCouponReport ?? _userCouponReport,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  List<UserCouponReport>? get userCouponReport => _userCouponReport;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_userCouponReport != null) {
      map['userCouponReport'] = _userCouponReport?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "35"
/// user_id : "22064"
/// coupon_id : "37"
/// purchase_status : "Expire"
/// company_id : "257"
/// branch_id : "263"
/// created : "2022-12-26 17:46:20"
/// coupon_name : "testcoupon"
/// coupon_amount : "20.000"
/// coupon_price : "10.000"
/// start_date : "2022-12-22"
/// end_date : "2022-12-25"
/// arb_coupon_name : "كوبون تجريبي"
/// coupon_details : "This content is not approved by City Code subscribers because it is a trial version through which the application is examined and developed"
/// arb_coupon_details : "هذا المحتوى لا يتم اعتمادة من قبل مشتركين ستي كود لانه عباره عن نسخة تجريبيه يتم من خلالها فحص التطبيق وتطويره"
/// name : "rohan"
/// company_name : "CityCodeCoupon"
/// city_code : "G1985"

class UserCouponReport {
  UserCouponReport({
      String? id, 
      String? userId, 
      String? couponId, 
      String? purchaseStatus, 
      String? companyId, 
      String? branchId, 
      String? created, 
      String? couponName, 
      String? couponAmount, 
      String? couponPrice, 
      String? startDate, 
      String? endDate, 
      String? arbCouponName, 
      String? couponDetails, 
      String? arbCouponDetails, 
      String? name, 
      String? companyName, 
      String? cityCode,
      String? paidamount,}){
    _id = id;
    _userId = userId;
    _couponId = couponId;
    _purchaseStatus = purchaseStatus;
    _companyId = companyId;
    _branchId = branchId;
    _created = created;
    _couponName = couponName;
    _couponAmount = couponAmount;
    _couponPrice = couponPrice;
    _startDate = startDate;
    _endDate = endDate;
    _arbCouponName = arbCouponName;
    _couponDetails = couponDetails;
    _arbCouponDetails = arbCouponDetails;
    _name = name;
    _companyName = companyName;
    _cityCode = cityCode;
    _paidamount=paidamount;
}

  UserCouponReport.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _couponId = json['coupon_id'];
    _purchaseStatus = json['purchase_status'];
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _created = json['created'];
    _couponName = json['coupon_name'];
    _couponAmount = json['coupon_amount'];
    _couponPrice = json['coupon_price'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _arbCouponName = json['arb_coupon_name'];
    _couponDetails = json['coupon_details'];
    _arbCouponDetails = json['arb_coupon_details'];
    _name = json['name'];
    _companyName = json['company_name'];
    _cityCode = json['city_code'];
    _paidamount=json['od_paidamount'];
  }
  String? _id;
  String? _userId;
  String? _couponId;
  String? _purchaseStatus;
  String? _companyId;
  String? _branchId;
  String? _created;
  String? _couponName;
  String? _couponAmount;
  String? _couponPrice;
  String? _startDate;
  String? _endDate;
  String? _arbCouponName;
  String? _couponDetails;
  String? _arbCouponDetails;
  String? _name;
  String? _companyName;
  String? _cityCode;
  String?_paidamount;
UserCouponReport copyWith({  String? id,
  String? userId,
  String? couponId,
  String? purchaseStatus,
  String? companyId,
  String? branchId,
  String? created,
  String? couponName,
  String? couponAmount,
  String? couponPrice,
  String? startDate,
  String? endDate,
  String? arbCouponName,
  String? couponDetails,
  String? arbCouponDetails,
  String? name,
  String? companyName,
  String? cityCode,
  String? paidamount,
}) => UserCouponReport(  id: id ?? _id,
  userId: userId ?? _userId,
  couponId: couponId ?? _couponId,
  purchaseStatus: purchaseStatus ?? _purchaseStatus,
  companyId: companyId ?? _companyId,
  branchId: branchId ?? _branchId,
  created: created ?? _created,
  couponName: couponName ?? _couponName,
  couponAmount: couponAmount ?? _couponAmount,
  couponPrice: couponPrice ?? _couponPrice,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  arbCouponName: arbCouponName ?? _arbCouponName,
  couponDetails: couponDetails ?? _couponDetails,
  arbCouponDetails: arbCouponDetails ?? _arbCouponDetails,
  name: name ?? _name,
  companyName: companyName ?? _companyName,
  cityCode: cityCode ?? _cityCode,
    paidamount:paidamount??_paidamount,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get couponId => _couponId;
  String? get purchaseStatus => _purchaseStatus;
  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get created => _created;
  String? get couponName => _couponName;
  String? get couponAmount => _couponAmount;
  String? get couponPrice => _couponPrice;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get arbCouponName => _arbCouponName;
  String? get couponDetails => _couponDetails;
  String? get arbCouponDetails => _arbCouponDetails;
  String? get name => _name;
  String? get companyName => _companyName;
  String? get cityCode => _cityCode;
  String? get paidamount =>_paidamount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['coupon_id'] = _couponId;
    map['purchase_status'] = _purchaseStatus;
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['created'] = _created;
    map['coupon_name'] = _couponName;
    map['coupon_amount'] = _couponAmount;
    map['coupon_price'] = _couponPrice;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['arb_coupon_name'] = _arbCouponName;
    map['coupon_details'] = _couponDetails;
    map['arb_coupon_details'] = _arbCouponDetails;
    map['name'] = _name;
    map['company_name'] = _companyName;
    map['city_code'] = _cityCode;
    map['od_paidamount']=_paidamount;
    return map;
  }

}

/// success : "successfully"

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