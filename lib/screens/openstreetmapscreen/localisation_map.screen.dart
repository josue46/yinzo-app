import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:yinzo/widgets/custom_app_bar.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  final TextEditingController _locationController = TextEditingController();
  bool isLoading = false;
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> routes = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() async {
    if (!await _checkRequestPermission()) return;
    _location.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
          isLoading = false;
        });
      }
    });
  }

  Future<bool> _checkRequestPermission() async {
    // Vérifier si le service de localisation est activé
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return false;
    }

    // Vérifier les permissions
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  Future<void> fetchCoordinatesPoint(String location) async {
    Dio dio = Dio();
    // URL de l'API Nominatim
    String url =
        "https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1";
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      // Si la requête est réussie, on récupère les coordonnées
      final data = json.decode(response.data);
      // Vérifier si la réponse contient des données
      if (data.isNotEmpty) {
        final double lat = double.parse(data[0]['lat']);
        final double lon = double.parse(data[0]['lon']);

        setState(() {
          _destination = LatLng(lat, lon);
        });
        await _fetchRoute();
      } else {
        errorMessage("Aucune coordonnée trouvée pour cette adresse");
      }
    } else {
      // Gérer l'erreur ici
      errorMessage("Erreur lors de la recupération des données");
    }
  }

  Future<void> _fetchRoute() async {
    if (_currentLocation == null || _destination == null) return;
    Dio dio = Dio();
    final String url =
        "http://router.project-osrm.org/route/v1/driving/"
        '${_currentLocation!.longitude},${_currentLocation!.latitude};'
        '${_destination!.longitude},${_destination!.latitude}?overview=full&geometries=polyline';
    // Envoi de la requête
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.data);
      final geometry = data['routes'][0]['geometry'];
      _decodePolyline(encodePolyline: geometry);
    } else {
      // Gérer l'erreur ici
      errorMessage("Erreur lors de la récupération de l'itinéraire");
    }
  }

  void _decodePolyline({required String encodePolyline}) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encodePolyline);
    setState(() {
      routes =
          result
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();
    });
  }

  void errorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 16.0);
    } else {
      errorMessage("La localisation actuelle n'est pas disponible");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'Retrouvez une maison ou un appartement',
          centerTitle: true,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
              : FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  minZoom: 0,
                  maxZoom: 100,
                  initialCenter: _currentLocation ?? const LatLng(0, 25),
                  initialZoom: 3.8,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  CurrentLocationLayer(
                    style: LocationMarkerStyle(
                      marker: DefaultLocationMarker(
                        child: Icon(Icons.location_on, color: Colors.white),
                      ),
                      markerSize: const Size(35, 35),
                      markerDirection: MarkerDirection.heading,
                    ),
                  ),
                  if (_destination != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          child: Icon(
                            Icons.location_pin,
                            size: 40,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          point: _destination!,
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                  if (_currentLocation != null &&
                      _destination != null &&
                      routes.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: routes,
                          strokeWidth: 5,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                ],
              ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 15, left: 50, right: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      final String location = _locationController.text.trim();
                      if (location.isEmpty) {
                        errorMessage("Veuillez entrer une adresse");
                        return;
                      }
                      fetchCoordinatesPoint(location);
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  hintStyle: const TextStyle(color: Colors.black54),
                  hintMaxLines: 1,
                  hintText: "Entrez une adresse",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: _userCurrentLocation,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.my_location, size: 25, color: Colors.white),
      ),
    );
  }
}
