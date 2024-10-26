import 'dart:convert';
import 'package:flutter/material.dart';
import 'InterviewModel.dart';
import 'homescreen.dart';
import 'offline/oflinedata.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'API Data Fetch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OfflineUserListScreen(),
    );
  }
}



