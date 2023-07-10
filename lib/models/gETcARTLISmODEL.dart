// ignore_for_file: file_names

import 'Companycoupondetail_Model.dart';

class CartListResponse {
  int status;
  dynamic error;
  Messages messages;
  String imageBaseUrl;
  String companyImageBaseUrl;
  List<CartListItem> cartList;

  CartListResponse({
    required this.status,
    required this.error,
    required this.messages,
    required this.imageBaseUrl,
    required this.companyImageBaseUrl,
    required this.cartList,
  });

  factory CartListResponse.fromJson(Map<String, dynamic> json) {
    return CartListResponse(
      status: json['status'],
      error: json['error'],
      messages: Messages.fromJson(json['messages']),
      imageBaseUrl: json['image_base_url'],
      companyImageBaseUrl: json['company_image_base_url'],
      cartList: List<CartListItem>.from(
          json['cart_list'].map((x) => CartListItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'error': error,
      'messages': messages.toJson(),
      'image_base_url': imageBaseUrl,
      'company_image_base_url': companyImageBaseUrl,
      'cart_list': List<dynamic>.from(cartList.map((x) => x.toJson())),
    };
  }
}

class CartListItem {
  String cartId;
  String userId;
  String companyId;
  String branchId;
  String productId;
  String qty;
  String productCostMobile;
  String productDiscountMobile;
  String deliveryCharge;
  String createdDate;
  String companyName;
  String companyArbName;
  String companyImage;
  String branchName;
  String arbBranchName;
  String productName;
  String arbProductName;
  String discountOffer;
  String originalPrice;
  String serviceCharge;
  String citycodeVat;
  String supplierVatCharges;
  String picture;
  String description;
  String arbDescription;
  List<CartProductItem> cartProduct;

  CartListItem({
    required this.cartId,
    required this.userId,
    required this.companyId,
    required this.branchId,
    required this.productId,
    required this.qty,
    required this.productCostMobile,
    required this.productDiscountMobile,
    required this.deliveryCharge,
    required this.createdDate,
    required this.companyName,
    required this.companyArbName,
    required this.companyImage,
    required this.branchName,
    required this.arbBranchName,
    required this.productName,
    required this.arbProductName,
    required this.discountOffer,
    required this.originalPrice,
    required this.serviceCharge,
    required this.citycodeVat,
    required this.supplierVatCharges,
    required this.picture,
    required this.description,
    required this.arbDescription,
    required this.cartProduct,
  });

  factory CartListItem.fromJson(Map<String, dynamic> json) {
    return CartListItem(
      cartId: json['cart_id'],
      userId: json['user_id'],
      companyId: json['company_id'],
      branchId: json['branch_id'],
      productId: json['product_id'],
      qty: json['qty'],
      productCostMobile: json['product_cost_mobile'],
      productDiscountMobile: json['product_discount_mobile'],
      deliveryCharge: json['delivery_charge'],
      createdDate: json['created_date'],
      companyName: json['company_name'],
      companyArbName: json['company_arb_name'],
      companyImage: json['company_image'],
      branchName: json['branch_name'],
      arbBranchName: json['arb_branch_name'],
      productName: json['product_name'],
      arbProductName: json['arb_product_name'],
      discountOffer: json['discount_offer'],
      originalPrice: json['original_price'],
      serviceCharge: json['service_charge'],
      citycodeVat: json['citycode_vat'],
      supplierVatCharges: json['supplierVat_charges'],
      picture: json['picture'],
      description: json['description'],
      arbDescription: json['arb_description'],
      cartProduct: List<CartProductItem>.from(
          json['cartProduct'].map((x) => CartProductItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'user_id': userId,
      'company_id': companyId,
      'branch_id': branchId,
      'product_id': productId,
      'qty': qty,
      'product_cost_mobile': productCostMobile,
      'product_discount_mobile': productDiscountMobile,
      'delivery_charge': deliveryCharge,
      'created_date': createdDate,
      'company_name': companyName,
      'company_arb_name': companyArbName,
      'company_image': companyImage,
      'branch_name': branchName,
      'arb_branch_name': arbBranchName,
      'product_name': productName,
      'arb_product_name': arbProductName,
      'discount_offer': discountOffer,
      'original_price': originalPrice,
      'service_charge': serviceCharge,
      'citycode_vat': citycodeVat,
      'supplierVat_charges': supplierVatCharges,
      'picture': picture,
      'description': description,
      'arb_description': arbDescription,
      'cartProduct': List<dynamic>.from(cartProduct.map((x) => x.toJson())),
    };
  }
}

class CartProductItem {
  String cartId;
  String userId;
  String companyId;
  String branchId;
  String productId;
  String qty;
  String productCostMobile;
  String productDiscountMobile;
  String deliveryCharge;
  String createdDate;
  String companyName;
  String companyArbName;
  String companyImage;
  String branchName;
  String arbBranchName;
  String productName;
  String arbProductName;
  String discountOffer;
  String originalPrice;
  String serviceCharge;
  String citycodeVat;
  String supplierVatCharges;
  String picture;
  String description;
  String arbDescription;

  CartProductItem({
    required this.cartId,
    required this.userId,
    required this.companyId,
    required this.branchId,
    required this.productId,
    required this.qty,
    required this.productCostMobile,
    required this.productDiscountMobile,
    required this.deliveryCharge,
    required this.createdDate,
    required this.companyName,
    required this.companyArbName,
    required this.companyImage,
    required this.branchName,
    required this.arbBranchName,
    required this.productName,
    required this.arbProductName,
    required this.discountOffer,
    required this.originalPrice,
    required this.serviceCharge,
    required this.citycodeVat,
    required this.supplierVatCharges,
    required this.picture,
    required this.description,
    required this.arbDescription,
  });

  factory CartProductItem.fromJson(Map<String, dynamic> json) {
    return CartProductItem(
      cartId: json['cart_id'],
      userId: json['user_id'],
      companyId: json['company_id'],
      branchId: json['branch_id'],
      productId: json['product_id'],
      qty: json['qty'],
      productCostMobile: json['product_cost_mobile'],
      productDiscountMobile: json['product_discount_mobile'],
      deliveryCharge: json['delivery_charge'],
      createdDate: json['created_date'],
      companyName: json['company_name'],
      companyArbName: json['company_arb_name'],
      companyImage: json['company_image'],
      branchName: json['branch_name'],
      arbBranchName: json['arb_branch_name'],
      productName: json['product_name'],
      arbProductName: json['arb_product_name'],
      discountOffer: json['discount_offer'],
      originalPrice: json['original_price'],
      serviceCharge: json['service_charge'],
      citycodeVat: json['citycode_vat'],
      supplierVatCharges: json['supplierVat_charges'],
      picture: json['picture'],
      description: json['description'],
      arbDescription: json['arb_description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'user_id': userId,
      'company_id': companyId,
      'branch_id': branchId,
      'product_id': productId,
      'qty': qty,
      'product_cost_mobile': productCostMobile,
      'product_discount_mobile': productDiscountMobile,
      'delivery_charge': deliveryCharge,
      'created_date': createdDate,
      'company_name': companyName,
      'company_arb_name': companyArbName,
      'company_image': companyImage,
      'branch_name': branchName,
      'arb_branch_name': arbBranchName,
      'product_name': productName,
      'arb_product_name': arbProductName,
      'discount_offer': discountOffer,
      'original_price': originalPrice,
      'service_charge': serviceCharge,
      'citycode_vat': citycodeVat,
      'supplierVat_charges': supplierVatCharges,
      'picture': picture,
      'description': description,
      'arb_description': arbDescription,
    };
  }
}
