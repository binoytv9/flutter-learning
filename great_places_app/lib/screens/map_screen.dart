import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation = const PlaceLocation(
      latitude: 10.5446,
      longitude: 76.1466,
    ),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.initialLocation.latitude);
    print(widget.initialLocation.longitude);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Map',
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 16.0,
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
        ),
      ),
    );
  }
}
