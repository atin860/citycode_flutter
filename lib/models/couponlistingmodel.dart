/// status : 201
/// error : null
/// messages : {"success":"successfully"}
/// company_image_base_url : "http://cp.citycode.om/public/company/"
/// userCouponList : [{"id":"31","user_id":"22064","coupon_id":"31","purchase_status":"Active","company_id":"103","branch_id":"67","created":"2022-12-13 19:42:40","start_date":"2022-12-13","end_date":"2022-12-14","coupon_name":"test","arb_coupon_name":"test","coupon_amount":"1.000","coupon_price":"2.000","coupon_details":"test123","arb_coupon_details":"test123","coupon_quantity":"2","status":"1","company_name":"MooChuu","picture":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Oman mall Branch "}]

class Couponlistingmodel {
  Couponlistingmodel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? companyImageBaseUrl, 
      List<UserCouponList>? userCouponList,}){
    _status = status;
    _error = error;
    _messages = messages;
    _companyImageBaseUrl = companyImageBaseUrl;
    _userCouponList = userCouponList;
}

  Couponlistingmodel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _companyImageBaseUrl = json['company_image_base_url'];
    if (json['userCouponList'] != null) {
      _userCouponList = [];
      json['userCouponList'].forEach((v) {
        _userCouponList?.add(UserCouponList.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _companyImageBaseUrl;
  List<UserCouponList>? _userCouponList;
Couponlistingmodel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  String? companyImageBaseUrl,
  List<UserCouponList>? userCouponList,
}) => Couponlistingmodel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  companyImageBaseUrl: companyImageBaseUrl ?? _companyImageBaseUrl,
  userCouponList: userCouponList ?? _userCouponList,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get companyImageBaseUrl => _companyImageBaseUrl;
  List<UserCouponList>? get userCouponList => _userCouponList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['company_image_base_url'] = _companyImageBaseUrl;
    if (_userCouponList != null) {
      map['userCouponList'] = _userCouponList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "31"
/// user_id : "22064"
/// coupon_id : "31"
/// purchase_status : "Active"
/// company_id : "103"
/// branch_id : "67"
/// created : "2022-12-13 19:42:40"
/// start_date : "2022-12-13"
/// end_date : "2022-12-14"
/// coupon_name : "test"
/// arb_coupon_name : "test"
/// coupon_amount : "1.000"
/// coupon_price : "2.000"
/// coupon_details : "test123"
/// arb_coupon_details : "test123"
/// coupon_quantity : "2"
/// status : "1"
/// company_name : "MooChuu"
/// picture : "WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg"
/// branch_name : "Oman mall Branch "

class UserCouponList {
  UserCouponList({
      String? id, 
      String? userId, 
      String? couponId, 
      String? purchaseStatus, 
      String? companyId, 
      String? branchId, 
      String? created, 
      String? startDate, 
      String? endDate, 
      String? couponName, 
      String? arbCouponName, 
      String? couponAmount, 
      String? couponPrice, 
      String? couponDetails, 
      String? arbCouponDetails, 
      String? couponQuantity, 
      String? status, 
      String? companyName, 
      String? picture, 
      String? branchName,
  String? perchaseid,}){
    _id = id;
    _userId = userId;
    _couponId = couponId;
    _purchaseStatus = purchaseStatus;
    _companyId = companyId;
    _branchId = branchId;
    _created = created;
    _startDate = startDate;
    _endDate = endDate;
    _couponName = couponName;
    _arbCouponName = arbCouponName;
    _couponAmount = couponAmount;
    _couponPrice = couponPrice;
    _couponDetails = couponDetails;
    _arbCouponDetails = arbCouponDetails;
    _couponQuantity = couponQuantity;
    _status = status;
    _companyName = companyName;
    _picture = picture;
    _branchName = branchName;
    perchaseid=perchaseid;
}

  UserCouponList.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _couponId = json['coupon_id'];
    _purchaseStatus = json['purchase_status'];
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _created = json['created'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _couponName = json['coupon_name'];
    _arbCouponName = json['arb_coupon_name'];
    _couponAmount = json['coupon_amount'];
    _couponPrice = json['coupon_price'];
    _couponDetails = json['coupon_details'];
    _arbCouponDetails = json['arb_coupon_details'];
    _couponQuantity = json['coupon_quantity'];
    _status = json['status'];
    _companyName = json['company_name'];
    _picture = json['picture'];
    _branchName = json['branch_name'];
    _perchaseid=json['coupon_purchase_id'];
  }
  String? _id;
  String? _userId;
  String? _couponId;
  String? _purchaseStatus;
  String? _companyId;
  String? _branchId;
  String? _created;
  String? _startDate;
  String? _endDate;
  String? _couponName;
  String? _arbCouponName;
  String? _couponAmount;
  String? _couponPrice;
  String? _couponDetails;
  String? _arbCouponDetails;
  String? _couponQuantity;
  String? _status;
  String? _companyName;
  String? _picture;
  String? _branchName;
  String? _perchaseid;
UserCouponList copyWith({  String? id,
  String? userId,
  String? couponId,
  String? purchaseStatus,
  String? companyId,
  String? branchId,
  String? created,
  String? startDate,
  String? endDate,
  String? couponName,
  String? arbCouponName,
  String? couponAmount,
  String? couponPrice,
  String? couponDetails,
  String? arbCouponDetails,
  String? couponQuantity,
  String? status,
  String? companyName,
  String? picture,
  String? branchName,
  String? perchaseid,
}) => UserCouponList(  id: id ?? _id,
  userId: userId ?? _userId,
  couponId: couponId ?? _couponId,
  purchaseStatus: purchaseStatus ?? _purchaseStatus,
  companyId: companyId ?? _companyId,
  branchId: branchId ?? _branchId,
  created: created ?? _created,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  couponName: couponName ?? _couponName,
  arbCouponName: arbCouponName ?? _arbCouponName,
  couponAmount: couponAmount ?? _couponAmount,
  couponPrice: couponPrice ?? _couponPrice,
  couponDetails: couponDetails ?? _couponDetails,
  arbCouponDetails: arbCouponDetails ?? _arbCouponDetails,
  couponQuantity: couponQuantity ?? _couponQuantity,
  status: status ?? _status,
  companyName: companyName ?? _companyName,
  picture: picture ?? _picture,
  branchName: branchName ?? _branchName,
    perchaseid:_perchaseid??_perchaseid,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get couponId => _couponId;
  String? get purchaseStatus => _purchaseStatus;
  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get created => _created;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get couponName => _couponName;
  String? get arbCouponName => _arbCouponName;
  String? get couponAmount => _couponAmount;
  String? get couponPrice => _couponPrice;
  String? get couponDetails => _couponDetails;
  String? get arbCouponDetails => _arbCouponDetails;
  String? get couponQuantity => _couponQuantity;
  String? get status => _status;
  String? get companyName => _companyName;
  String? get picture => _picture;
  String? get branchName => _branchName;
  String? get perchaseid=>_perchaseid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['coupon_id'] = _couponId;
    map['purchase_status'] = _purchaseStatus;
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['created'] = _created;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['coupon_name'] = _couponName;
    map['arb_coupon_name'] = _arbCouponName;
    map['coupon_amount'] = _couponAmount;
    map['coupon_price'] = _couponPrice;
    map['coupon_details'] = _couponDetails;
    map['arb_coupon_details'] = _arbCouponDetails;
    map['coupon_quantity'] = _couponQuantity;
    map['status'] = _status;
    map['company_name'] = _companyName;
    map['picture'] = _picture;
    map['branch_name'] = _branchName;
    map['coupon_purchase_id']=_perchaseid;
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