/// status : 201
/// error : null
/// ContactUs : {"id":"1","phone":"+968-71716060","whatsapp":"https://wa.me/96871716060","instagram":"https://www.instagram.com/citycode/?utm_medium=copy_link","mail":"Info@cityadver.com","location":"https://www.google.com/maps/place/Silverador+Resort+Club/@19.2823785,72.8508195,14z/data=!4m8!3m7!1s0x3be7b22451f98dd9:0x5be1c50f9ad45b75!5m2!4m1!1i2!8m2!3d19.2770929!4d72.7963382"}

// ignore_for_file: camel_case_types

class City_code_contact_model {
  City_code_contact_model({
    int? status,
    dynamic error,
    ContactUs? contactUs,
  }) {
    _status = status;
    _error = error;
    _contactUs = contactUs;
  }

  City_code_contact_model.fromJson(dynamic json) {
    _status = json['status'];
    _error = json['error'];
    _contactUs = json['ContactUs'] != null
        ? ContactUs.fromJson(json['ContactUs'])
        : null;
  }
  int? _status;
  dynamic _error;
  ContactUs? _contactUs;

  int? get status => _status;
  dynamic get error => _error;
  ContactUs? get contactUs => _contactUs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['error'] = _error;
    if (_contactUs != null) {
      map['ContactUs'] = _contactUs?.toJson();
    }
    return map;
  }
}

/// id : "1"
/// phone : "+968-71716060"
/// whatsapp : "https://wa.me/96871716060"
/// instagram : "https://www.instagram.com/citycode/?utm_medium=copy_link"
/// mail : "Info@cityadver.com"
/// location : "https://www.google.com/maps/place/Silverador+Resort+Club/@19.2823785,72.8508195,14z/data=!4m8!3m7!1s0x3be7b22451f98dd9:0x5be1c50f9ad45b75!5m2!4m1!1i2!8m2!3d19.2770929!4d72.7963382"

class ContactUs {
  ContactUs({
    String? id,
    String? phone,
    String? whatsapp,
    String? instagram,
    String? mail,
    String? location,
  }) {
    _id = id;
    _phone = phone;
    _whatsapp = whatsapp;
    _instagram = instagram;
    _mail = mail;
    _location = location;
  }

  ContactUs.fromJson(dynamic json) {
    _id = json['id'];
    _phone = json['phone'];
    _whatsapp = json['whatsapp'];
    _instagram = json['instagram'];
    _mail = json['mail'];
    _location = json['location'];
  }
  String? _id;
  String? _phone;
  String? _whatsapp;
  String? _instagram;
  String? _mail;
  String? _location;

  String? get id => _id;
  String? get phone => _phone;
  String? get whatsapp => _whatsapp;
  String? get instagram => _instagram;
  String? get mail => _mail;
  String? get location => _location;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phone'] = _phone;
    map['whatsapp'] = _whatsapp;
    map['instagram'] = _instagram;
    map['mail'] = _mail;
    map['location'] = _location;
    return map;
  }
}
