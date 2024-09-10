import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
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
  File ? _selectedImage;
  final TextEditingController _textController = TextEditingController();

 Future<void> _pickImageFromGallery() async {
  final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery); // Await the result

  if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path); // Convert the picked image to File
    });
   
}

Future<void> _pickImageFromCamera() async {
  final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera); // Await the result

  if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path); // Convert the picked image to File
    });
   
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
            const SizedBox(
              height: 10,
            ),
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
            const TextField(
              maxLength: 50,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
                hintText: 'Enter Address',
              ),
            ),
            const Text(
              'Map Location',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
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
            const TextField(
              maxLength: 100,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 50.0),
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
                onPressed: () {
                   _pickImageFromGallery();
                },
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
                onPressed: () {
                  _pickImageFromCamera();
                  },
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
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry B')),
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        ),
      ),
    );
  }
}

