// ignore_for_file: must_be_immutable, unnecessary_null_comparison, unused_local_variable, avoid_unnecessary_containers, unnecessary_this, deprecated_member_use, unnecessary_brace_in_string_interps

import 'package:google_maps_webservice/places.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const kGoogleApiKey = "YOUR_API_KEY";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class PlaceDetailWidget extends StatefulWidget {
  String placeid;

  PlaceDetailWidget({Key? key, required this.placeid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlaceDetailState();
  }
}

class PlaceDetailState extends State<PlaceDetailWidget> {
  late GoogleMapController mapController;
  static CameraPosition inialcameraposition =
      const CameraPosition(target: LatLng(19.2785471, 72.8796206), zoom: 14);
  Set<Marker> markers = {};
  late PlacesDetailsResponse place;
  bool isLoading = false;
  late String errorLoading;

  @override
  void initState() {
    fetchPlaceDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyChild;
    String title;
    if (isLoading) {
      title = "Loading";
      bodyChild = const Center(
        child: CircularProgressIndicator(
          value: null,
        ),
      );
    } else if (errorLoading != null) {
      title = "";
      bodyChild = Center(
        child: Text(errorLoading),
      );
    } else {
      final placeDetail = place.result;
      final location = place.result.geometry!.location;
      final lat = location.lat;
      final lng = location.lng;
      final center = LatLng(lat, lng);

      title = placeDetail.name;
      bodyChild = Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              child: SizedBox(
            height: 200.0,
            child: GoogleMap(
              initialCameraPosition: inialcameraposition,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              markers: markers,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              /*   markers: Set<Marker>.of(
                            <Marker> [
                              Marker(
                                markerId: MarkerId("home"),
                                position: LatLng(placemark.position.latitude, placemark.position.longitude),
                                icon: BitmapDescriptor.defaultMarker,
                                infoWindow: InfoWindow(
                                    title: placemark.name
                                ),
                                draggable: true,
                              ),
                            ]
                        ),*/
            ),
          )),
          Expanded(
            child: buildPlaceDetailList(placeDetail),
          )
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: bodyChild);
  }

  void fetchPlaceDetail() async {
    setState(() {
      this.isLoading = true;
      this.errorLoading = "error";
    });

    PlacesDetailsResponse place =
        await _places.getDetailsByPlaceId(widget.placeid);

    if (mounted) {
      setState(() {
        this.isLoading = false;
        if (place.status == "OK") {
          this.place = place;
        } else {
          this.errorLoading = place.errorMessage.toString();
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    final placeDetail = place.result;
    final location = place.result.geometry!.location;
    final lat = location.lat;
    final lng = location.lng;
    final center = LatLng(lat, lng);
    markers.add(
      Marker(
        markerId: const MarkerId("home"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        infoWindow: InfoWindow(
          title: placeDetail.name,
        ),
        draggable: true,
      ),
    );
  }

  String buildPhotoURL(String photoReference) {
    return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${photoReference}&key=${kGoogleApiKey}";
  }

  ListView buildPlaceDetailList(PlaceDetails placeDetail) {
    List<Widget> list = [];
    if (placeDetail.photos != null) {
      final photos = placeDetail.photos;
      list.add(SizedBox(
          height: 100.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(right: 1.0),
                    child: SizedBox(
                      height: 100,
                      child: Image.network(
                          buildPhotoURL(photos[index].photoReference)),
                    ));
              })));
    }

    list.add(
      Padding(
          padding: const EdgeInsets.only(
              top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
          child: Text(
            placeDetail.name,
            style: Theme.of(context).textTheme.subtitle1,
          )),
    );

    if (placeDetail.formattedAddress != null) {
      list.add(
        Padding(
            padding: const EdgeInsets.only(
                top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedAddress.toString(),
              style: Theme.of(context).textTheme.bodyText2,
            )),
      );
    }

    if (placeDetail.types.first != null) {
      list.add(
        Padding(
            padding: const EdgeInsets.only(
                top: 4.0, left: 8.0, right: 8.0, bottom: 0.0),
            child: Text(
              placeDetail.types.first.toUpperCase(),
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.formattedPhoneNumber != null) {
      list.add(
        Padding(
            padding: const EdgeInsets.only(
                top: 4.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.formattedPhoneNumber.toString(),
              style: Theme.of(context).textTheme.button,
            )),
      );
    }

    if (placeDetail.openingHours != null) {
      final openingHour = placeDetail.openingHours;
      var text = '';
      if (openingHour!.openNow) {
        text = 'Opening Now';
      } else {
        text = 'Closed';
      }
      list.add(
        Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.website != null) {
      list.add(
        Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              placeDetail.website.toString(),
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    if (placeDetail.rating != null) {
      list.add(
        Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 8.0, right: 8.0, bottom: 4.0),
            child: Text(
              "Rating: ${placeDetail.rating}",
              style: Theme.of(context).textTheme.caption,
            )),
      );
    }

    return ListView(
      shrinkWrap: true,
      children: list,
    );
  }
}

class GoogleMapOptions {}
