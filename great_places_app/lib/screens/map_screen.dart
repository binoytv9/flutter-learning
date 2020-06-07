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
  LatLng _pickedLocation;

  void selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Map',
        ),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(
                Icons.check,
              ),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(
                        _pickedLocation,
                      );
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 16.0,
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
        ),
        onTap: widget.isSelecting ? selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                  markerId: MarkerId(
                    'm1',
                  ),
                  position: _pickedLocation ??
                      LatLng(
                        widget.initialLocation.latitude,
                        widget.initialLocation.longitude,
                      ),
                )
              },
      ),
    );
  }
}
