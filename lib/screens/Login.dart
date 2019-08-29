import 'package:flutter/material.dart';
import 'package:appvts/Globals.dart';
import 'package:appvts/screens/Home.dart';
import 'package:appvts/screens/Launch.dart';
import 'package:appvts/services/LoginService.dart';

class Login extends StatefulWidget{
  @override
  LoginState createState() => LoginState();
}
class LoginState extends State<Login> {
  bool isValid = false;
  String name;

  @override
  initState()  {
    super.initState();
    isLoggedOut=false;
    getname();
  }

  getname() async{
  await getNameFromOffice();
      if(name == null){
        isValid=false;
      }
      else{
        setEmail(name);
      }
  }


  @override
  Widget build(BuildContext context) {
  return
      isValid ? Home() :  Launch();
    }
    setEmail(name) {
      setState(() {
        isValid = true;
      });
  }
}
