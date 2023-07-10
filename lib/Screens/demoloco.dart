// ignore_for_file: avoid_print, unnecessary_string_interpolations

import 'package:city_code/Screens/Destinationdemo.dart';
import 'package:city_code/Screens/utildemo.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Position _currentPosition;
  List<Destination> destinationlist = [];

  late String longitude = '00.00000';
  late String latitude = '00.00000';
  late LocationPermission permission;
  late bool serviceEnabled = false;
  Future<void> _getLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        distanceCalculation(position);
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        print("rohanlat" + latitude);
        print("rohanlong" + longitude);
      } else {
        await Geolocator.openLocationSettings();
      }
    } else {
      permission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    _getLocation();
    _getCurrentLocation();
    print("legth" + destinationlist.length.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Location sorting from current location"),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: destinationlist.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(5),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    height: 40,
                    color: Colors.white,
                    child: Column(
                      children: [
                        // Text("rohan")
                        Text("${destinationlist[index].name}"),
                        Text(
                            "${destinationlist[index].distance!.toStringAsFixed(2)} km"),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  // get Current Location
  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      distanceCalculation(position);
      setState(() {
        print("rohan" + _currentPosition.longitude.toString());
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  distanceCalculation(Position position) {
    for (var d in destinations) {
      var km = getDistanceFromLatLonInKm(
          position.latitude, position.longitude, d.lat, d.lng);
      // var m = Geolocator.distanceBetween(position.latitude,position.longitude, d.lat,d.lng);
      // d.distance = m/1000;
      d.distance = km;
      destinationlist.add(d);
      print("here data" + d.distance.toString());
      // print(getDistanceFromLatLonInKm(position.latitude,position.longitude, d.lat,d.lng));
    }
    setState(() {
      destinationlist.sort((a, b) {
        return a.distance!.compareTo(b.distance!);
      });
    });
  }
}
