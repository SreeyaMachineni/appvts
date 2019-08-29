import 'package:flutter/material.dart';
import 'package:appvts/Globals.dart';
import 'package:appvts/screens/Home.dart';
import 'package:appvts/screens/Login.dart';
import 'package:appvts/widgets/Styles.dart';


class Launch extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title:Text('VTS',style: F16CBlackMR),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: new Container(
          decoration: new BoxDecoration(
                      image: new DecorationImage(
                      image: AssetImage("assets/vts.png"),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomRight,
                      ),
             ),
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (isLoggedOut)?  Text('You have successfully logged out',style: appText):Text('You have successfully setup',style: appText),
                    (isLoggedOut)? Text('of your VTS account, click to get started again',style: appText ):Text('Your VTS account, click to get started',style: appText ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: RaisedButton(
                        onPressed: (){
                          (isLoggedOut)?  Navigator.push(context,MaterialPageRoute(builder: (context) => Login())):Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: (isLoggedOut)?Text('Login',style: TextStyle(fontSize: 16,color: Colors.white),):Text('Get Started',style: TextStyle(fontSize: 16,color: Colors.white),),
                        color: appColor,
                      ),
                    ),
                  ],
                ),
             ),
          ),
      backgroundColor: Colors.white,
    );
  }
}