/// status : 201
/// error : null
/// messages : {"success":"Offer listed successfully"}
/// image_base_url : "http://185.188.127.11/public/company/"
/// companylist : [{"id":"109","company_name":"CARACARA","company_arb_name":"CARACARA","username":"CARACARA","arb_username":"CARACARA","auth_contact":"92407956","password":"$2y$10$HSJDzAJFp8RzMwfmdUaufOG1lz4jpms90YYzNLf9.fbAtER79BkoS","display_name":"CARACARA","display_arb_name":"CARACARA","mobile":"92407956","email":"caracara.om@hotmail.com","c_location":"oman","arb_location":"","picture":"1644154861_d8a91c10972094fe1fb5.jpg","views":"","website":"https://caracara.shop/","instagram":"https://www.instagram.com/caracara.om/?igshid=5if57bm8fwhw","twitter":"","facebook":"","snapchat":"","whatsapp":"","mobile_otp":"","category":"6","cr_number":"1386725","address":"","arb_address":"","status":"1","view_count":"2827","online_shop":"1","online_description":"Enjoy collections of beautifully scented perfumes with a discount of 10% on all products.\r\n\r\n All you got to do is choose a product from the products and prices category and visit the website provided and type the code ( Citycode ) at the payment stage to benifit from the code.","online_arb_description":"استمتع بالتخفيضات الخاصه والحصرية المقدمه لك من عطورات كارا كارا بنسبة \r\n خصم 10٪ على جميع المنتجات في المتجر الالكتروني \r\n\r\n كل ما عليك هو زيارة موقعهم الالكتروني وكتابة كود الخصم ( Citycode ) قبل عملية الدفع للاستفادة من الخصم ","online_startdate":"13-08-2021","online_enddate":"31-05-2022","online_link":"http://caracara.shop/","online_playstore_link":"http://caracara.shop/","online_ios_link":"http://caracara.shop/","online_huawei_link":"http://caracara.shop/","created_date":"2021-08-16 19:31:47","updated_date":"2022-02-06 19:11:01","vip_link":"","cookiesotp":"","remainingday":"34","remaininghours":"22","remainingminutes":"59"}]
/// totalRecord : "1"
/// perpageRecord : 18
/// add_image_base_url : "http://185.188.127.11/public/advertisement/"
/// dashAdvertise : {"add_id":"3","add_name":"Max2","add_image":"A1451E17-74E1-4F6B-8F39-6D53E3B3E4AA.jpeg","url":"https://instagram.com/cityadver?igshid=YmMyMTA2M2Y=","status":"1","created_date":"2022-04-08 09:18:42","updated_date":"2022-04-08 09:18:42"}

class OnlineShopModel {
  OnlineShopModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? imageBaseUrl, 
      List<Companylist>? companylist, 
      String? totalRecord, 
      int? perpageRecord, 
      String? addImageBaseUrl, 
      DashAdvertise? dashAdvertise,}){
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _companylist = companylist;
    _totalRecord = totalRecord;
    _perpageRecord = perpageRecord;
    _addImageBaseUrl = addImageBaseUrl;
    _dashAdvertise = dashAdvertise;
}

  OnlineShopModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    if (json['companylist'] != null) {
      _companylist = [];
      json['companylist'].forEach((v) {
        _companylist?.add(Companylist.fromJson(v));
      });
    }
    _totalRecord = json['totalRecord'];
    _perpageRecord = json['perpageRecord'];
    _addImageBaseUrl = json['add_image_base_url'];
    _dashAdvertise = json['dashAdvertise'] != null ? DashAdvertise.fromJson(json['dashAdvertise']) : null;
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  List<Companylist>? _companylist;
  String? _totalRecord;
  int? _perpageRecord;
  String? _addImageBaseUrl;
  DashAdvertise? _dashAdvertise;
