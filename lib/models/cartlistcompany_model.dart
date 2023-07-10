/// status : 201
/// error : null
/// messages : {"success":"successfully"}
/// company_image_base_url : "http://cp.citycode.om/public/company/"
/// company_cart_list : [{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch","arb_branch_name":"فرع الخوض","branch_id":"14"},{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch","arb_branch_name":"فرع الخوض","branch_id":"14"},{"company_id":"240","company_name":"4 Doner restaurant ","company_arb_name":"مطعم فور دونر","company_image":"d7b795a6-7cb6-4bdc-ba3c-8c2d30f6ad3a.jpg","branch_name":"Al Maabilah","arb_branch_name":"معبيلة","branch_id":"243"},{"company_id":"240","company_name":"4 Doner restaurant ","company_arb_name":"مطعم فور دونر","company_image":"d7b795a6-7cb6-4bdc-ba3c-8c2d30f6ad3a.jpg","branch_name":"Al Maabilah","arb_branch_name":"معبيلة","branch_id":"243"},{"company_id":"239","company_name":"kusoglu kunef","company_arb_name":"قوش أوغلو كنافة","company_image":"ecef9c22-cae5-4895-a8e1-6b0628dbd285.jpg","branch_name":"Sohar","arb_branch_name":"صحار","branch_id":"239"},{"company_id":"236","company_name":"Ceramique ","company_arb_name":"Ceramique ","company_image":"1661087503_f7dd52bc8d2858604499.jpg","branch_name":"Al Araimi Boulevard","arb_branch_name":"العريمي بوليفارد","branch_id":"238"},{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch","arb_branch_name":"فرع الخوض","branch_id":"14"},{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch","arb_branch_name":"فرع الخوض","branch_id":"14"},{"company_id":"236","company_name":"Ceramique ","company_arb_name":"Ceramique ","company_image":"1661087503_f7dd52bc8d2858604499.jpg","branch_name":"Al Araimi Boulevard","arb_branch_name":"العريمي بوليفارد","branch_id":"238"},{"company_id":"236","company_name":"Ceramique ","company_arb_name":"Ceramique ","company_image":"1661087503_f7dd52bc8d2858604499.jpg","branch_name":"Al Araimi Boulevard","arb_branch_name":"العريمي بوليفارد","branch_id":"238"},{"company_id":"236","company_name":"Ceramique ","company_arb_name":"Ceramique ","company_image":"1661087503_f7dd52bc8d2858604499.jpg","branch_name":"Al Araimi Boulevard","arb_branch_name":"العريمي بوليفارد","branch_id":"238"},{"company_id":"236","company_name":"Ceramique ","company_arb_name":"Ceramique ","company_image":"1661087503_f7dd52bc8d2858604499.jpg","branch_name":"Al Araimi Boulevard","arb_branch_name":"العريمي بوليفارد","branch_id":"238"},{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Oman mall Branch ","arb_branch_name":"فرع عمان مول","branch_id":"67"},{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch","arb_branch_name":"فرع الخوض","branch_id":"14"},{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch","arb_branch_name":"فرع الخوض","branch_id":"14"},{"company_id":"103","company_name":"MooChuu","company_arb_name":"MooChuu","company_image":"WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg","branch_name":"Alkhoud Branch","arb_branch_name":"فرع الخوض","branch_id":"14"}]

class CartlistcompanyModel {
  CartlistcompanyModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? companyImageBaseUrl, 
      List<CompanyCartList>? companyCartList,}){
    _status = status;
    _error = error;
    _messages = messages;
    _companyImageBaseUrl = companyImageBaseUrl;
    _companyCartList = companyCartList;
}

  CartlistcompanyModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _companyImageBaseUrl = json['company_image_base_url'];
    if (json['company_cart_list'] != null) {
      _companyCartList = [];
      json['company_cart_list'].forEach((v) {
        _companyCartList?.add(CompanyCartList.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _companyImageBaseUrl;
  List<CompanyCartList>? _companyCartList;
CartlistcompanyModel copyWith({  int? status,
  dynamic error,
  Messages? messages,
  String? companyImageBaseUrl,
  List<CompanyCartList>? companyCartList,
}) => CartlistcompanyModel(  status: status ?? _status,
  error: error ?? _error,
  messages: messages ?? _messages,
  companyImageBaseUrl: companyImageBaseUrl ?? _companyImageBaseUrl,
  companyCartList: companyCartList ?? _companyCartList,
);
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get companyImageBaseUrl => _companyImageBaseUrl;
  List<CompanyCartList>? get companyCartList => _companyCartList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['company_image_base_url'] = _companyImageBaseUrl;
    if (_companyCartList != null) {
      map['company_cart_list'] = _companyCartList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// company_id : "103"
/// company_name : "MooChuu"
/// company_arb_name : "MooChuu"
/// company_image : "WhatsApp Image 2021-08-09 at 11.07.19 AM.jpeg"
/// branch_name : "Alkhoud Branch"
/// arb_branch_name : "فرع الخوض"
/// branch_id : "14"

class CompanyCartList {
  CompanyCartList({
      String? companyId, 
      String? companyName, 
      String? companyArbName, 
      String? companyImage, 
      String? branchName, 
      String? arbBranchName, 
      String? branchId,}){
    _companyId = companyId;
    _companyName = companyName;
    _companyArbName = companyArbName;
    _companyImage = companyImage;
    _branchName = branchName;
    _arbBranchName = arbBranchName;
    _branchId = branchId;
}

  CompanyCartList.fromJson(dynamic json) {
    _companyId = json['company_id'];
    _companyName = json['company_name'];
    _companyArbName = json['company_arb_name'];
    _companyImage = json['company_image'];
    _branchName = json['branch_name'];
    _arbBranchName = json['arb_branch_name'];
    _branchId = json['branch_id'];
  }
  String? _companyId;
  String? _companyName;
  String? _companyArbName;
  String? _companyImage;
  String? _branchName;
  String? _arbBranchName;
  String? _branchId;
CompanyCartList copyWith({  String? companyId,
  String? companyName,
  String? companyArbName,
  String? companyImage,
  String? branchName,
  String? arbBranchName,
  String? branchId,
}) => CompanyCartList(  companyId: companyId ?? _companyId,
  companyName: companyName ?? _companyName,
  companyArbName: companyArbName ?? _companyArbName,
  companyImage: companyImage ?? _companyImage,
  branchName: branchName ?? _branchName,
  arbBranchName: arbBranchName ?? _arbBranchName,
  branchId: branchId ?? _branchId,
);
  String? get companyId => _companyId;
  String? get companyName => _companyName;
  String? get companyArbName => _companyArbName;
  String? get companyImage => _companyImage;
  String? get branchName => _branchName;
  String? get arbBranchName => _arbBranchName;
  String? get branchId => _branchId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_id'] = _companyId;
    map['company_name'] = _companyName;
    map['company_arb_name'] = _companyArbName;
    map['company_image'] = _companyImage;
    map['branch_name'] = _branchName;
    map['arb_branch_name'] = _arbBranchName;
    map['branch_id'] = _branchId;
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