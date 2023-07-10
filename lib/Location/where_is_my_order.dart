// ignore_for_file: unused_local_variable

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/constants.dart';

class WhereIsMyOrder extends StatefulWidget {
  const WhereIsMyOrder({Key? key}) : super(key: key);

  @override
  State<WhereIsMyOrder> createState() => _WhereIsMyOrderState();
}

class _WhereIsMyOrderState extends State<WhereIsMyOrder> {
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  Position? _currentPosition;
  StreamSubscription<Position>? positionStreamSubscription;

  Future<void> _getCurrentPosition() async {
    if (!mounted) return;
    await Geolocator.getCurrentPosition().then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    ).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {});
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error("Location Services are disabled");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Services are disabled");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location Services are disabled");
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  String googleApiKey = "GOOGLE_MAP_API_KEY";
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  static CameraPosition startLocation =
      const CameraPosition(target: LatLng(19.2785471, 72.8796206), zoom: 18);
  String location = "Location Name:";

  @override
  void initState() {
    super.initState();
    currentLocation();
  }

  Future<void> currentLocation() async {
    _getCurrentPosition();
    Position position = await _determinePosition();
    cameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 18,
    );

    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
    markers.clear();

    markers.add(
      Marker(
        markerId: const MarkerId("home"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed), // Set the marker color to red
        draggable: true,
      ),
    );

    positionStreamSubscription = Geolocator.getPositionStream().listen(
      (Position position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
            markers.clear();
            markers.add(
              Marker(
                markerId: const MarkerId("home"),
                position: LatLng(position.latitude, position.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed), // Set the marker color to red
                draggable: true,
              ),
            );
          });
        }
      },
    );
  }

  @override
  dispose() {
    googleMapController.dispose();
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CC0F),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          Constants.language == "en"
              ? "Delivery Boy Location"
              : "Delivery Boy Location",
          style: TextStyle(
            color: Colors.black,
            fontFamily: Constants.language == "en" ? "Roboto" : "GSSFont",
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: startLocation,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (controller) async {
              googleMapController = controller;
              Position position = await _determinePosition();

              googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 18,
                ),
              ));
              _getCurrentPosition();
              if (!mounted) return;
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPosition) {
              setState(() {
                this.cameraPosition = cameraPosition;
              });
            },
            onCameraIdle: () async {},
            markers: markers,
          ),
          // if (_currentPosition != null)
          //   Positioned(
          //    // top: _currentPosition!.latitude,
          //    // left: _currentPosition!.longitude,
          //     child: Image.asset(
          //       "images/tool.png",
          //       width: 40,
          //       color: Colors.red.shade600,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
