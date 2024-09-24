import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ruvumgt/app_files/my_complaints.dart';
import 'package:ruvumgt/app_files/rules.dart';
import 'package:ruvumgt/app_files/report.dart';
import 'package:flutter/services.dart'; 


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  LatLng? currentPosition;
  LatLng? lastPosition;
  final locationController = Location();

  

//  List<LatLng> polygonPoints = const [
  //];

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
              leading: const Icon(Icons.credit_card),
              title: const Text("My complaints"),
              onTap: () {
                Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const ComplaintsPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.handyman),
              title: const Text("Rules"),
              onTap: () {
                 Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => RulesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Exit"),
              onTap: () {
                SystemNavigator.pop();
              },
            ),
           
          ],
        ),
      ),
      body: Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _ruvuCoordinate,
              zoom: 13,
            ),
            markers: {
              if (currentPosition != null)
                Marker(
                  markerId: const MarkerId('marker'),
                  icon: BitmapDescriptor.defaultMarker,
                  position: currentPosition!,
                  draggable: true,
                  onDragEnd: (updatedLatLng) {
                    setState(() {
                      lastPosition = updatedLatLng; // Capture the new position here
                    });
                  },
                ),
            },
            
            myLocationEnabled: true, // Shows the blue dot for current location
            myLocationButtonEnabled: true, // Shows the location button
          ),
        ),

        ElevatedButton(
          onPressed: () {
            if (lastPosition == null && currentPosition != null) {
              lastPosition = currentPosition;
            }

            if (lastPosition != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Report(address: lastPosition!),
                ),
              );
            } else {
              // Handle the case when location is still null (e.g. show a message)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unable to get location. Please try again.")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 243, 221, 243),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
          ),
          child: const Text('Report Problem'),
        ),

      ],
    ),
      
      
          
);
  
    
  
}
}






















