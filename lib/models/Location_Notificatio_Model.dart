// To parse this JSON data, do
//
//     final locationNotificationModel = locationNotificationModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

LocationNotificationModel locationNotificationModelFromJson(String str) =>
    LocationNotificationModel.fromJson(json.decode(str));

String locationNotificationModelToJson(LocationNotificationModel data) =>
    json.encode(data.toJson());

class LocationNotificationModel {
  LocationNotificationModel({
    required this.status,
    this.error,
    required this.messages,
    required this.fcmToken,
    required this.data,
    required this.companyId,
    required this.branchId,
  });

  int status;
  dynamic error;
  Messages messages;
  String fcmToken;
  Data data;
  String companyId;
  String branchId;

  factory LocationNotificationModel.fromJson(Map<String, dynamic> json) =>
      LocationNotificationModel(
        status: json["status"],
        error: json["error"],
        messages: Messages.fromJson(json["messages"]),
        fcmToken: json["fcm_token"],
        data: Data.fromJson(json["data"]),
        companyId: json["company_id"],
        branchId: json["branch_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "messages": messages.toJson(),
        "fcm_token": fcmToken,
        "data": data.toJson(),
        "company_id": companyId,
        "branch_id": branchId,
      };
}

class Data {
  Data({
    required this.title,
  });

  String title;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
      };
}

class Messages {
  Messages({
    required this.success,
  });

  String success;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        success: json["success"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
      };
}
