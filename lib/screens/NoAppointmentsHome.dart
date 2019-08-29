import 'package:flutter/material.dart';
import 'package:appvts/widgets/Styles.dart';

class NoAppointmentHome extends StatefulWidget{
  @override
  _NoAppointmentHome createState() => _NoAppointmentHome();
}

class _NoAppointmentHome extends State<NoAppointmentHome>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today,size:110,color: hintColor,),
          Text('You do not have any',style: NoAppointments),
          Text('Appointments Scheduled',style: NoAppointments ),
        ],
      ),
    );
  }
}