import 'package:appvts/Globals.dart';
import 'package:flutter/material.dart';
import 'package:appvts/screens/Home.dart';
import 'package:appvts/screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('username');
  var role = prefs.getString('role');
  if(role=='admin'){isAdmin = true;}
  runApp(MaterialApp(
      home: email == null ? Login() :Home(),
  )
  );
}
