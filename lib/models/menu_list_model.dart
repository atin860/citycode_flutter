/// status : 201
/// error : null
/// messages : {"success":"Menu items listed successfully"}
/// image_base_url : "http://185.188.127.11/public/menulist/"
/// company_base_url : "http://185.188.127.11/public/company/"
/// menulist : [{"company_id":"167","branch_id":"102","id":"9","company_name":"Mamitoo Baby","company_arb_name":"Mamitoo Baby","company_picture":"mamitii logo.jpg","menu_image":"1deb9452-5c11-4048-bd45-6850721d1dc9.jpg","branch_name":"South AlHail","arb_branch_name":"الحيل الجنوبية","start_date":"2021-12-20 00:00:00","end_date":"2022-01-22 00:00:00"},{"company_id":"167","branch_id":"102","id":"8","company_name":"Mamitoo Baby","company_arb_name":"Mamitoo Baby","company_picture":"mamitii logo.jpg","menu_image":"9bec31f5-fb56-4bf5-bf71-c56da4a631e8.jpg","branch_name":"South AlHail","arb_branch_name":"الحيل الجنوبية","start_date":"2021-12-20 00:00:00","end_date":"0000-00-00 00:00:00"}]

class MenuListModel {
  MenuListModel({
      int? status, 
      dynamic error, 
      Messages? messages, 
      String? imageBaseUrl, 
      String? companyBaseUrl, 
      List<Menulist>? menulist,}){
    _status = status;
    _error = error;
    _messages = messages;
    _imageBaseUrl = imageBaseUrl;
    _companyBaseUrl = companyBaseUrl;
    _menulist = menulist;
}

  MenuListModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageBaseUrl = json['image_base_url'];
    _companyBaseUrl = json['company_base_url'];
    if (json['menulist'] != null) {
      _menulist = [];
      json['menulist'].forEach((v) {
        _menulist?.add(Menulist.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageBaseUrl;
  String? _companyBaseUrl;
  List<Menulist>? _menulist;

  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageBaseUrl => _imageBaseUrl;
  String? get companyBaseUrl => _companyBaseUrl;
  List<Menulist>? get menulist => _menulist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_base_url'] = _imageBaseUrl;
    map['company_base_url'] = _companyBaseUrl;
    if (_menulist != null) {
      map['menulist'] = _menulist?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// company_id : "167"
/// branch_id : "102"
/// id : "9"
/// company_name : "Mamitoo Baby"
/// company_arb_name : "Mamitoo Baby"
/// company_picture : "mamitii logo.jpg"
/// menu_image : "1deb9452-5c11-4048-bd45-6850721d1dc9.jpg"
/// branch_name : "South AlHail"
/// arb_branch_name : "الحيل الجنوبية"
/// start_date : "2021-12-20 00:00:00"
/// end_date : "2022-01-22 00:00:00"

class Menulist {
  Menulist({
      String? companyId, 
      String? branchId, 
      String? id, 
      String? companyName, 
      String? companyArbName, 
      String? companyPicture, 
      String? menuImage, 
      String? branchName, 
      String? arbBranchName, 
      String? startDate, 
      String? endDate,}){
    _companyId = companyId;
    _branchId = branchId;
    _id = id;
    _companyName = companyName;
    _companyArbName = companyArbName;
    _companyPicture = companyPicture;
    _menuImage = menuImage;
    _branchName = branchName;
    _arbBranchName = arbBranchName;
    _startDate = startDate;
    _endDate = endDate;
}

  Menulist.fromJson(dynamic json) {
    _companyId = json['company_id'];
    _branchId = json['branch_id'];
    _id = json['id'];
    _companyName = json['company_name'];
    _companyArbName = json['company_arb_name'];
    _companyPicture = json['company_picture'];
    _menuImage = json['menu_image'];
    _branchName = json['branch_name'];
    _arbBranchName = json['arb_branch_name'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
  }
  String? _companyId;
  String? _branchId;
  String? _id;
  String? _companyName;
  String? _companyArbName;
  String? _companyPicture;
  String? _menuImage;
  String? _branchName;
  String? _arbBranchName;
  String? _startDate;
  String? _endDate;

  String? get companyId => _companyId;
  String? get branchId => _branchId;
  String? get id => _id;
  String? get companyName => _companyName;
  String? get companyArbName => _companyArbName;
  String? get companyPicture => _companyPicture;
  String? get menuImage => _menuImage;
  String? get branchName => _branchName;
  String? get arbBranchName => _arbBranchName;
  String? get startDate => _startDate;
  String? get endDate => _endDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['company_id'] = _companyId;
    map['branch_id'] = _branchId;
    map['id'] = _id;
    map['company_name'] = _companyName;
    map['company_arb_name'] = _companyArbName;
    map['company_picture'] = _companyPicture;
    map['menu_image'] = _menuImage;
    map['branch_name'] = _branchName;
    map['arb_branch_name'] = _arbBranchName;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    return map;
  }

}

/// success : "Menu items listed successfully"

class Messages {
  Messages({
      String? success,}){
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