OnlineShopModel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  String? imageBaseUrl,
  List<Companylist>? companylist,
  String? totalRecord,
  int? perpageRecord,
  String? addImageBaseUrl,
  DashAdvertise? dashAdvertise,
}) => OnlineShopModel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  imageBaseUrl: imageBaseUrl ?? _imageBaseUrl,
  companylist: companylist ?? _companylist,
  totalRecord: totalRecord ?? _totalRecord,
  perpageRecord: perpageRecord ?? _perpageRecord,
  addImageBaseUrl: addImageBaseUrl ?? _addImageBaseUrl,
  dashAdvertise: dashAdvertise ?? _dashAdvertise,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  List<Companylist>? get companylist => _companylist;
  String? get totalRecord => _totalRecord;
  int? get perpageRecord => _perpageRecord;
  String? get addImageBaseUrl => _addImageBaseUrl;
  DashAdvertise? get dashAdvertise => _dashAdvertise;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    if (_companylist != null) {
      map['companylist'] = _companylist?.map((v) => v.toJson()).toList();
    }
    map['totalRecord'] = _totalRecord;
    map['perpageRecord'] = _perpageRecord;
    map['add_image_base_url'] = _addImageBaseUrl;
    if (_dashAdvertise != null) {
      map['dashAdvertise'] = _dashAdvertise?.toJson();
    }
    return map;
  }

}

/// add_id : "3"
/// add_name : "Max2"
/// add_image : "A1451E17-74E1-4F6B-8F39-6D53E3B3E4AA.jpeg"
/// url : "https://instagram.com/cityadver?igshid=YmMyMTA2M2Y="
/// status : "1"
/// created_date : "2022-04-08 09:18:42"
/// updated_date : "2022-04-08 09:18:42"

class DashAdvertise {
  DashAdvertise({
      String? addId, 
      String? addName, 
      String? addImage, 
      String? url, 
      String? status, 
      String? createdDate, 
      String? updatedDate,}){
    _addId = addId;
    _addName = addName;
    _addImage = addImage;
    _url = url;
    _status = status;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
}

  DashAdvertise.fromJson(dynamic json) {
    _addId = json['add_id'];
    _addName = json['add_name'];
    _addImage = json['add_image'];
    _url = json['url'];
    _status = json['status'];
    _createdDate = json['created_date'];
    _updatedDate = json['updated_date'];
  }
  String? _addId;
  String? _addName;
  String? _addImage;
  String? _url;
  String? _status;
  String? _createdDate;
  String? _updatedDate;
DashAdvertise copyWith({  String? addId,
  String? addName,
  String? addImage,
  String? url,
  String? status,
  String? createdDate,
  String? updatedDate,
}) => DashAdvertise(  addId: addId ?? _addId,
  addName: addName ?? _addName,
  addImage: addImage ?? _addImage,
  url: url ?? _url,
  status: status ?? _status,
  createdDate: createdDate ?? _createdDate,
  updatedDate: updatedDate ?? _updatedDate,
);
  String? get addId => _addId;
  String? get addName => _addName;
  String? get addImage => _addImage;
  String? get url => _url;
  String? get status => _status;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['add_id'] = _addId;
    map['add_name'] = _addName;
    map['add_image'] = _addImage;
    map['url'] = _url;
    map['status'] = _status;
    map['created_date'] = _createdDate;
    map['updated_date'] = _updatedDate;
    return map;
  }

}

/// id : "109"
/// company_name : "CARACARA"
/// company_arb_name : "CARACARA"
/// username : "CARACARA"
/// arb_username : "CARACARA"
/// auth_contact : "92407956"
/// password : "$2y$10$HSJDzAJFp8RzMwfmdUaufOG1lz4jpms90YYzNLf9.fbAtER79BkoS"
/// display_name : "CARACARA"
/// display_arb_name : "CARACARA"
/// mobile : "92407956"
/// email : "caracara.om@hotmail.com"
/// c_location : "oman"
/// arb_location : ""
/// picture : "1644154861_d8a91c10972094fe1fb5.jpg"
/// views : ""
/// website : "https://caracara.shop/"
/// instagram : "https://www.instagram.com/caracara.om/?igshid=5if57bm8fwhw"
/// twitter : ""
/// facebook : ""
/// snapchat : ""
/// whatsapp : ""
/// mobile_otp : ""
/// category : "6"
/// cr_number : "1386725"
/// address : ""
/// arb_address : ""
/// status : "1"
/// view_count : "2827"
/// online_shop : "1"
/// online_description : "Enjoy collections of beautifully scented perfumes with a discount of 10% on all products.\r\n\r\n All you got to do is choose a product from the products and prices category and visit the website provided and type the code ( Citycode ) at the payment stage to benifit from the code."
/// online_arb_description : "استمتع بالتخفيضات الخاصه والحصرية المقدمه لك من عطورات كارا كارا بنسبة \r\n خصم 10٪ على جميع المنتجات في المتجر الالكتروني \r\n\r\n كل ما عليك هو زيارة موقعهم الالكتروني وكتابة كود الخصم ( Citycode ) قبل عملية الدفع للاستفادة من الخصم "
/// online_startdate : "13-08-2021"
/// online_enddate : "31-05-2022"
/// online_link : "http://caracara.shop/"
/// online_playstore_link : "http://caracara.shop/"
/// online_ios_link : "http://caracara.shop/"
/// online_huawei_link : "http://caracara.shop/"
/// created_date : "2021-08-16 19:31:47"
/// updated_date : "2022-02-06 19:11:01"
/// vip_link : ""
/// cookiesotp : ""
/// remainingday : "34"
/// remaininghours : "22"
/// remainingminutes : "59"

