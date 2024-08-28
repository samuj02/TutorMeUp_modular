import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapaScreen extends StatefulWidget {
  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  late GoogleMapController _controller;
  LatLng? _currentPosition;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  // Método para obtener la ubicación actual del dispositivo
  Future<void> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Verificar si el servicio de ubicación está habilitado
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Verificar los permisos de ubicación
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Obtener la ubicación actual
    LocationData _locationData = await _location.getLocation();

    setState(() {
      _currentPosition = LatLng(_locationData.latitude!, _locationData.longitude!);
    });

    // Mover la cámara del mapa a la ubicación actual
    if (_controller != null) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14.0),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;

    // Mover la cámara al iniciar si ya tenemos la ubicación
    if (_currentPosition != null) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa con Ubicación Actual'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator()) // Mostrar un loader mientras se obtiene la ubicación
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14.0,
              ),
              myLocationEnabled: true,  // Mostrar el botón para centrar en la ubicación actual
              markers: {
                Marker(
                  markerId: MarkerId("ubicacion_actual"),
                  position: _currentPosition!,
                  infoWindow: InfoWindow(title: 'Ubicación Actual'),
                ),
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MapaScreen(),
  ));
}
