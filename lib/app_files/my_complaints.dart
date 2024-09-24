import 'package:flutter/material.dart';
//import 'package:get/get.dart';
//import 'package:ruvumgt/controllers/reports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:ruvu/screens/map.dart'; write map page later
import 'package:device_info/device_info.dart';

class ComplaintsPage extends StatefulWidget {
 

  const ComplaintsPage({super.key});

  @override
  State<ComplaintsPage> createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  bool isLoading = false;
  List<dynamic> complaints = [];
  String? _deviceID;

  final supabase = Supabase.instance.client;

   Future<void> _getDeviceID() async { 
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin(); 
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo; 
    setState(() { 
      _deviceID = androidInfo.androidId; 
    });

    
  } 

  Future<void> getComplaints() async {
    setState(() {
      isLoading = true;
    });

    await _getDeviceID();
    final response = await supabase
    .from('supabase_test')
    .select('''
          image_url,
          category,
          description,
          address,
          status,
          created_at
        ''')
    .eq('user_id', '$_deviceID')
    .order('created_at', ascending: false);

    complaints = List<Map<String, dynamic>>.from(response);
    
    setState(() {
      isLoading = false;
    });



  }


  @override
  void initState() {
    getComplaints();
    super.initState();
  }

  Future<void> _refreshData() async {
    getComplaints(); // Fetch fresh data from Supabase
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My complaints'),
        centerTitle: true,
      ),
      body: 
         Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : complaints.isEmpty
                  ? const Text('No Complaints')
                  : RefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        itemCount: complaints.length,
                        itemBuilder: (context, index) {
                          var reporta = complaints[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: const Offset(15, 3),
                                  ),
                                ],
                              ),
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              reporta['image_url'] ?? '')),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: size.width - 115,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Category: ${reporta['category']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Description: ${reporta['description']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Address: ${reporta['address']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.red),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Text(
                                              'Status: ${reporta['status']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red),
                                            ),
                                            const SizedBox(width: 10),
                                            /* GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewMap(data: reporta),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                decoration:
                                                    const BoxDecoration(
                                                        color: Colors.green),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    Icons.place,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ) */
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ),
      
    );
  }
}
