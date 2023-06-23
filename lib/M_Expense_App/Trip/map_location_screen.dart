
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class MapLocationScreen extends StatefulWidget {
  MapLocationScreen({Key? key, this.currentLocation}): super(key: key);

  String? currentLocation;
 

  @override
  State<MapLocationScreen> createState() => _MapLocationScreenState();
}

class _MapLocationScreenState extends State<MapLocationScreen> {

    
  late List<double> _locations;

  final Completer<GoogleMapController> _controller = Completer();


    GoogleMapController? newGoogleMapController;

  // ignore: prefer_const_constructors
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: const LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // ignore: prefer_const_constructors
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


    void splitLocation(String location) {
    //get lat and long from widget.theTrip.location
    List<String> latLong = location.split(',');
    
    double lat = double.parse(latLong[0]);
    double long = double.parse(latLong[1]);

    // currentPosition = LatLng(_locations[0], _locations[1]);
    _locations = [lat, long];
    setState(() {
      _locations = [lat, long];
      
      
    });
    }


  @override
  void initState() { //initState là 1 function của State để khởi tạo dữ liệu ban đầu cho State (khởi tạo dữ liệu ban đầu cho new book state)
    splitLocation(widget.currentLocation!);
    super.initState(); // gọi hàm initstate của cha
    final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
      if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = true;
  }
  }
  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Map Location'),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        zoomControlsEnabled: true,
         myLocationButtonEnabled: true,
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);


          // newGoogleMapController = controller;
          

          // LatLng latLngPosition = LatLng(_locations[0], _locations[1]);

          // CameraPosition cameraPosition =
          //     new CameraPosition(target: latLngPosition, zoom: 14);
          // newGoogleMapController!
          //     .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

          
        _goToTheLake();
          
              setState(() {
                _goToTheLake();
              });
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));

    LatLng latLngPosition = LatLng(_locations[0], _locations[1]);

          CameraPosition cameraPosition =
              new CameraPosition(target: latLngPosition, tilt: 59.440717697143555,
      zoom: 19.151926040649414);
          controller
              .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

  
  }
  

}