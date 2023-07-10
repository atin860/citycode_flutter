/// status : 201
/// error : null
/// messages : {"success":"list successfully"}
/// company_image_base_url : "http://cp.citycode.om/public/company/"
/// company_coupon_list : [{"id":"138","start_date":"2023-02-03","end_date":"2023-03-18","coupon_name":"coupon1","arb_coupon_name":"coupon1","coupon_amount":"5.000","coupon_price":"3.000","company_id":"265","branch_id":"271","coupon_details":"coupon1","arb_coupon_details":"coupon1","coupon_quantity":"0","status":"1","autounique":"coupon-CADGM6Z3KG","created":"2023-02-03 12:31:02","company_name":"AB","picture":"XWFI5466.JPG","coupon_status":"1","branch_name":"AABB"}]

// ignore_for_file: file_names

class CompanycoupondetailModel {
  CompanycoupondetailModel({
    int? status,
    dynamic error,
    Messages? messages,
    String? companyImageBaseUrl,
    List<CompanyCouponList>? companyCouponList,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _companyImageBaseUrl = companyImageBaseUrl;
    _companyCouponList = companyCouponList;
  }

  CompanycoupondetailModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _companyImageBaseUrl = json['company_image_base_url'];
    if (json['company_coupon_list'] != null) {
      _companyCouponList = [];
      json['company_coupon_list'].forEach((v) {
        _companyCouponList?.add(CompanyCouponList.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _companyImageBaseUrl;
  List<CompanyCouponList>? _companyCouponList;
  CompanycoupondetailModel copyWith({
    int? status,
    dynamic error,
    Messages? messages,
    String? companyImageBaseUrl,
    List<CompanyCouponList>? companyCouponList,
  }) =>
      CompanycoupondetailModel(
        status: status ?? _status,
        error: error ?? _error,
        messages: messages ?? _messages,
        companyImageBaseUrl: companyImageBaseUrl ?? _companyImageBaseUrl,
        companyCouponList: companyCouponList ?? _companyCouponList,
      );
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get companyImageBaseUrl => _companyImageBaseUrl;
  List<CompanyCouponList>? get companyCouponList => _companyCouponList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['company_image_base_url'] = _companyImageBaseUrl;
    if (_companyCouponList != null) {
      map['company_coupon_list'] =
          _companyCouponList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "138"
/// start_date : "2023-02-03"
/// end_date : "2023-03-18"
/// coupon_name : "coupon1"
/// arb_coupon_name : "coupon1"
/// coupon_amount : "5.000"
/// coupon_price : "3.000"
/// company_id : "265"
/// branch_id : "271"
/// coupon_details : "coupon1"
/// arb_coupon_details : "coupon1"
/// coupon_quantity : "0"
/// status : "1"
/// autounique : "coupon-CADGM6Z3KG"
/// created : "2023-02-03 12:31:02"
/// company_name : "AB"
/// picture : "XWFI5466.JPG"
/// coupon_status : "1"
/// branch_name : "AABB"

class CompanyCouponList {
  CompanyCouponList({
    String? id,
    String? startDate,
    String? endDate,
    String? couponName,
    String? arbCouponName,
    String? couponAmount,
    String? couponPrice,
    String? companyId,
    String? branchId,
    String? couponDetails,
    String? arbCouponDetails,
    String? couponQuantity,
    String? status,
    String? autounique,
    String? created,
    String? companyName,
    String? picture,
    String? couponStatus,
    String? branchName,
  }) {
    _id = id;
    _startDate = startDate;
    _endDate = endDate;
    _couponName = couponName;
    _arbCouponName = arbCouponName;
    _couponAmount = couponAmount;
    _couponPrice = couponPrice;
    _companyId = companyId;
    _branchId = branchId;
    _couponDetails = couponDetails;
    _arbCouponDetails = arbCouponDetails;
    _couponQuantity = couponQuantity;
    _status = status;
    _autounique = autounique;
    _created = created;
    _companyName = companyName;
    _picture = picture;
    _couponStatus = couponStatus;
    _branchName = branchName;
  }

  CompanyCouponList.fromJson(dynamic json) {
    _id = json['id'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _couponName = json['coupon_name'];
    _arbCouponName = json['arb_coupon_name'];
    _couponAmount = json['coupon_amount'];
    _couponPrice = json['coupon_price'];
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _couponDetails = json['coupon_details'];
    _arbCouponDetails = json['arb_coupon_details'];
    _couponQuantity = json['coupon_quantity'];
    _status = json['status'];
    _autounique = json['autounique'];
    _created = json['created'];
    _companyName = json['company_name'];
    _picture = json['picture'];
    _couponStatus = json['coupon_status'];
    _branchName = json['branch_name'];
  }
  String? _id;
  String? _startDate;
  String? _endDate;
  String? _couponName;
  String? _arbCouponName;
  String? _couponAmount;
  String? _couponPrice;
  String? _companyId;
  String? _branchId;
  String? _couponDetails;
  String? _arbCouponDetails;
  String? _couponQuantity;
  String? _status;
  String? _autounique;
  String? _created;
  String? _companyName;
  String? _picture;
  String? _couponStatus;
  String? _branchName;
  CompanyCouponList copyWith({
    String? id,
    String? startDate,
    String? endDate,
    String? couponName,
    String? arbCouponName,
    String? couponAmount,
    String? couponPrice,
    String? companyId,
    String? branchId,
    String? couponDetails,
    String? arbCouponDetails,
    String? couponQuantity,
    String? status,
    String? autounique,
    String? created,
    String? companyName,
    String? picture,
    String? couponStatus,
    String? branchName,
  }) =>
      CompanyCouponList(
        id: id ?? _id,
        startDate: startDate ?? _startDate,
        endDate: endDate ?? _endDate,
        couponName: couponName ?? _couponName,
        arbCouponName: arbCouponName ?? _arbCouponName,
        couponAmount: couponAmount ?? _couponAmount,
        couponPrice: couponPrice ?? _couponPrice,
        companyId: companyId ?? _companyId,
        branchId: branchId ?? _branchId,
        couponDetails: couponDetails ?? _couponDetails,
        arbCouponDetails: arbCouponDetails ?? _arbCouponDetails,
        couponQuantity: couponQuantity ?? _couponQuantity,
        status: status ?? _status,
        autounique: autounique ?? _autounique,
        created: created ?? _created,
        companyName: companyName ?? _companyName,
        picture: picture ?? _picture,
        couponStatus: couponStatus ?? _couponStatus,
        branchName: branchName ?? _branchName,
      );
  String? get id => _id;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get couponName => _couponName;
  String? get arbCouponName => _arbCouponName;
  String? get couponAmount => _couponAmount;
  String? get couponPrice => _couponPrice;
  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get couponDetails => _couponDetails;
  String? get arbCouponDetails => _arbCouponDetails;
  String? get couponQuantity => _couponQuantity;
  String? get status => _status;
  String? get autounique => _autounique;
  String? get created => _created;
  String? get companyName => _companyName;
  String? get picture => _picture;
  String? get couponStatus => _couponStatus;
  String? get branchName => _branchName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['coupon_name'] = _couponName;
    map['arb_coupon_name'] = _arbCouponName;
    map['coupon_amount'] = _couponAmount;
    map['coupon_price'] = _couponPrice;
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['coupon_details'] = _couponDetails;
    map['arb_coupon_details'] = _arbCouponDetails;
    map['coupon_quantity'] = _couponQuantity;
    map['status'] = _status;
    map['autounique'] = _autounique;
    map['created'] = _created;
    map['company_name'] = _companyName;
    map['picture'] = _picture;
    map['coupon_status'] = _couponStatus;
    map['branch_name'] = _branchName;
    return map;
  }
}

/// success : "list successfully"

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
