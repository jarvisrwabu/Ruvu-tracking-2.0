import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info/device_info.dart';
import 'package:uuid/uuid.dart';

class Report extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final LatLng? address;

  const Report({super.key, required this.address});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final supabase = Supabase.instance.client;
  
  // Controllers for the text fields
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mapController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Water pollution',
    'Water theft',
    'Animal keeping',
    'Water blockage or diversion',
    'Agriculture activities',
    'Waste disposal',
    'Other'
  ];

  String? _selectedCategory;
  File? _selectedImage;
  String? _deviceID;

  @override
void initState() {
  super.initState();
  // Initialize the address controller with the passed LatLng value
  if (widget.address != null) {
    _mapController.text = 
        '${widget.address!.latitude}, ${widget.address!.longitude}';
  }
}

  bool _isSubmitting = false; // Track if submission is in progress

  // Get the Android device ID
  Future<void> _getDeviceID() async { 
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); 
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo; 
    setState(() { 
      _deviceID = androidInfo.androidId; 
    });

    
  } 

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> _insertData() async {
    setState(() {
      _isSubmitting = true; // Start showing progress indicator
    });

    await _getDeviceID();

    final String category = _textController.text;
    final String address = _addressController.text;
    final String mapLocation = _mapController.text;
    final String description = _descriptionController.text;
    const String status = 'Processing';

    String? imageUrl;

    if (_selectedImage != null) {
      final imageBytes = await _selectedImage!.readAsBytes();
      const uuid = Uuid();
      final uniqueFileName = '${_deviceID}_${uuid.v4()}';
      final imagePath = '/$_deviceID/images/$uniqueFileName.${_selectedImage!.path.split('.').last.toLowerCase()}';

      // Upload image to Supabase Storage
      await supabase.storage
          .from('ruvu')
          .uploadBinary(imagePath, imageBytes, fileOptions: const FileOptions(upsert: true));

      // Get the public URL for the uploaded image
      imageUrl = supabase.storage.from('ruvu').getPublicUrl(imagePath);
    }

    // Insert data into Supabase
    await supabase.from('supabase_test').insert({
      'category': category,
      'address': address,
      'map_location': mapLocation,
      'description': description,
      'image_url': imageUrl,
      'status': status,
      'user_id': _deviceID,
    });

    // Reset state after submission
    setState(() {
      _textController.clear();
      _addressController.clear();
      _mapController.clear();
      _descriptionController.clear();
      _selectedImage = null;
      _selectedCategory = null;
      _isSubmitting = false; // Stop showing progress indicator
    });

    // Optional: Show a success message
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report a Problem',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Help to Protect the environment',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select Category',
                    ),
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: _categories.map((String category) {
                              return ListTile(
                                title: Text(category),
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                    _textController.text = _selectedCategory!;
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Address',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              maxLength: 50,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
                hintText: 'Enter Address',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Map Location',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _mapController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Map Location',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              maxLength: 100,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
               // contentPadding: EdgeInsets.symmetric(vertical: 50.0),
                labelStyle: TextStyle(fontSize: 20.0),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Add photographic evidence',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            // ignore: avoid_unnecessary_containers
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 90.0),
              child: MaterialButton(
                color: const Color.fromARGB(255, 64, 161, 241),
                onPressed: _pickImageFromGallery,
                child: const Text(
                  "Pick Image from Gallery",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 85.0),
              child: MaterialButton(
                color: const Color.fromARGB(255, 238, 112, 103),
                onPressed: _pickImageFromCamera,
                child: const Text(
                  "Pick Image from Camera",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _selectedImage != null ? Image.file(_selectedImage!) : const Text("Please Select Image"),
            const SizedBox(height: 20),
            
            // Show progress indicator when submitting
            _isSubmitting
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                  width: double.infinity,
                  height: 60,

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 243, 221, 243),
                  ),
                    onPressed: _insertData,
                    child: const Text("Submit"),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
