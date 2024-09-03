import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InterfazMapa extends StatefulWidget {
  @override
  _InterfazMapaState createState() => _InterfazMapaState();
}

class _InterfazMapaState extends State<InterfazMapa> {
  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194),
          zoom: 12,
        ),
      ),
    );
  }
}
