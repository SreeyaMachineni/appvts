import 'package:appvts/Globals.dart';
import 'package:flutter/material.dart';
import 'package:appvts/screens/Home.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/screens/AppForm.dart';
import 'package:appvts/screens/History.dart';


getUserAccountHeader(username,phone) {
  return new UserAccountsDrawerHeader(
    accountName:(username != null)?Text(username):Text(' '),
    accountEmail:(phone != null)? Text(' '+phone):Text(' '),
    currentAccountPicture: CircleAvatar(
      backgroundColor: Color(0xffFFB74D),
      child:  Image.asset('assets/leaf1.jfif', width: 49,),
    ),
    decoration:
    BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.6, 0.9],
            colors: [
              Color(0xffFF892E),
              Color(0xffFF9422),
              Color(0xffFFB74D),
            ]
        )
    ),
  );
}



Widget userAccount = new UserAccountsDrawerHeader(
  accountName:Text(' '+username),
  accountEmail:Text('dfdf'),
  currentAccountPicture: CircleAvatar(
    backgroundColor: Color(0xffFFB74D),
    child:  Image.asset('assets/leaf1.jfif', width: 49,),
  ),
  decoration:
  BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.3, 0.6, 0.9],
          colors: [
            Color(0xffFF892E),
            Color(0xffFF9422),
            Color(0xffFFB74D),
          ]
      )
  ),
);

toHistory(context){
  return ListTile(
    onTap: (){
      changeAppointment=false;
      Navigator.push(context,MaterialPageRoute(builder: (context) => History()));
    },
    leading: Icon(Icons.history),
    title: Text('History',style: F14CBlackMR),
  );
}

toMyAppointments(context){
  return  ListTile(
    onTap: (){
      adminEdit=false;
      changeAppointment=true;
      isSearchHistory=false;
      searchResult=false;
      Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
    },
    leading:Image.asset('assets/myAppointments.png', width: 21.34,),
    title: Text('My Appointments',style: F14CBlackMR,),
  );
}

addAppointmentFloating(context){
  return Container(
    height: 70.0,
    width: 70.0,
    child: FittedBox(
      child: FloatingActionButton(
        onPressed: () {
          isCreate = true;
          Navigator.push(context,MaterialPageRoute(builder: (context) => AppForm(action:'create')),);
        },
        backgroundColor: appColor,
        child: Icon(Icons.add),
      ),
    ),
  );
}


