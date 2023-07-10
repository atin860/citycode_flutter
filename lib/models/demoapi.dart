/// status : 201
/// error : null
///
///  companycoupondata!.isEmpty?
//                                           offerlist![position]
//                                                   .customerDiscount! :companycoupondata![position].companyName!+
//                                               "%",


///child: companycoupondata!.isEmpty?Text(
//                                             Constants.language == "en"
//                                                 ? companycoupondata![position].couponDetails!
//                                                 : companycoupondata![position]
//                                                         .arbCouponDetails!
//                                                         .isNotEmpty
//                                                     ? companycoupondata![position]
//                                                         .arbCouponDetails!
//                                                     : companycoupondata![position]
//                                                         .couponDetails!,
/// messages : {"success":"offer listed successfully"}
/// offerlist : [{"id":"26","company_id":"103","branch_id":"14","coupon_type":"city","company_discount":"35","comission":"0","customer_discount":"35","discount_detail":"All Items/جميع المنتجات","description":"Design your sandals with a discount of 35% on all products\r\n\r\nEnjoy the best offers and exclusive discounts on the products shown on the products and prices page\r\n\r\nAll you have to do is visit the AlKhoud branch to benefit from our discount by using your code ","arb_description":"صمم صندلك ( نعالك ) بذوقك الخاص، وبخصم 35% على جميع المنتجات\r\n\r\nاستمتع بأفضل العروض والتخفيضات الخاصة و الحصرية على المنتجات الموضحة في صفحة المنتجات والأسعار\r\n\r\n كل ما عليك هو زيارة فرع الخوض للاستفادة من التخفيضات بإستخدام كود الخصم الخاص بك","start_date":"2022-09-18 00:00:00","end_date":"2022-12-18 00:00:00"}]
/// company_status : [{"company_chat_status":"1"}]
/// coupon_data : [{"id":"29","start_date":"2022-12-02","end_date":"2022-12-11","coupon_name":"CITYCODE50","arb_coupon_name":"كود المدينة 50","coupon_amount":"20.000","coupon_price":"3.000","company_id":"103","branch_id":"14","coupon_details":"50 % OFF","arb_coupon_details":"خصم 50","coupon_quantity":"3","status":"1","created":"2022-12-05 16:56:08","company_name":"MooChuu","picture":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch"},{"id":"28","start_date":"2022-11-23","end_date":"2022-11-30","coupon_name":"test1","arb_coupon_name":"","coupon_amount":"2.000","coupon_price":"1.000","company_id":"103","branch_id":"14","coupon_details":"testing","arb_coupon_details":"","coupon_quantity":"2","status":"2","created":"2022-11-30 17:43:36","company_name":"MooChuu","picture":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch"},{"id":"27","start_date":"2022-11-03","end_date":"2022-12-03","coupon_name":"jghj","arb_coupon_name":"","coupon_amount":"50.000","coupon_price":"3.000","company_id":"103","branch_id":"14","coupon_details":"hjg","arb_coupon_details":"","coupon_quantity":"2","status":"1","created":"2022-11-30 14:09:18","company_name":"MooChuu","picture":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch"}]

