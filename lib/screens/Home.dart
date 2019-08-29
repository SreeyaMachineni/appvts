import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appvts/Globals.dart';
import 'package:appvts/services/APIs.dart';
import 'package:appvts/screens/Launch.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/screens/AdminHome.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:appvts/widgets/SidebarWidgets.dart';
import 'package:appvts/widgets/AppointmentListView.dart';
import 'package:appvts/services/FetchAppointmentList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String phone;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  initState()  {
    super.initState();
    setState(() {
      getUserName();
    });
  }

  getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       username =  prefs.getString('username');
       phone = prefs.getString('phone');
     });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title:
      ListTile(
        title: Text('My Appointments',style: F16CBlackMR),
        contentPadding: EdgeInsets.symmetric(vertical: 2.0),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
    ),
    drawer: SizedBox(
      width: 230,
      child: Drawer(
        child: Column(
          children: <Widget>[
            getUserAccountHeader(username,phone),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                toHistory(context),
                toMyAppointments(context),
            Offstage(offstage: !isAdmin,child:ListTile(
              onTap: (){
                changeAppointment=false;
                Navigator.push(context,MaterialPageRoute(builder: (context) => AdminHome()));
              },
              leading:Image.asset('assets/myAppointments.png', width: 21.34,),
              title: Text('Approvals',style: F14CBlackMR,),
            )),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout',style: F14CBlackMR),
                  onTap: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('username');
                    final flutterWebviewPlugin = new FlutterWebviewPlugin();
                    flutterWebviewPlugin.launch(LOGOUT);
                    flutterWebviewPlugin.close();
                    isLoggedOut = true;
                    Navigator
                        .of(context)
                        .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
                      return Launch();
                    }));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    ),
    body:FutureBuilder<List<Appointment>>(
      future: fetchAppointmentsList(http.Client(),'all'),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? AppointmentList(photos: snapshot.data)
            : Center(child: CircularProgressIndicator());
      },
    ),
    floatingActionButton: addAppointmentFloating(context),
  );
}