class Companylist {
  Companylist({
      String? id, 
      String? companyName, 
      String? companyArbName, 
      String? username, 
      String? arbUsername, 
      String? authContact, 
      String? password, 
      String? displayName, 
      String? displayArbName, 
      String? mobile, 
      String? email, 
      String? cLocation, 
      String? arbLocation, 
      String? picture, 
      String? views, 
      String? website, 
      String? instagram, 
      String? twitter, 
      String? facebook, 
      String? snapchat, 
      String? whatsapp, 
      String? mobileOtp, 
      String? category, 
      String? crNumber, 
      String? address, 
      String? arbAddress, 
      String? status, 
      String? viewCount, 
      String? onlineShop, 
      String? onlineDescription, 
      String? onlineArbDescription, 
      String? onlineStartdate, 
      String? onlineEnddate, 
      String? onlineLink, 
      String? onlinePlaystoreLink, 
      String? onlineIosLink, 
      String? onlineHuaweiLink, 
      String? createdDate, 
      String? updatedDate, 
      String? vipLink, 
      String? cookiesotp, 
      String? remainingday, 
      String? remaininghours, 
      String? remainingminutes,}){
    _id = id;
    _companyName = companyName;
    _companyArbName = companyArbName;
    _username = username;
    _arbUsername = arbUsername;
    _authContact = authContact;
    _password = password;
    _displayName = displayName;
    _displayArbName = displayArbName;
    _mobile = mobile;
    _email = email;
    _cLocation = cLocation;
    _arbLocation = arbLocation;
    _picture = picture;
    _views = views;
    _website = website;
    _instagram = instagram;
    _twitter = twitter;
    _facebook = facebook;
    _snapchat = snapchat;
    _whatsapp = whatsapp;
    _mobileOtp = mobileOtp;
    _category = category;
    _crNumber = crNumber;
    _address = address;
    _arbAddress = arbAddress;
    _status = status;
    _viewCount = viewCount;
    _onlineShop = onlineShop;
    _onlineDescription = onlineDescription;
    _onlineArbDescription = onlineArbDescription;
    _onlineStartdate = onlineStartdate;
    _onlineEnddate = onlineEnddate;
    _onlineLink = onlineLink;
    _onlinePlaystoreLink = onlinePlaystoreLink;
    _onlineIosLink = onlineIosLink;
    _onlineHuaweiLink = onlineHuaweiLink;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
    _vipLink = vipLink;
    _cookiesotp = cookiesotp;
    _remainingday = remainingday;
    _remaininghours = remaininghours;
    _remainingminutes = remainingminutes;
}

