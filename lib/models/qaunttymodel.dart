class QuantityModel {
  int? status;
  dynamic error;
  Messages? messages;
  QuantityData? qtyData;

  QuantityModel({
    this.status,
    this.error,
    this.messages,
    this.qtyData,
  });

  QuantityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    error = json['error'];
    messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    qtyData = json['qty_data'] != null
        ? QuantityData.fromJson(json['qty_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['error'] = error;
    if (messages != null) {
      data['messages'] = messages!.toJson();
    }
    if (qtyData != null) {
      data['qty_data'] = qtyData!.toJson();
    }
    return data;
  }
}

class QuantityData {
  String? productCostMobile;
  String? productDiscountMobile;
  String? qty;

  QuantityData({
    this.productCostMobile,
    this.productDiscountMobile,
    this.qty,
  });

  QuantityData.fromJson(Map<String, dynamic> json) {
    productCostMobile = json['product_cost_mobile'];
    productDiscountMobile = json['product_discount_mobile'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_cost_mobile'] = productCostMobile;
    data['product_discount_mobile'] = productDiscountMobile;
    data['qty'] = qty;
    return data;
  }
}

class Messages {
  String? success;

  Messages({
    this.success,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    return data;
  }
}
