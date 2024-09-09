import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  LatLng? currentPosition;
  final locationController = Location();

  static const LatLng _ruvuCoordinate = LatLng(-6.38333, 38.86667);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await fetchLocationUpdates());
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        // Handle the case where the user does not enable location services
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Handle the case where permission is not granted
        return;
      }
    }

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Ruvu_River.jpg'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 8.0,
                    left: 4.0,
                    child: Text(
                      "Ruvu Tracking App",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text("About"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.grid_3x3_outlined),
              title: const Text("Products"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text("Contact"),
              onTap: () {},
            )
          ],
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _ruvuCoordinate,
          zoom: 13,
        ),
        markers: {
          if (currentPosition != null)
            Marker(
              markerId: const MarkerId('currentLocation'),
              icon: BitmapDescriptor.defaultMarker,
              position: currentPosition!,
            ),
        },
        myLocationEnabled: true, // Shows the blue dot for current location
        myLocationButtonEnabled: true, // Shows the location button
      ),
    );
  }
}
