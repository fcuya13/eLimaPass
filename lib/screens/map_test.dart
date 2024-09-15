import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

class MapTest extends StatefulWidget{

  const MapTest({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MapTestState();
  }
}

class _MapTestState extends State<MapTest>{
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  LocationPermission? permission;

  getLocation() async {
    permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: AndroidSettings(accuracy: LocationAccuracy.high)
    );
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _currentPosition = location;
    });
  }


  @override
  void initState() {
    super.initState();
    getLocation();
    _initializeMapRenderer();
  }

  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform
        .instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  void _onMapCreated(GoogleMapController controller){
    mapController = controller;
    _updateCamera();
  }

  void _updateCamera() {
    if (_currentPosition != null) {
      mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPosition!,
          zoom: 15.0,
        ),
      ));
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentPosition!,
            zoom: 15.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          zoomControlsEnabled: true,
          compassEnabled: false,
        ),
      ),
    );
  }
}