  Companylist.fromJson(dynamic json) {
    _id = json['id'];
    _companyName = json['company_name'];
    _companyArbName = json['company_arb_name'];
    _username = json['username'];
    _arbUsername = json['arb_username'];
    _authContact = json['auth_contact'];
    _password = json['password'];
    _displayName = json['display_name'];
    _displayArbName = json['display_arb_name'];
    _mobile = json['mobile'];
    _email = json['email'];
    _cLocation = json['c_location'];
    _arbLocation = json['arb_location'];
    _picture = json['picture'];
    _views = json['views'];
    _website = json['website'];
    _instagram = json['instagram'];
    _twitter = json['twitter'];
    _facebook = json['facebook'];
    _snapchat = json['snapchat'];
    _whatsapp = json['whatsapp'];
    _mobileOtp = json['mobile_otp'];
    _category = json['category'];
    _crNumber = json['cr_number'];
    _address = json['address'];
    _arbAddress = json['arb_address'];
    _status = json['status'];
    _viewCount = json['view_count'];
    _onlineShop = json['online_shop'];
    _onlineDescription = json['online_description'];
    _onlineArbDescription = json['online_arb_description'];
    _onlineStartdate = json['online_startdate'];
    _onlineEnddate = json['online_enddate'];
    _onlineLink = json['online_link'];
    _onlinePlaystoreLink = json['online_playstore_link'];
    _onlineIosLink = json['online_ios_link'];
    _onlineHuaweiLink = json['online_huawei_link'];
    _createdDate = json['created_date'];
    _updatedDate = json['updated_date'];
    _vipLink = json['vip_link'];
    _cookiesotp = json['cookiesotp'];
    _remainingday = json['remainingday'];
    _remaininghours = json['remaininghours'];
    _remainingminutes = json['remainingminutes'];
  }
  String? _id;
  String? _companyName;
  String? _companyArbName;
  String? _username;
  String? _arbUsername;
  String? _authContact;
  String? _password;
  String? _displayName;
  String? _displayArbName;
  String? _mobile;
  String? _email;
  String? _cLocation;
  String? _arbLocation;
  String? _picture;
  String? _views;
  String? _website;
  String? _instagram;
  String? _twitter;
  String? _facebook;
  String? _snapchat;
  String? _whatsapp;
  String? _mobileOtp;
  String? _category;
  String? _crNumber;
  String? _address;
  String? _arbAddress;
  String? _status;
  String? _viewCount;
  String? _onlineShop;
  String? _onlineDescription;
  String? _onlineArbDescription;
  String? _onlineStartdate;
  String? _onlineEnddate;
  String? _onlineLink;
  String? _onlinePlaystoreLink;
  String? _onlineIosLink;
  String? _onlineHuaweiLink;
  String? _createdDate;
  String? _updatedDate;
  String? _vipLink;
  String? _cookiesotp;
  String? _remainingday;
  String? _remaininghours;
  String? _remainingminutes;
Companylist copyWith({  String? id,
  String? companyName,
  String? companyArbName,
  String? username,
  String? arbUsername,
  String? authContact,
  String? password,
  String? displayName,
  String? displayArbName,
  String? mobile,
  String? email,
  String? cLocation,
  String? arbLocation,
  String? picture,
  String? views,
  String? website,
  String? instagram,
  String? twitter,
  String? facebook,
  String? snapchat,
  String? whatsapp,
  String? mobileOtp,
  String? category,
  String? crNumber,
  String? address,
  String? arbAddress,
  String? status,
  String? viewCount,
  String? onlineShop,
  String? onlineDescription,
  String? onlineArbDescription,
  String? onlineStartdate,
  String? onlineEnddate,
  String? onlineLink,
  String? onlinePlaystoreLink,
  String? onlineIosLink,
  String? onlineHuaweiLink,
  String? createdDate,
  String? updatedDate,
  String? vipLink,
  String? cookiesotp,
  String? remainingday,
  String? remaininghours,
  String? remainingminutes,
}) => Companylist(  id: id ?? _id,
  companyName: companyName ?? _companyName,
  companyArbName: companyArbName ?? _companyArbName,
  username: username ?? _username,
  arbUsername: arbUsername ?? _arbUsername,
  authContact: authContact ?? _authContact,
  password: password ?? _password,
  displayName: displayName ?? _displayName,
  displayArbName: displayArbName ?? _displayArbName,
  mobile: mobile ?? _mobile,
  email: email ?? _email,
  cLocation: cLocation ?? _cLocation,
  arbLocation: arbLocation ?? _arbLocation,
  picture: picture ?? _picture,
  views: views ?? _views,
  website: website ?? _website,
  instagram: instagram ?? _instagram,
  twitter: twitter ?? _twitter,
  facebook: facebook ?? _facebook,
  snapchat: snapchat ?? _snapchat,
  whatsapp: whatsapp ?? _whatsapp,
  mobileOtp: mobileOtp ?? _mobileOtp,
  category: category ?? _category,
  crNumber: crNumber ?? _crNumber,
  address: address ?? _address,
  arbAddress: arbAddress ?? _arbAddress,
  status: status ?? _status,
  viewCount: viewCount ?? _viewCount,
  onlineShop: onlineShop ?? _onlineShop,
  onlineDescription: onlineDescription ?? _onlineDescription,
  onlineArbDescription: onlineArbDescription ?? _onlineArbDescription,
  onlineStartdate: onlineStartdate ?? _onlineStartdate,
  onlineEnddate: onlineEnddate ?? _onlineEnddate,
  onlineLink: onlineLink ?? _onlineLink,
  onlinePlaystoreLink: onlinePlaystoreLink ?? _onlinePlaystoreLink,
  onlineIosLink: onlineIosLink ?? _onlineIosLink,
  onlineHuaweiLink: onlineHuaweiLink ?? _onlineHuaweiLink,
  createdDate: createdDate ?? _createdDate,
  updatedDate: updatedDate ?? _updatedDate,
  vipLink: vipLink ?? _vipLink,
  cookiesotp: cookiesotp ?? _cookiesotp,
  remainingday: remainingday ?? _remainingday,
  remaininghours: remaininghours ?? _remaininghours,
  remainingminutes: remainingminutes ?? _remainingminutes,
);
  String? get id => _id;
  String? get companyName => _companyName;
  String? get companyArbName => _companyArbName;
  String? get username => _username;
  String? get arbUsername => _arbUsername;
  String? get authContact => _authContact;
  String? get password => _password;
  String? get displayName => _displayName;
  String? get displayArbName => _displayArbName;
  String? get mobile => _mobile;
  String? get email => _email;
  String? get cLocation => _cLocation;
  String? get arbLocation => _arbLocation;
  String? get picture => _picture;
  String? get views => _views;
  String? get website => _website;
  String? get instagram => _instagram;
  String? get twitter => _twitter;
  String? get facebook => _facebook;
  String? get snapchat => _snapchat;
  String? get whatsapp => _whatsapp;
  String? get mobileOtp => _mobileOtp;
  String? get category => _category;
  String? get crNumber => _crNumber;
  String? get address => _address;
  String? get arbAddress => _arbAddress;
  String? get status => _status;
  String? get viewCount => _viewCount;
  String? get onlineShop => _onlineShop;
  String? get onlineDescription => _onlineDescription;
  String? get onlineArbDescription => _onlineArbDescription;
  String? get onlineStartdate => _onlineStartdate;
  String? get onlineEnddate => _onlineEnddate;
  String? get onlineLink => _onlineLink;
  String? get onlinePlaystoreLink => _onlinePlaystoreLink;
  String? get onlineIosLink => _onlineIosLink;
  String? get onlineHuaweiLink => _onlineHuaweiLink;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;
  String? get vipLink => _vipLink;
  String? get cookiesotp => _cookiesotp;
  String? get remainingday => _remainingday;
  String? get remaininghours => _remaininghours;
  String? get remainingminutes => _remainingminutes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['company_name'] = _companyName;
    map['company_arb_name'] = _companyArbName;
    map['username'] = _username;
    map['arb_username'] = _arbUsername;
    map['auth_contact'] = _authContact;
    map['password'] = _password;
    map['display_name'] = _displayName;
    map['display_arb_name'] = _displayArbName;
    map['mobile'] = _mobile;
    map['email'] = _email;
    map['c_location'] = _cLocation;
    map['arb_location'] = _arbLocation;
    map['picture'] = _picture;
    map['views'] = _views;
    map['website'] = _website;
    map['instagram'] = _instagram;
    map['twitter'] = _twitter;
    map['facebook'] = _facebook;
    map['snapchat'] = _snapchat;
    map['whatsapp'] = _whatsapp;
    map['mobile_otp'] = _mobileOtp;
    map['category'] = _category;
    map['cr_number'] = _crNumber;
    map['address'] = _address;
    map['arb_address'] = _arbAddress;
    map['status'] = _status;
    map['view_count'] = _viewCount;
    map['online_shop'] = _onlineShop;
    map['online_description'] = _onlineDescription;
    map['online_arb_description'] = _onlineArbDescription;
    map['online_startdate'] = _onlineStartdate;
    map['online_enddate'] = _onlineEnddate;
    map['online_link'] = _onlineLink;
    map['online_playstore_link'] = _onlinePlaystoreLink;
    map['online_ios_link'] = _onlineIosLink;
    map['online_huawei_link'] = _onlineHuaweiLink;
    map['created_date'] = _createdDate;
    map['updated_date'] = _updatedDate;
    map['vip_link'] = _vipLink;
    map['cookiesotp'] = _cookiesotp;
    map['remainingday'] = _remainingday;
    map['remaininghours'] = _remaininghours;
    map['remainingminutes'] = _remainingminutes;
    return map;
  }

}

/// success : "Offer listed successfully"

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