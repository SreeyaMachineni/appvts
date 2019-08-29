import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appvts/Globals.dart';
import 'package:appvts/services/APIs.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/screens/Launch.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:appvts/services/AdminServices.dart';
import 'package:appvts/widgets/SidebarWidgets.dart';
import 'package:appvts/widgets/AppointmentListView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

String phone;
class AdminHome extends StatefulWidget{
  @override
  AdminHomeState createState() => AdminHomeState();
}

class AdminHomeState extends State<AdminHome> with SingleTickerProviderStateMixin{
  TabController tabController;
  bool allowAdd = true;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        setState(() {
          switch (tabController.index) {
            case 0:
              allowAdd = true;
              isFirstTab = true;
              adminEdit = false;
              changeAppointment=false;
              break;
            case 1:
              allowAdd = false;
              isFirstTab = false;
              adminEdit = true;
              changeAppointment=true;
              break;
          }
        });
      });

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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('All Appointments',style: TextStyle(color: Colors.black),),),
              Tab(child: Text('Approvals',style: TextStyle(color: Colors.black),),)
            ],
            indicatorColor: appColor,
            controller: tabController,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        //side bar begin
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
                    //show Approvals tab only for admin
                    Offstage(offstage: !isAdmin,child:ListTile(
                      onTap: (){
                        searchResult=false;
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
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) { return Launch();  }));
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            FutureBuilder<List<Appointment>>(
              future: fetchAdminAppointments(http.Client(),'allApps'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData ? AppointmentList(photos: snapshot.data) : Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder<List<Appointment>>(
              future: fetchAdminAppointments(http.Client(),'Pending'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData ? AppointmentList(photos: snapshot.data) : Center(child: CircularProgressIndicator());
              },
            ),
          ],
        )
    );
  }
}