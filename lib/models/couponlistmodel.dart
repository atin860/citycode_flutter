/// status : 201
/// error : null
/// messages : {"success":"list successfully"}
/// company_image_base_url : "http://cp.citycode.om/public/company/"
/// coupon_list : [{"id":"8","start_date":"2022-11-10","end_date":"2022-11-25","coupon_name":"test123","coupon_amount":"20.000","coupon_price":"2.000","company_id":"103","branch_id":"0","coupon_details":"fdafdafda","coupon_quantity":"10","status":"1","created":"2022-11-24 13:36:49","company_name":"MooChuu","picture":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":null},{"id":"7","start_date":"2022-11-10","end_date":"2022-11-30","coupon_name":"testcoupon","coupon_amount":"50.000","coupon_price":"5.000","company_id":"103","branch_id":"14","coupon_details":"details","coupon_quantity":"5","status":"1","created":"2022-11-24 11:15:21","company_name":"MooChuu","picture":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch"},{"id":"5","start_date":"2022-11-14","end_date":"2022-11-30","coupon_name":"test","coupon_amount":"80.000","coupon_price":"10.000","company_id":"103","branch_id":"67","coupon_details":"","coupon_quantity":"0","status":"1","created":"2022-11-21 20:14:45","company_name":"MooChuu","picture":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Oman mall Branch "}]

class Couponlistmodel {
  Couponlistmodel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? companyImageBaseUrl, 
      List<CouponList>? couponList,}){
    _status = status;
    _error = error;
    _messages = messages;
    _companyImageBaseUrl = companyImageBaseUrl;
    _couponList = couponList;
}

  Couponlistmodel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _companyImageBaseUrl = json['company_image_base_url'];
    if (json['coupon_list'] != null) {
      _couponList = [];
      json['coupon_list'].forEach((v) {
        _couponList?.add(CouponList.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _companyImageBaseUrl;
  List<CouponList>? _couponList;
Couponlistmodel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  String? companyImageBaseUrl,
  List<CouponList>? couponList,
}) => Couponlistmodel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  companyImageBaseUrl: companyImageBaseUrl ?? _companyImageBaseUrl,
  couponList: couponList ?? _couponList,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get companyImageBaseUrl => _companyImageBaseUrl;
  List<CouponList>? get couponList => _couponList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['company_image_base_url'] = _companyImageBaseUrl;
    if (_couponList != null) {
      map['coupon_list'] = _couponList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "8"
/// start_date : "2022-11-10"
/// end_date : "2022-11-25"
/// coupon_name : "test123"
/// coupon_amount : "20.000"
/// coupon_price : "2.000"
/// company_id : "103"
/// branch_id : "0"
/// coupon_details : "fdafdafda"
/// coupon_quantity : "10"
/// status : "1"
/// created : "2022-11-24 13:36:49"
/// company_name : "MooChuu"
/// picture : "WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg"
/// branch_name : null

class CouponList {
  CouponList({
      String? id, 
      String? startDate, 
      String? endDate, 
      String? couponName, 
      String? couponAmount, 
      String? couponPrice, 
      String? companyId, 
      String? branchId, 
      String? couponDetails, 
      String? couponQuantity, 
      String? status, 
      String? created, 
      String? companyName, 
      String? picture, 
      dynamic branchName,
  String? arbdetail,}){
    _id = id;
    _startDate = startDate;
    _endDate = endDate;
    _couponName = couponName;
    _couponAmount = couponAmount;
    _couponPrice = couponPrice;
    _companyId = companyId;
    _branchId = branchId;
    _couponDetails = couponDetails;
    _couponQuantity = couponQuantity;
    _status = status;
    _created = created;
    _companyName = companyName;
    _picture = picture;
    _branchName = branchName;
    _arbdetail=arbdetail;

}

  CouponList.fromJson(dynamic json) {
    _id = json['id'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _couponName = json['coupon_name'];
    _couponAmount = json['coupon_amount'];
    _couponPrice = json['coupon_price'];
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _couponDetails = json['coupon_details'];
    _couponQuantity = json['coupon_quantity'];
    _status = json['status'];
    _created = json['created'];
    _companyName = json['company_name'];
    _picture = json['picture'];
    _branchName = json['branch_name'];
    _arbdetail=json['arb_coupon_details'];
  }
  String? _id;
  String? _startDate;
  String? _endDate;
  String? _couponName;
  String? _couponAmount;
  String? _couponPrice;
  String? _companyId;
  String? _branchId;
  String? _couponDetails;
  String? _couponQuantity;
  String? _status;
  String? _created;
  String? _companyName;
  String? _picture;
  dynamic _branchName;
  String? _arbdetail;
CouponList copyWith({  String? id,
  String? startDate,
  String? endDate,
  String? couponName,
  String? couponAmount,
  String? couponPrice,
  String? companyId,
  String? branchId,
  String? couponDetails,
  String? couponQuantity,
  String? status,
  String? created,
  String? companyName,
  String? picture,
  dynamic branchName,
  String? arbdetail,
}) => CouponList(  id: id ?? _id,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  couponName: couponName ?? _couponName,
  couponAmount: couponAmount ?? _couponAmount,
  couponPrice: couponPrice ?? _couponPrice,
  companyId: companyId ?? _companyId,
  branchId: branchId ?? _branchId,
  couponDetails: couponDetails ?? _couponDetails,
  couponQuantity: couponQuantity ?? _couponQuantity,
  status: status ?? _status,
  created: created ?? _created,
  companyName: companyName ?? _companyName,
  picture: picture ?? _picture,
  branchName: branchName ?? _branchName,
    arbdetail:arbdetail??_arbdetail,
);
  String? get id => _id;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get couponName => _couponName;
  String? get couponAmount => _couponAmount;
  String? get couponPrice => _couponPrice;
  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get couponDetails => _couponDetails;
  String? get couponQuantity => _couponQuantity;
  String? get status => _status;
  String? get created => _created;
  String? get companyName => _companyName;
  String? get picture => _picture;
  dynamic get branchName => _branchName;
  String? get arbdetail => _arbdetail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['coupon_name'] = _couponName;
    map['coupon_amount'] = _couponAmount;
    map['coupon_price'] = _couponPrice;
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['coupon_details'] = _couponDetails;
    map['coupon_quantity'] = _couponQuantity;
    map['status'] = _status;
    map['created'] = _created;
    map['company_name'] = _companyName;
    map['picture'] = _picture;
    map['branch_name'] = _branchName;
    map['arb_coupon_details']=_arbdetail;
    return map;
  }

}

/// success : "list successfully"

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