class Pointbuys {
  Pointbuys({
    this.status,
    this.error,
    this.messages,
    this.buypointslist,});

  Pointbuys.fromJson(dynamic json) {
    status = json['status'];
    error = json['error'];
    messages = json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    if (json['buypointslist'] != null) {
      buypointslist = [];
      json['buypointslist'].forEach((v) {
        buypointslist?.add(Buypointslist.fromJson(v));
      });
    }
  }
  int? status;
  dynamic error;
  Messages? messages;
  List<Buypointslist>? buypointslist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['error'] = error;
    if (messages != null) {
      map['messages'] = messages?.toJson();
    }
    if (buypointslist != null) {
      map['buypointslist'] = buypointslist?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Buypointslist {
  Buypointslist({
    this.id,
    this.points,
    this.amount,
    this.created,});

  Buypointslist.fromJson(dynamic json) {
    id = json['id'];
    points = json['points'];
    amount = json['amount'];
    created = json['created'];
  }
  String? id;
  String? points;
  String? amount;
  String? created;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['points'] = points;
    map['amount'] = amount;
    map['created'] = created;
    return map;
  }

}

class Messages {
  Messages({
    this.success,});

  Messages.fromJson(dynamic json) {
    success = json['success'];
  }
  String? success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    return map;
  }

}