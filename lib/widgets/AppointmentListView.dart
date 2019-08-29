import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:appvts/widgets/AppointmentTile.dart';
import 'package:appvts/screens/NoAppointmentsHome.dart';

class AppointmentList extends StatefulWidget{
  final List<Appointment> photos;
  AppointmentList({this.photos});
  @override
  AppointmentListState createState() => AppointmentListState();
}

class AppointmentListState extends State<AppointmentList>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (widget.photos.length == 0) {
      return NoAppointmentHome();
    }
    else {
      return ListView.builder(
        itemCount: widget.photos.length,
        itemBuilder: (context, index) =>
            AppointmentTile(widget.photos[index], widget.photos.length),
      );
    }
  }
}