class CompanyOfferModel {
  CompanyOfferModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      List<Offerlist>? offerlist, 
      List<CompanyStatus>? companyStatus, 
      List<CouponData>? couponData,}){
    _status = status;
    _error = error;
    _messages = messages;
    _offerlist = offerlist;
    _companyStatus = companyStatus;
    _couponData = couponData;
}

  CompanyOfferModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    if (json['offerlist'] != null) {
      _offerlist = [];
      json['offerlist'].forEach((v) {
        _offerlist?.add(Offerlist.fromJson(v));
      });
    }
    if (json['company_status'] != null) {
      _companyStatus = [];
      json['company_status'].forEach((v) {
        _companyStatus?.add(CompanyStatus.fromJson(v));
      });
    }
    if (json['coupon_data'] != null) {
      _couponData = [];
      json['coupon_data'].forEach((v) {
        _couponData?.add(CouponData.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  List<Offerlist>? _offerlist;
  List<CompanyStatus>? _companyStatus;
  List<CouponData>? _couponData;
  CompanyOfferModel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  List<Offerlist>? offerlist,
  List<CompanyStatus>? companyStatus,
  List<CouponData>? couponData,
}) => CompanyOfferModel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  offerlist: offerlist ?? _offerlist,
  companyStatus: companyStatus ?? _companyStatus,
  couponData: couponData ?? _couponData,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  List<Offerlist>? get offerlist => _offerlist;
  List<CompanyStatus>? get companyStatus => _companyStatus;
  List<CouponData>? get couponData => _couponData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_offerlist != null) {
      map['offerlist'] = _offerlist?.map((v) => v.toJson()).toList();
    }
    if (_companyStatus != null) {
      map['company_status'] = _companyStatus?.map((v) => v.toJson()).toList();
    }
    if (_couponData != null) {
      map['coupon_data'] = _couponData?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "29"
/// start_date : "2022-12-02"
/// end_date : "2022-12-11"
/// coupon_name : "CITYCODE50"
/// arb_coupon_name : "كود المدينة 50"
/// coupon_amount : "20.000"
/// coupon_price : "3.000"
/// company_id : "103"
/// branch_id : "14"
/// coupon_details : "50 % OFF"
/// arb_coupon_details : "خصم 50"
/// coupon_quantity : "3"
/// status : "1"
/// created : "2022-12-05 16:56:08"
/// company_name : "MooChuu"
/// picture : "WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg"
/// branch_name : "Alkhoud Branch"

class CouponData {
  CouponData({
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
      String? created, 
      String? companyName, 
      String? picture, 
      String? branchName,}){
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
    _created = created;
    _companyName = companyName;
    _picture = picture;
    _branchName = branchName;
}

  CouponData.fromJson(dynamic json) {
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
    _created = json['created'];
    _companyName = json['company_name'];
    _picture = json['picture'];
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
  String? _created;
  String? _companyName;
  String? _picture;
  String? _branchName;
CouponData copyWith({  String? id,
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
  String? created,
  String? companyName,
  String? picture,
  String? branchName,
}) => CouponData(  id: id ?? _id,
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
  created: created ?? _created,
  companyName: companyName ?? _companyName,
  picture: picture ?? _picture,
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
  String? get created => _created;
  String? get companyName => _companyName;
  String? get picture => _picture;
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
    map['created'] = _created;
    map['company_name'] = _companyName;
    map['picture'] = _picture;
    map['branch_name'] = _branchName;
    return map;
  }

}

/// company_chat_status : "1"

class CompanyStatus {
  CompanyStatus({
      String? companyChatStatus,}){
    _companyChatStatus = companyChatStatus;
}

  CompanyStatus.fromJson(dynamic json) {
    _companyChatStatus = json['company_chat_status'];
  }
  String? _companyChatStatus;
CompanyStatus copyWith({  String? companyChatStatus,
}) => CompanyStatus(  companyChatStatus: companyChatStatus ?? _companyChatStatus,
);
  String? get companyChatStatus => _companyChatStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_chat_status'] = _companyChatStatus;
    return map;
  }

}

/// id : "26"
/// company_id : "103"
/// branch_id : "14"
/// coupon_type : "city"
/// company_discount : "35"
/// comission : "0"
/// customer_discount : "35"
/// discount_detail : "All Items/جميع المنتجات"
/// description : "Design your sandals with a discount of 35% on all products\r\n\r\nEnjoy the best offers and exclusive discounts on the products shown on the products and prices page\r\n\r\nAll you have to do is visit the AlKhoud branch to benefit from our discount by using your code "
/// arb_description : "صمم صندلك ( نعالك ) بذوقك الخاص، وبخصم 35% على جميع المنتجات\r\n\r\nاستمتع بأفضل العروض والتخفيضات الخاصة و الحصرية على المنتجات الموضحة في صفحة المنتجات والأسعار\r\n\r\n كل ما عليك هو زيارة فرع الخوض للاستفادة من التخفيضات بإستخدام كود الخصم الخاص بك"
/// start_date : "2022-09-18 00:00:00"
/// end_date : "2022-12-18 00:00:00"

class Offerlist {
  Offerlist({
      String? id, 
      String? companyId, 
      String? branchId, 
      String? couponType, 
      String? companyDiscount, 
      String? comission, 
      String? customerDiscount, 
      String? discountDetail, 
      String? description, 
      String? arbDescription, 
      String? startDate, 
      String? endDate,}){
    _id = id;
    _companyId = companyId;
    _branchId = branchId;
    _couponType = couponType;
    _companyDiscount = companyDiscount;
    _comission = comission;
    _customerDiscount = customerDiscount;
    _discountDetail = discountDetail;
    _description = description;
    _arbDescription = arbDescription;
    _startDate = startDate;
    _endDate = endDate;
}

  Offerlist.fromJson(dynamic json) {
    _id = json['id'];
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _couponType = json['coupon_type'];
    _companyDiscount = json['company_discount'];
    _comission = json['comission'];
    _customerDiscount = json['customer_discount'];
    _discountDetail = json['discount_detail'];
    _description = json['description'];
    _arbDescription = json['arb_description'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
  }
  String? _id;
  String? _companyId;
  String? _branchId;
  String? _couponType;
  String? _companyDiscount;
  String? _comission;
  String? _customerDiscount;
  String? _discountDetail;
  String? _description;
  String? _arbDescription;
  String? _startDate;
  String? _endDate;
Offerlist copyWith({  String? id,
  String? companyId,
  String? branchId,
  String? couponType,
  String? companyDiscount,
  String? comission,
  String? customerDiscount,
  String? discountDetail,
  String? description,
  String? arbDescription,
  String? startDate,
  String? endDate,
}) => Offerlist(  id: id ?? _id,
  companyId: companyId ?? _companyId,
  branchId: branchId ?? _branchId,
  couponType: couponType ?? _couponType,
  companyDiscount: companyDiscount ?? _companyDiscount,
  comission: comission ?? _comission,
  customerDiscount: customerDiscount ?? _customerDiscount,
  discountDetail: discountDetail ?? _discountDetail,
  description: description ?? _description,
  arbDescription: arbDescription ?? _arbDescription,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
);
  String? get id => _id;
  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get couponType => _couponType;
  String? get companyDiscount => _companyDiscount;
  String? get comission => _comission;
  String? get customerDiscount => _customerDiscount;
  String? get discountDetail => _discountDetail;
  String? get description => _description;
  String? get arbDescription => _arbDescription;
  String? get startDate => _startDate;
  String? get endDate => _endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['coupon_type'] = _couponType;
    map['company_discount'] = _companyDiscount;
    map['comission'] = _comission;
    map['customer_discount'] = _customerDiscount;
    map['discount_detail'] = _discountDetail;
    map['description'] = _description;
    map['arb_description'] = _arbDescription;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    return map;
  }

}

/// success : "offer listed successfully"

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