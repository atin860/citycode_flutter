// ignore_for_file: file_names

class Destination {
  double lat;
  double lng;
  String name;
  num? distance;

  Destination(this.lat, this.lng, this.name, {this.distance});
}

var destinations = [
  Destination(37.4274684, -122.1698161, "Standford University"),
  Destination(19.0760, 72.8777, "mumbai"),
  Destination(37.4259071, -122.1095606, "Ramos Park"),
  Destination(37.8711583, -122.336457, "Bekerly"),
  Destination(37.7586968, -122.3053474, "Oakland"),
  Destination(37.4420794, -122.1432758, "Palo Alto"),
  Destination(37.5206515, -122.064364, "New wark")
];
