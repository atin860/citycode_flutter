/// status : 201
/// error : null
/// data : {"order_id":"1078","userid":"238","usertransactioncode":"QW3956","companyid":"112","companyname":"Tiptara","arb_companyname":"تبــتارا","branchid":"25","branchname":"Ghala Branch","arb_branchname":"فرع غلا ","discount":"15.0","totalamount":"100.00","paidamount":"85.00","usertransactionstatus":"false","redeempoint":"0"}

class UserTransactionCodeModel {
  UserTransactionCodeModel({
      int? status, 
      dynamic error, 
      Data? data,}){
    _status = status;
    _error = error;
    _data = data;
}

  UserTransactionCodeModel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  int? _status;
  dynamic _error;
  Data? _data;

  int? get status => _status;
  dynamic get error => _error;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// order_id : "1078"
/// userid : "238"
/// usertransactioncode : "QW3956"
/// companyid : "112"
/// companyname : "Tiptara"
/// arb_companyname : "تبــتارا"
/// branchid : "25"
/// branchname : "Ghala Branch"
/// arb_branchname : "فرع غلا "
/// discount : "15.0"
/// totalamount : "100.00"
/// paidamount : "85.00"
/// usertransactionstatus : "false"
/// redeempoint : "0"

class Data {
  Data({
      String? orderId, 
      String? userid, 
      String? usertransactioncode, 
      String? companyid, 
      String? companyname, 
      String? arbCompanyname, 
      String? branchid, 
      String? branchname, 
      String? arbBranchname, 
      String? discount, 
      String? totalamount, 
      String? paidamount, 
      String? usertransactionstatus, 
      String? redeempoint,}){
    _orderId = orderId;
    _userid = userid;
    _usertransactioncode = usertransactioncode;
    _companyid = companyid;
    _companyname = companyname;
    _arbCompanyname = arbCompanyname;
    _branchid = branchid;
    _branchname = branchname;
    _arbBranchname = arbBranchname;
    _discount = discount;
    _totalamount = totalamount;
    _paidamount = paidamount;
    _usertransactionstatus = usertransactionstatus;
    _redeempoint = redeempoint;
}

  Data.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _userid = json['userid'];
    _usertransactioncode = json['usertransactioncode'];
    _companyid = json['companyid'];
    _companyname = json['companyname'];
    _arbCompanyname = json['arb_companyname'];
    _branchid = json['branchid'];
    _branchname = json['branchname'];
    _arbBranchname = json['arb_branchname'];
    _discount = json['discount'];
    _totalamount = json['totalamount'];
    _paidamount = json['paidamount'];
    _usertransactionstatus = json['usertransactionstatus'];
    _redeempoint = json['redeempoint'];
  }
  String? _orderId;
  String? _userid;
  String? _usertransactioncode;
  String? _companyid;
  String? _companyname;
  String? _arbCompanyname;
  String? _branchid;
  String? _branchname;
  String? _arbBranchname;
  String? _discount;
  String? _totalamount;
  String? _paidamount;
  String? _usertransactionstatus;
  String? _redeempoint;

  String? get orderId => _orderId;
  String? get userid => _userid;
  String? get usertransactioncode => _usertransactioncode;
  String? get companyid => _companyid;
  String? get companyname => _companyname;
  String? get arbCompanyname => _arbCompanyname;
  String? get branchid => _branchid;
  String? get branchname => _branchname;
  String? get arbBranchname => _arbBranchname;
  String? get discount => _discount;
  String? get totalamount => _totalamount;
  String? get paidamount => _paidamount;
  String? get usertransactionstatus => _usertransactionstatus;
  String? get redeempoint => _redeempoint;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['userid'] = _userid;
    map['usertransactioncode'] = _usertransactioncode;
    map['companyid'] = _companyid;
    map['companyname'] = _companyname;
    map['arb_companyname'] = _arbCompanyname;
    map['branchid'] = _branchid;
    map['branchname'] = _branchname;
    map['arb_branchname'] = _arbBranchname;
    map['discount'] = _discount;
    map['totalamount'] = _totalamount;
    map['paidamount'] = _paidamount;
    map['usertransactionstatus'] = _usertransactionstatus;
    map['redeempoint'] = _redeempoint;
    return map;
  }

}