import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  static const LatLng _ruvuCoordinate = LatLng(-6.38333,38.86667);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),

      body: GoogleMap(initialCameraPosition: CameraPosition(target: _ruvuCoordinate, zoom: 13,)),
    );
  }
}