import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  int status;
  dynamic error;
  Messages messages;
  int count;
  String imageBaseUrl;
  List<Orderslist> orderslist;

  OrderModel({
    required this.status,
    this.error,
    required this.messages,
    required this.count,
    required this.imageBaseUrl,
    required this.orderslist,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        status: json["status"],
        error: json["error"],
        messages: Messages.fromJson(json["messages"]),
        count: json["count"],
        imageBaseUrl: json["image_base_url"],
        orderslist: List<Orderslist>.from(
            json["orderslist"].map((x) => Orderslist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "messages": messages.toJson(),
        "count": count,
        "image_base_url": imageBaseUrl,
        "orderslist": List<dynamic>.from(orderslist.map((x) => x.toJson())),
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

class Orderslist {
  String customerName;
  String memberCode;
  String orderId;
  String paidAmount;
  String paymentStatus;
  DateTime? dateTime;
  String quantity;
  String productName;
  String productImage;
  String address;
  String memberMobileNo;
  String orderStatus;
  String paymentMode;
  String transactionNo;

  Orderslist({
    required this.customerName,
    required this.memberCode,
    required this.orderId,
    required this.paidAmount,
    required this.paymentStatus,
    required this.dateTime,
    required this.quantity,
    required this.productName,
    required this.productImage,
    required this.address,
    required this.memberMobileNo,
    required this.orderStatus,
    required this.paymentMode,
    required this.transactionNo,
  });

  factory Orderslist.fromJson(Map<String, dynamic> json) => Orderslist(
        customerName: json["customer_name"] ?? "",
        memberCode: json["member_code"] ?? "",
        orderId: json["order_id"] ?? "",
        paidAmount: json["paid_amount"] ?? "",
        paymentStatus: json["payment_status"] ?? "",
        dateTime: parseDateTime(json["date & time"] ?? ""),
        quantity: json["quantity"] ?? "",
        productName: json["product_name"] ?? "",
        productImage: json["product_image"] ?? "",
        address: json["address"] ?? "",
        memberMobileNo: json["member_mobil_no"] ?? "",
        orderStatus: json["order_status"] ?? "",
        paymentMode: json["payment_mode"] ?? "",
        transactionNo: json["transaction_no"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "member_code": memberCode,
        "order_id": orderId,
        "paid_amount": paidAmount,
        "payment_status": paymentStatus,
        "date & time": dateTime != null ? formatDateTime(dateTime!) : null,
        "quantity": quantity,
        "product_name": productName,
        "product_image": productImage,
        "address": address,
        "member_mobil_no": memberMobileNo,
        "order_status": orderStatus,
        "payment_mode": paymentMode,
        "transaction_no": transactionNo,
      };
}

String formatDateTime(DateTime dateTime) {
  final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
  final period = dateTime.hour >= 12 ? 'pm' : 'am';
  final formattedDateTime =
      "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year.toString().padLeft(4, '0')} ${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}$period";
  return formattedDateTime;
}

DateTime parseDateTime(String dateTimeString) {
  final parts = dateTimeString.split(" ");
  final dateParts = parts[0].split("-");
  final timeParts = parts[1].split(":");
  final day = int.parse(dateParts[0]);
  final month = int.parse(dateParts[1]);
  final year = int.parse(dateParts[2]);
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);
  final second = int.parse(timeParts[2].substring(0, 2));
  final period = timeParts[2].substring(2);
  final adjustedHour = period == 'pm' ? hour + 12 : hour;
  return DateTime(year, month, day, adjustedHour, minute, second);
}
