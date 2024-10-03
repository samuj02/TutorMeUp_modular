import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';  // Importar el paquete location
import 'package:http/http.dart' as http;  // Para realizar solicitudes HTTP
import 'dart:convert';  // Para decodificar las respuestas JSON

void main() => runApp(const InterfazMapa());

class InterfazMapa extends StatefulWidget {
  const InterfazMapa({Key? key}) : super(key: key);

  @override
  _InterfazMapaState createState() => _InterfazMapaState();
}

class _InterfazMapaState extends State<InterfazMapa> {
  GoogleMapController? _mapController;
  LocationData? _currentLocation;
  Location location = Location();
  BitmapDescriptor? _customIcon;
  Set<Polyline> _polylines = {};  // Para dibujar la ruta
  LatLng? _selectedDestination;  // Guardar la coordenada seleccionada

  // Coordenadas iniciales cuando el mapa se abre
  final LatLng _initialLocation = LatLng(20.657161, -103.326000); // Guadalajara

  // Lista de coordenadas para los marcadores
  final List<Map<String, dynamic>> _locations = [
    {'position': LatLng(20.65831106996784, -103.32625707044056), 'label': 'Módulo V1'},
    {'position': LatLng(20.658093347761614, -103.32612081442782), 'label': 'Módulo V2'},
    {'position': LatLng(20.658099232149606, -103.32539551315664), 'label': 'Módulo U'},
    {'position': LatLng(20.65790005833251, -103.32547693620323), 'label': 'Módulo T'},
    {'position': LatLng(20.657665680828877, -103.32566057090835), 'label': 'Módulo R'},
    {'position': LatLng(20.65761799545361, -103.32630966545705), 'label': 'Módulo S'},
    {'position': LatLng(20.657891964015636, -103.32644972692879), 'label': 'Módulo S2'},
    {'position': LatLng(20.657626954318502, -103.32492489353753), 'label': 'Módulo Q'},
    {'position': LatLng(20.657335916351233, -103.32540282637943), 'label': 'Módulo P'},
    {'position': LatLng(20.657241269737707, -103.3262878871978), 'label': 'Módulo O'},
    {'position': LatLng(20.658256351596354, -103.32707179824142), 'label': 'Módulo X'},
    {'position': LatLng(20.65807179176323, -103.32699846463076), 'label': 'Módulo W'},
    {'position': LatLng(20.656910006128875, -103.32618926616827), 'label': 'Módulo N'},
    {'position': LatLng(20.656654459414572, -103.32618167992922), 'label': 'Módulo M'},
    {'position': LatLng(20.65675620491306, -103.32524351544205), 'label': 'Módulo L'},
    {'position': LatLng(20.65636549022237, -103.32616282212007), 'label': 'Módulo K'},
    {'position': LatLng(20.65623412968878, -103.32594269672074), 'label': 'Módulo J'},
    {'position': LatLng(20.656039420076443, -103.32628026340917), 'label': 'Módulo H'},
    {'position': LatLng(20.655820830653848, -103.3259137378749), 'label': 'Módulo F'},
    {'position': LatLng(20.656084991182986, -103.32556878624541), 'label': 'Módulo I'},
    {'position': LatLng(20.65589254697731, -103.32689983383794), 'label': 'Módulo G'},
    {'position': LatLng(20.65645690514064, -103.32521291585486), 'label': 'Alfa'},
    {'position': LatLng(20.656206079550568, -103.32519211823622), 'label': 'Beta'},
    {'position': LatLng(20.65766349515413, -103.32745566383916), 'label': 'Módulo Z2'},
  ];

  // Lista de marcadores
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();  // Cargar el ícono personalizado
    _getCurrentLocation();  // Obtener la ubicación actual
  }

  // Cargar la imagen personalizada como ícono para los marcadores
  Future<void> _loadCustomMarker() async {
    _customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(35, 35)),
      'assets/images/edificio.png',
    );
    _initializeMarkers();
  }

  // Inicializa los marcadores con las coordenadas personalizadas y el ícono personalizado
  void _initializeMarkers() {
    setState(() {
      _markers = _locations
          .map((location) {
            return Marker(
              markerId: MarkerId(location['label']),
              position: location['position'],
              infoWindow: InfoWindow(
                title: location['label'],
                snippet: 'Coordenadas: ${location['position'].latitude}, ${location['position'].longitude}',
                onTap: () {
                  setState(() {
                    _selectedDestination = location['position'];  // Guardar el destino seleccionado
                  });
                },
              ),
              icon: _customIcon ?? BitmapDescriptor.defaultMarker,
            );
          })
          .toSet();
    });
  }

  // Obtener la ubicación actual del dispositivo
  Future<void> _getCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData locationData = await location.getLocation();

    setState(() {
      _currentLocation = locationData;
    });
  }

  // Función para calcular la ruta utilizando la API de Google Directions
Future<void> _calculateRoute(LatLng destination) async {
  if (_currentLocation == null) {
    print("No se puede obtener la ubicación actual.");
    return;
  }

  // Construir la URL de la API de Google Directions con el parámetro 'mode=walking'
  String apiKey = "AIzaSyCEFnBgIHrhgG9ArF5zbBzH_kd8ZJPRDJg"; // Reemplaza con tu API Key de Google Directions
  String url =
      'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$apiKey';

  // Realizar la solicitud HTTP
  http.Response response = await http.get(Uri.parse(url));
  Map<String, dynamic> data = jsonDecode(response.body);

  if (data['routes'].isNotEmpty) {
    String polyline = data['routes'][0]['overview_polyline']['points'];

    setState(() {
      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId('route'),
        points: _decodePolyline(polyline),
        width: 5,
        color: Colors.blue,
      ));
    });
  }
}

  // Función para decodificar la polilínea recibida de la API de Google Directions
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  LatLng? _selectedLocation; // Variable para almacenar la ubicación del marcador seleccionado

void _onMarkerTapped(LatLng location) {
  setState(() {
    _selectedLocation = location; // Actualizar la ubicación seleccionada
  });
}

void _onMapCreated(GoogleMapController controller) {
  _mapController = controller;
  _mapController?.animateCamera(
    CameraUpdate.newLatLngZoom(_initialLocation, 17.5),
  );
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa CUCEI',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Aumenta el grosor de la fuente
            fontSize: 26,                // Tamaño de la fuente (ajústalo como prefieras)
            color: Colors.white,          // Cambia el color del texto a blanco
          ),
        ),
        backgroundColor: Color.fromARGB(255, 33, 150, 243), // El color del AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),  // Icono de flecha hacia atrás
          onPressed: () {
            Navigator.pop(context);  // Regresa a la pantalla anterior
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            markers: _markers.map((marker) {
              return marker.copyWith(
                onTapParam: () => _onMarkerTapped(marker.position),
              );
            }).toSet(),
            polylines: _polylines,
            initialCameraPosition: CameraPosition(
              target: _initialLocation,
              zoom: 17.5,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_selectedLocation != null) // Mostrar el botón solo si hay un marcador seleccionado
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color.fromARGB(255, 33, 150, 243),
                ),
                onPressed: () {
                  if (_selectedLocation != null) {
                    _calculateRoute(_selectedLocation!); // Llamar a la función con la ubicación seleccionada
                  }
                },
                child: Text('Como Llegar', style: TextStyle(
                  fontWeight: FontWeight.bold, // Aumenta el grosor de la fuente
                  fontSize: 20,               
                  color: Colors.white,          // Cambia el color del texto a blanco
                ),),
              ),
            ),
        ],
      ),
    ),
  );
}


  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
