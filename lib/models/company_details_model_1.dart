// To parse this JSON data, do
//
//     final companyDetailsModel1 = companyDetailsModel1FromJson(jsonString);

import 'dart:convert';

CompanyDetailsModel1 companyDetailsModel1FromJson(String str) =>
    CompanyDetailsModel1.fromJson(json.decode(str));

String companyDetailsModel1ToJson(CompanyDetailsModel1 data) =>
    json.encode(data.toJson());

class CompanyDetailsModel1 {
  CompanyDetailsModel1({
    required this.status,
    this.error,
    required this.messages,
    required this.imageBaseUrl,
    required this.companydetails,
    required this.companyBranch,
    required this.companyBanner,
  });

  int status;
  dynamic error;
  Messages messages;
  String imageBaseUrl;
  List<Companydetail> companydetails;
  List<CompanyBranch> companyBranch;
  List<CompanyBanner> companyBanner;

  factory CompanyDetailsModel1.fromJson(Map<String, dynamic> json) =>
      CompanyDetailsModel1(
        status: json["status"],
        error: json["error"],
        messages: Messages.fromJson(json["messages"]),
        imageBaseUrl: json["image_base_url"],
        companydetails: List<Companydetail>.from(
            json["companydetails"].map((x) => Companydetail.fromJson(x))),
        companyBranch: List<CompanyBranch>.from(
            json["company_branch"].map((x) => CompanyBranch.fromJson(x))),
        companyBanner: List<CompanyBanner>.from(
            json["company_banner"].map((x) => CompanyBanner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "messages": messages.toJson(),
        "image_base_url": imageBaseUrl,
        "companydetails":
            List<dynamic>.from(companydetails.map((x) => x.toJson())),
        "company_branch":
            List<dynamic>.from(companyBranch.map((x) => x.toJson())),
        "company_banner":
            List<dynamic>.from(companyBanner.map((x) => x.toJson())),
      };
}

class CompanyBanner {
  CompanyBanner({
    required this.id,
    required this.companyId,
    required this.type,
    required this.doc,
    required this.banner,
    required this.businessId,
    required this.bStatus,
  });

  String id;
  String companyId;
  String type;
  String doc;
  String banner;
  String businessId;
  String bStatus;

  factory CompanyBanner.fromJson(Map<String, dynamic> json) => CompanyBanner(
        id: json["id"],
        companyId: json["company_id"],
        type: json["type"],
        doc: json["doc"],
        banner: json["banner"],
        businessId: json["business_id"],
        bStatus: json["b_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "type": type,
        "doc": doc,
        "banner": banner,
        "business_id": businessId,
        "b_status": bStatus,
      };
}

class CompanyBranch {
  CompanyBranch({
    required this.branchId,
    required this.companyId,
    required this.branchName,
    required this.arbBranchName,
    required this.branchUsername,
    required this.arbBranchUsername,
    required this.branchPassword,
    required this.state,
    required this.city,
    required this.location,
    required this.arbBranchLocation,
    required this.androidToken,
    required this.branchAuthoNo,
    required this.mobileOtp,
    required this.latitude,
    required this.longitude,
    this.distance,
    required this.fastDeliveryCharges,
    required this.specialDeliveryCharges,
    required this.id,
    required this.companyName,
    required this.companyArbName,
    required this.username,
    required this.arbUsername,
    required this.authContact,
    required this.password,
    required this.displayName,
    required this.displayArbName,
    required this.mobile,
    required this.email,
    required this.cLocation,
    required this.arbLocation,
    required this.picture,
    required this.views,
    required this.website,
    required this.instagram,
    required this.twitter,
    required this.facebook,
    required this.snapchat,
    required this.whatsapp,
    required this.category,
    required this.crNumber,
    required this.address,
    required this.arbAddress,
    required this.status,
    required this.viewCount,
    required this.onlineShop,
    required this.onlineDescription,
    required this.onlineArbDescription,
    required this.onlineStartdate,
    required this.onlineEnddate,
    required this.onlineLink,
    required this.onlinePlaystoreLink,
    required this.onlineIosLink,
    required this.onlineHuaweiLink,
    required this.createdDate,
    required this.updatedDate,
    required this.vipLink,
    required this.cookiesotp,
    required this.redeem,
    required this.companyChatStatus,
    required this.couponStatus,
    required this.branchOffers,
  });

  String branchId;
  String companyId;
  String branchName;
  String arbBranchName;
  String branchUsername;
  String arbBranchUsername;
  String branchPassword;
  String state;
  String city;
  String location;
  String arbBranchLocation;
  String androidToken;
  String branchAuthoNo;
  String mobileOtp;
  String latitude;
  String longitude;
  String? distance;
  String fastDeliveryCharges;
  String specialDeliveryCharges;
  String id;
  String companyName;
  String companyArbName;
  String username;
  String arbUsername;
  String authContact;
  String password;
  String displayName;
  String displayArbName;
  String mobile;
  String email;
  String cLocation;
  String arbLocation;
  String picture;
  String views;
  String website;
  String instagram;
  String twitter;
  String facebook;
  String snapchat;
  String whatsapp;
  String category;
  String crNumber;
  String address;
  String arbAddress;
  String status;
  String viewCount;
  String onlineShop;
  String onlineDescription;
  String onlineArbDescription;
  String onlineStartdate;
  String onlineEnddate;
  String onlineLink;
  String onlinePlaystoreLink;
  String onlineIosLink;
  String onlineHuaweiLink;
  DateTime createdDate;
  DateTime updatedDate;
  String vipLink;
  String cookiesotp;
  String redeem;
  String companyChatStatus;
  String couponStatus;
  List<BranchOffer> branchOffers;

  factory CompanyBranch.fromJson(Map<String, dynamic> json) => CompanyBranch(
        branchId: json["branch_id"],
        companyId: json["company_id"],
        branchName: json["branch_name"],
        arbBranchName: json["arb_branch_name"],
        branchUsername: json["branch_username"],
        arbBranchUsername: json["arb_branch_username"],
        branchPassword: json["branch_password"],
        state: json["state"],
        city: json["city"],
        location: json["location"],
        arbBranchLocation: json["arb_branch_location"],
        androidToken: json["android_token"],
        branchAuthoNo: json["branch_autho_no"],
        mobileOtp: json["mobile_otp"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"],
        fastDeliveryCharges: json["fast_delivery_charges"],
        specialDeliveryCharges: json["special_delivery_charges"],
        id: json["id"],
        companyName: json["company_name"],
        companyArbName: json["company_arb_name"],
        username: json["username"],
        arbUsername: json["arb_username"],
        authContact: json["auth_contact"],
        password: json["password"],
        displayName: json["display_name"],
        displayArbName: json["display_arb_name"],
        mobile: json["mobile"],
        email: json["email"],
        cLocation: json["c_location"],
        arbLocation: json["arb_location"],
        picture: json["picture"],
        views: json["views"],
        website: json["website"],
        instagram: json["instagram"],
        twitter: json["twitter"],
        facebook: json["facebook"],
        snapchat: json["snapchat"],
        whatsapp: json["whatsapp"],
        category: json["category"],
        crNumber: json["cr_number"],
        address: json["address"],
        arbAddress: json["arb_address"],
        status: json["status"],
        viewCount: json["view_count"],
        onlineShop: json["online_shop"],
        onlineDescription: json["online_description"],
        onlineArbDescription: json["online_arb_description"],
        onlineStartdate: json["online_startdate"],
        onlineEnddate: json["online_enddate"],
        onlineLink: json["online_link"],
        onlinePlaystoreLink: json["online_playstore_link"],
        onlineIosLink: json["online_ios_link"],
        onlineHuaweiLink: json["online_huawei_link"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        vipLink: json["vip_link"],
        cookiesotp: json["cookiesotp"],
        redeem: json["redeem"],
        companyChatStatus: json["company_chat_status"],
        couponStatus: json["coupon_status"],
        branchOffers: List<BranchOffer>.from(
            json["branch_offers"].map((x) => BranchOffer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "branch_id": branchId,
        "company_id": companyId,
        "branch_name": branchName,
        "arb_branch_name": arbBranchName,
        "branch_username": branchUsername,
        "arb_branch_username": arbBranchUsername,
        "branch_password": branchPassword,
        "state": state,
        "city": city,
        "location": location,
        "arb_branch_location": arbBranchLocation,
        "android_token": androidToken,
        "branch_autho_no": branchAuthoNo,
        "mobile_otp": mobileOtp,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
        "fast_delivery_charges": fastDeliveryCharges,
        "special_delivery_charges": specialDeliveryCharges,
        "id": id,
        "company_name": companyName,
        "company_arb_name": companyArbName,
        "username": username,
        "arb_username": arbUsername,
        "auth_contact": authContact,
        "password": password,
        "display_name": displayName,
        "display_arb_name": displayArbName,
        "mobile": mobile,
        "email": email,
        "c_location": cLocation,
        "arb_location": arbLocation,
        "picture": picture,
        "views": views,
        "website": website,
        "instagram": instagram,
        "twitter": twitter,
        "facebook": facebook,
        "snapchat": snapchat,
        "whatsapp": whatsapp,
        "category": category,
        "cr_number": crNumber,
        "address": address,
        "arb_address": arbAddress,
        "status": status,
        "view_count": viewCount,
        "online_shop": onlineShop,
        "online_description": onlineDescription,
        "online_arb_description": onlineArbDescription,
        "online_startdate": onlineStartdate,
        "online_enddate": onlineEnddate,
        "online_link": onlineLink,
        "online_playstore_link": onlinePlaystoreLink,
        "online_ios_link": onlineIosLink,
        "online_huawei_link": onlineHuaweiLink,
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "vip_link": vipLink,
        "cookiesotp": cookiesotp,
        "redeem": redeem,
        "company_chat_status": companyChatStatus,
        "coupon_status": couponStatus,
        "branch_offers":
            List<dynamic>.from(branchOffers.map((x) => x.toJson())),
      };
}

class BranchOffer {
  BranchOffer({
    required this.id,
    required this.companyId,
    required this.branchId,
    required this.couponType,
    required this.companyDiscount,
    required this.comission,
    required this.customerDiscount,
    required this.discountDetail,
    required this.description,
    required this.arbDescription,
    required this.startDate,
    required this.endDate,
    required this.timing,
    required this.onlineLink,
    required this.playstoreLink,
    required this.iosLink,
    required this.huawaiLink,
    required this.priority,
    required this.priorityStart,
    required this.priorityEnd,
    required this.hMobileNo,
    required this.hWhatsappNo,
    required this.hInstagram,
    required this.hEmail,
    required this.hLocation,
    required this.hArabLocation,
    required this.hImage,
    required this.mall,
    required this.mallName,
    required this.mallNameArabic,
    required this.custmise,
    required this.offerNameCust,
    required this.offerNameCustArabic,
    required this.discountdisplay,
    required this.companyName,
    required this.companyArbName,
    required this.displayName,
    required this.displayArbName,
    required this.companylogo,
    required this.couponStatus,
    required this.viewCount,
    required this.category,
    required this.discountEnDetail,
    required this.discountArbDetail,
    required this.isfavorate,
    required this.remainingday,
    required this.remaininghours,
    required this.remainingminutes,
  });

  String id;
  String companyId;
  String branchId;
  String couponType;
  String companyDiscount;
  String comission;
  String customerDiscount;
  String discountDetail;
  String description;
  String arbDescription;
  String startDate;
  String endDate;
  String timing;
  String onlineLink;
  String playstoreLink;
  String iosLink;
  String huawaiLink;
  String priority;
  String priorityStart;
  String priorityEnd;
  String hMobileNo;
  String hWhatsappNo;
  String hInstagram;
  String hEmail;
  String hLocation;
  String hArabLocation;
  String hImage;
  String mall;
  String mallName;
  String mallNameArabic;
  String custmise;
  String offerNameCust;
  String offerNameCustArabic;
  String discountdisplay;
  String companyName;
  String companyArbName;
  String displayName;
  String displayArbName;
  String companylogo;
  String couponStatus;
  String viewCount;
  String category;
  String discountEnDetail;
  String discountArbDetail;
  String isfavorate;
  String remainingday;
  String remaininghours;
  String remainingminutes;

  factory BranchOffer.fromJson(Map<String, dynamic> json) => BranchOffer(
        id: json["id"],
        companyId: json["company_id"],
        branchId: json["branch_id"],
        couponType: json["coupon_type"],
        companyDiscount: json["company_discount"],
        comission: json["comission"],
        customerDiscount: json["customer_discount"],
        discountDetail: json["discount_detail"],
        description: json["description"],
        arbDescription: json["arb_description"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        timing: json["timing"],
        onlineLink: json["online_link"],
        playstoreLink: json["playstore_link"],
        iosLink: json["ios_link"],
        huawaiLink: json["huawai_link"],
        priority: json["priority"],
        priorityStart: json["priority_start"],
        priorityEnd: json["priority_end"],
        hMobileNo: json["h_mobile_no"],
        hWhatsappNo: json["h_whatsapp_no"],
        hInstagram: json["h_instagram"],
        hEmail: json["h_email"],
        hLocation: json["h_location"],
        hArabLocation: json["h_arab_location"],
        hImage: json["h_image"],
        mall: json["mall"] ?? '',
        mallName: json["mall_name"],
        mallNameArabic: json["mall_name_arabic"],
        custmise: json["custmise"],
        offerNameCust: json["offer_name_cust"],
        offerNameCustArabic: json["offer_name_cust_arabic"],
        discountdisplay: json["discountdisplay"],
        companyName: json["company_name"],
        companyArbName: json["company_arb_name"],
        displayName: json["display_name"],
        displayArbName: json["display_arb_name"],
        companylogo: json["companylogo"],
        couponStatus: json["coupon_status"],
        viewCount: json["view_count"],
        category: json["category"],
        discountEnDetail: json["discount_en_detail"],
        discountArbDetail: json["discount_arb_detail"],
        isfavorate: json["isfavorate"],
        remainingday: json["remainingday"],
        remaininghours: json["remaininghours"],
        remainingminutes: json["remainingminutes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_id": companyId,
        "branch_id": branchId,
        "coupon_type": couponType,
        "company_discount": companyDiscount,
        "comission": comission,
        "customer_discount": customerDiscount,
        "discount_detail": discountDetail,
        "description": description,
        "arb_description": arbDescription,
        "start_date": startDate,
        "end_date": endDate,
        "timing": timing,
        "online_link": onlineLink,
        "playstore_link": playstoreLink,
        "ios_link": iosLink,
        "huawai_link": huawaiLink,
        "priority": priority,
        "priority_start": priorityStart,
        "priority_end": priorityEnd,
        "h_mobile_no": hMobileNo,
        "h_whatsapp_no": hWhatsappNo,
        "h_instagram": hInstagram,
        "h_email": hEmail,
        "h_location": hLocation,
        "h_arab_location": hArabLocation,
        "h_image": hImage,
        "mall": mall,
        "mall_name": mallName,
        "mall_name_arabic": mallNameArabic,
        "custmise": custmise,
        "offer_name_cust": offerNameCust,
        "offer_name_cust_arabic": offerNameCustArabic,
        "discountdisplay": discountdisplay,
        "company_name": companyName,
        "company_arb_name": companyArbName,
        "display_name": displayName,
        "display_arb_name": displayArbName,
        "companylogo": companylogo,
        "coupon_status": couponStatus,
        "view_count": viewCount,
        "category": category,
        "discount_en_detail": discountEnDetail,
        "discount_arb_detail": discountArbDetail,
        "isfavorate": isfavorate,
        "remainingday": remainingday,
        "remaininghours": remaininghours,
        "remainingminutes": remainingminutes,
      };
}

class Companydetail {
  Companydetail({
    required this.id,
    required this.companyName,
    required this.companyArbName,
    required this.username,
    required this.arbUsername,
    required this.authContact,
    required this.password,
    required this.displayName,
    required this.displayArbName,
    required this.mobile,
    required this.email,
    required this.cLocation,
    required this.arbLocation,
    required this.picture,
    required this.views,
    required this.website,
    required this.instagram,
    required this.twitter,
    required this.facebook,
    required this.snapchat,
    required this.whatsapp,
    required this.mobileOtp,
    required this.category,
    required this.crNumber,
    required this.address,
    required this.arbAddress,
    required this.status,
    required this.viewCount,
    required this.onlineShop,
    required this.onlineDescription,
    required this.onlineArbDescription,
    required this.onlineStartdate,
    required this.onlineEnddate,
    required this.onlineLink,
    required this.onlinePlaystoreLink,
    required this.onlineIosLink,
    required this.onlineHuaweiLink,
    required this.createdDate,
    required this.updatedDate,
    required this.vipLink,
    required this.cookiesotp,
    required this.redeem,
    required this.companyChatStatus,
    required this.couponStatus,
    required this.orderCount,
  });

  String id;
  String companyName;
  String companyArbName;
  String username;
  String arbUsername;
  String authContact;
  String password;
  String displayName;
  String displayArbName;
  String mobile;
  String email;
  String cLocation;
  String arbLocation;
  String picture;
  String views;
  String website;
  String instagram;
  String twitter;
  String facebook;
  String snapchat;
  String whatsapp;
  String mobileOtp;
  String category;
  String crNumber;
  String address;
  String arbAddress;
  String status;
  String viewCount;
  String onlineShop;
  String onlineDescription;
  String onlineArbDescription;
  String onlineStartdate;
  String onlineEnddate;
  String onlineLink;
  String onlinePlaystoreLink;
  String onlineIosLink;
  String onlineHuaweiLink;
  DateTime createdDate;
  DateTime updatedDate;
  String vipLink;
  String cookiesotp;
  String redeem;
  String companyChatStatus;
  String couponStatus;
  String orderCount;

  factory Companydetail.fromJson(Map<String, dynamic> json) => Companydetail(
        id: json["id"],
        companyName: json["company_name"],
        companyArbName: json["company_arb_name"],
        username: json["username"],
        arbUsername: json["arb_username"],
        authContact: json["auth_contact"],
        password: json["password"],
        displayName: json["display_name"],
        displayArbName: json["display_arb_name"],
        mobile: json["mobile"],
        email: json["email"],
        cLocation: json["c_location"],
        arbLocation: json["arb_location"],
        picture: json["picture"],
        views: json["views"],
        website: json["website"],
        instagram: json["instagram"],
        twitter: json["twitter"],
        facebook: json["facebook"],
        snapchat: json["snapchat"],
        whatsapp: json["whatsapp"],
        mobileOtp: json["mobile_otp"],
        category: json["category"],
        crNumber: json["cr_number"],
        address: json["address"],
        arbAddress: json["arb_address"],
        status: json["status"],
        viewCount: json["view_count"],
        onlineShop: json["online_shop"],
        onlineDescription: json["online_description"],
        onlineArbDescription: json["online_arb_description"],
        onlineStartdate: json["online_startdate"],
        onlineEnddate: json["online_enddate"],
        onlineLink: json["online_link"],
        onlinePlaystoreLink: json["online_playstore_link"],
        onlineIosLink: json["online_ios_link"],
        onlineHuaweiLink: json["online_huawei_link"],
        createdDate: DateTime.parse(json["created_date"]),
        updatedDate: DateTime.parse(json["updated_date"]),
        vipLink: json["vip_link"],
        cookiesotp: json["cookiesotp"],
        redeem: json["redeem"],
        companyChatStatus: json["company_chat_status"],
        couponStatus: json["coupon_status"],
        orderCount: json["order_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_arb_name": companyArbName,
        "username": username,
        "arb_username": arbUsername,
        "auth_contact": authContact,
        "password": password,
        "display_name": displayName,
        "display_arb_name": displayArbName,
        "mobile": mobile,
        "email": email,
        "c_location": cLocation,
        "arb_location": arbLocation,
        "picture": picture,
        "views": views,
        "website": website,
        "instagram": instagram,
        "twitter": twitter,
        "facebook": facebook,
        "snapchat": snapchat,
        "whatsapp": whatsapp,
        "mobile_otp": mobileOtp,
        "category": category,
        "cr_number": crNumber,
        "address": address,
        "arb_address": arbAddress,
        "status": status,
        "view_count": viewCount,
        "online_shop": onlineShop,
        "online_description": onlineDescription,
        "online_arb_description": onlineArbDescription,
        "online_startdate": onlineStartdate,
        "online_enddate": onlineEnddate,
        "online_link": onlineLink,
        "online_playstore_link": onlinePlaystoreLink,
        "online_ios_link": onlineIosLink,
        "online_huawei_link": onlineHuaweiLink,
        "created_date": createdDate.toIso8601String(),
        "updated_date": updatedDate.toIso8601String(),
        "vip_link": vipLink,
        "cookiesotp": cookiesotp,
        "redeem": redeem,
        "company_chat_status": companyChatStatus,
        "coupon_status": couponStatus,
        "order_count": orderCount,
      };
}

class Messages {
  Messages({
    required this.success,
  });

  String success;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}
