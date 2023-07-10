class CompanyListModel {
  CompanyListModel({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageUrl,
    List<Userlist>? userlist,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _imageUrl = imageUrl;
    _userlist = userlist;
  }

  CompanyListModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _imageUrl = json['image_url'];
    if (json['Userlist'] != null) {
      _userlist = [];
      json['Userlist'].forEach((v) {
        _userlist?.add(Userlist.fromJson(v));
      });
    }
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  String? _imageUrl;
  List<Userlist>? _userlist;
  CompanyListModel copyWith({
    int? status,
    dynamic error,
    Messages? messages,
    String? imageUrl,
    List<Userlist>? userlist,
  }) =>
      CompanyListModel(
        status: status ?? _status,
        error: error ?? _error,
        messages: messages ?? _messages,
        imageUrl: imageUrl ?? _imageUrl,
        userlist: userlist ?? _userlist,
      );
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  String? get imageUrl => _imageUrl;
  List<Userlist>? get userlist => _userlist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    map['image_url'] = _imageUrl;
    if (_userlist != null) {
      map['Userlist'] = _userlist?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Userlist {
  Userlist({
    String? id,
    String? companyName,
    String? companyArbName,
    String? picture,
    String? branchId,
    String? branchName,
    String? arbBranchName,
    String? lastupdatetime,
  }) {
    _id = id;
    _companyName = companyName;
    _companyArbName = companyArbName;
    _picture = picture;
    _branchId = branchId;
    _branchName = branchName;
    _arbBranchName = arbBranchName;
    _lastupdatetime = lastupdatetime;
  }

  Userlist.fromJson(dynamic json) {
    _id = json['id'];
    _companyName = json['company_name'];
    _companyArbName = json['company_arb_name'];
    _picture = json['picture'];
    _branchId = json['branch_id'];
    _branchName = json['branch_name'];
    _arbBranchName = json['arb_branch_name'];
    _lastupdatetime = json['lastupdatetime'];
  }
  String? _id;
  String? _companyName;
  String? _companyArbName;
  String? _picture;
  String? _branchId;
  String? _branchName;
  String? _arbBranchName;
  String? _lastupdatetime;
  Userlist copyWith({
    String? id,
    String? companyName,
    String? companyArbName,
    String? picture,
    String? branchId,
    String? branchName,
    String? arbBranchName,
    String? lastupdatetime,
  }) =>
      Userlist(
        id: id ?? _id,
        companyName: companyName ?? _companyName,
        companyArbName: companyArbName ?? _companyArbName,
        picture: picture ?? _picture,
        branchId: branchId ?? _branchId,
        branchName: branchName ?? _branchName,
        arbBranchName: arbBranchName ?? _arbBranchName,
        lastupdatetime: lastupdatetime ?? _lastupdatetime,
      );
  String? get id => _id;
  String? get companyName => _companyName;
  String? get companyArbName => _companyArbName;
  String? get picture => _picture;
  String? get branchId => _branchId;
  String? get branchName => _branchName;
  String? get arbBranchName => _arbBranchName;
  String? get lastupdatetime => _lastupdatetime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['company_name'] = _companyName;
    map['company_arb_name'] = _companyArbName;
    map['picture'] = _picture;
    map['branch_id'] = _branchId;
    map['branch_name'] = _branchName;
    map['arb_branch_name'] = _arbBranchName;
    map['lastupdatetime'] = _lastupdatetime;
    return map;
  }
}

/// success : "User listed successfully"

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
