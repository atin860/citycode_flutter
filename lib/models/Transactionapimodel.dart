// To parse this JSON data, do
//
//     final transactionapimodel = transactionapimodelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

Transactionapimodel transactionapimodelFromJson(String str) =>
    Transactionapimodel.fromJson(json.decode(str));

String transactionapimodelToJson(Transactionapimodel data) =>
    json.encode(data.toJson());

class Transactionapimodel {
  int status;
  dynamic error;
  Messages messages;
  ListData listData;

  Transactionapimodel({
    required this.status,
    this.error,
    required this.messages,
    required this.listData,
  });

  factory Transactionapimodel.fromJson(Map<String, dynamic> json) =>
      Transactionapimodel(
        status: json["status"],
        error: json["error"],
        messages: Messages.fromJson(json["messages"]),
        listData: ListData.fromJson(json["list_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "messages": messages.toJson(),
        "list_data": listData.toJson(),
      };
}

class ListData {
  String actualPrice;
  String quantity;
  String productId;
  String companyId;
  String branchId;
  String discount;
  String discountOfferCitycode;
  String afterDiscount;
  String supliervatCharges;
  String appServiceCharge;
  String cityCodeVatCharge;
  // String deliveryChargeFast;
  String productCostMobile;
  String productDiscountMobile;
  String afterdiscountPlusDeliveryCharge;
  String afterdiscountPlusDeliveryChargeVat;
  String total;
  String customerPoint;
  String point;

  ListData({
    required this.actualPrice,
    required this.quantity,
    required this.productId,
    required this.companyId,
    required this.branchId,
    required this.discount,
    required this.discountOfferCitycode,
    required this.afterDiscount,
    required this.supliervatCharges,
    required this.appServiceCharge,
    required this.cityCodeVatCharge,
    // required this.deliveryChargeFast,
    required this.productCostMobile,
    required this.productDiscountMobile,
    required this.afterdiscountPlusDeliveryCharge,
    required this.afterdiscountPlusDeliveryChargeVat,
    required this.total,
    required this.customerPoint,
    required this.point,
  });

  factory ListData.fromJson(Map<String, dynamic> json) => ListData(
        actualPrice: json["actual_price"],
        quantity: json["quantity"],
        productId: json["product_id"],
        companyId: json["company_id"],
        branchId: json["branch_id"],
        discount: json["discount"],
        discountOfferCitycode: json["discount_offer_citycode"],
        afterDiscount: json["after_discount"],
        supliervatCharges: json["supliervat_charges"],
        appServiceCharge: json["appService_charge"],
        cityCodeVatCharge: json["cityCodeVat_Charge"],
        // deliveryChargeFast: json["delivery_charge_fast"],
        productCostMobile: json["product_cost_mobile"],
        productDiscountMobile: json["product_discount_mobile"],
        afterdiscountPlusDeliveryCharge:
            json["afterdiscount_plus_delivery_charge"],
        afterdiscountPlusDeliveryChargeVat:
            json["afterdiscount_plus_delivery_charge_vat"],
        total: json["Total"],
        customerPoint: json["customer_point"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() => {
        "actual_price": actualPrice,
        "quantity": quantity,
        "product_id": productId,
        "company_id": companyId,
        "branch_id": branchId,
        "discount": discount,
        "discount_offer_citycode": discountOfferCitycode,
        "after_discount": afterDiscount,
        "supliervat_charges": supliervatCharges,
        "appService_charge": appServiceCharge,
        "cityCodeVat_Charge": cityCodeVatCharge,
        // "delivery_charge_fast": deliveryChargeFast,
        "product_cost_mobile": productCostMobile,
        "product_discount_mobile": productDiscountMobile,
        "afterdiscount_plus_delivery_charge": afterdiscountPlusDeliveryCharge,
        "afterdiscount_plus_delivery_charge_vat":
            afterdiscountPlusDeliveryChargeVat,
        "Total": total,
        "customer_point": customerPoint,
        "point": point,
      };
}

class Messages {
  String success;

  Messages({
    required this.success,
  });

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}
