/// status : 201
/// error : null
/// messages : {"success":"successfully"}
/// cart_summary : {"qty":"16","product_cost_mobile":"1664.600","product_discount_mobile":"1104.600","delivery_charge":"0.000","totalPrice":"2769.200","point":"11046.0"}

class Cartsummerymodel {
  Cartsummerymodel({
    int? status,
    dynamic error,
    Messages? messages,
    CartSummary? cartSummary,
  }) {
    _status = status;
    _error = error;
    _messages = messages;
    _cartSummary = cartSummary;
  }

  Cartsummerymodel.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    _cartSummary = json['cart_summary'] != null
        ? CartSummary.fromJson(json['cart_summary'])
        : null;
  }
  int? _status;
  dynamic _error;
  Messages? _messages;
  CartSummary? _cartSummary;
  Cartsummerymodel copyWith({
    int? status,
    dynamic error,
    Messages? messages,
    CartSummary? cartSummary,
  }) =>
      Cartsummerymodel(
        status: status ?? _status,
        error: error ?? _error,
        messages: messages ?? _messages,
        cartSummary: cartSummary ?? _cartSummary,
      );
  int? get status => _status;
  dynamic get error => _error;
  Messages? get messages => _messages;
  CartSummary? get cartSummary => _cartSummary;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_messages != null) {
      map['messages'] = _messages?.toJson();
    }
    if (_cartSummary != null) {
      map['cart_summary'] = _cartSummary?.toJson();
    }
    return map;
  }
}

/// qty : "16"
/// product_cost_mobile : "1664.600"
/// product_discount_mobile : "1104.600"
/// delivery_charge : "0.000"
/// totalPrice : "2769.200"
/// point : "11046.0"

class CartSummary {
  CartSummary(
      {String? qty,
      String? productCostMobile,
      String? productDiscountMobile,
      String? deliveryCharge,
      String? totalPrice,
      String? point,
      String? vat}) {
    _qty = qty;
    _productCostMobile = productCostMobile;
    _productDiscountMobile = productDiscountMobile;
    _deliveryCharge = deliveryCharge;
    _totalPrice = totalPrice;
    _point = point;
    _vat = vat;
  }

  CartSummary.fromJson(dynamic json) {
    _qty = json['qty'];
    _productCostMobile = json['product_cost_mobile'];
    _productDiscountMobile = json['product_discount_mobile'];
    _deliveryCharge = json['delivery_charge'];
    _totalPrice = json['totalPrice'];
    _point = json['point'];
    _vat = json['afterdiscount_plus_delivery_charge_vat'];
  }
  String? _qty;
  String? _productCostMobile;
  String? _productDiscountMobile;
  String? _deliveryCharge;
  String? _totalPrice;
  String? _point;
  String? _vat;
  CartSummary copyWith(
          {String? qty,
          String? productCostMobile,
          String? productDiscountMobile,
          String? deliveryCharge,
          String? totalPrice,
          String? point,
          String? vat}) =>
      CartSummary(
          qty: qty ?? _qty,
          productCostMobile: productCostMobile ?? _productCostMobile,
          productDiscountMobile:
              productDiscountMobile ?? _productDiscountMobile,
          deliveryCharge: deliveryCharge ?? _deliveryCharge,
          totalPrice: totalPrice ?? _totalPrice,
          point: point ?? _point,
          vat: vat ?? _vat);
  String? get qty => _qty;
  String? get productCostMobile => _productCostMobile;
  String? get productDiscountMobile => _productDiscountMobile;
  String? get deliveryCharge => _deliveryCharge;
  String? get totalPrice => _totalPrice;
  String? get point => _point;
  String? get vat => _vat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['qty'] = _qty;
    map['product_cost_mobile'] = _productCostMobile;
    map['product_discount_mobile'] = _productDiscountMobile;
    map['delivery_charge'] = _deliveryCharge;
    map['totalPrice'] = _totalPrice;
    map['point'] = _point;
    map['afterdiscount_plus_delivery_charge_vat'] = _vat;
    return map;
  }
}

/// success : "successfully"

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
