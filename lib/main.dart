import 'package:flutter/material.dart';
import 'package:ruvumgt/app_files/home_page.dart';
//import 'package:ruvumgt/app_files/my_complaints.dart';
//import 'package:ruvumgt/pages/home_page.dart';
//import 'package:ruvumgt/app_files/report.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
    url: 'https://pjjpvczhsjtjqngaufpa.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBqanB2Y3poc2p0anFuZ2F1ZnBhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU5MDAzNjEsImV4cCI6MjA0MTQ3NjM2MX0.mrS7XpJx55avElxN4fQeceM-4yihmfd-SBiPxH2HKiU',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage()
    );
  }
}


