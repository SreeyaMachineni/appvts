import 'package:appvts/Globals.dart';
import 'package:flutter/material.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/widgets/GetWidgets.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:appvts/services/AppTileServices.dart';
import 'package:appvts/screens/ViewAppointment.dart';

class AppointmentTile extends StatefulWidget{
  final Appointment appointment;
  final int noOfAppointments;

  AppointmentTile(this.appointment,this.noOfAppointments);
  @override
  AppointmentTileState createState() => AppointmentTileState();
}

class AppointmentTileState extends State<AppointmentTile> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: (){
          appointmentShared=widget.appointment;
          Navigator.push(context,MaterialPageRoute(builder: (context) =>ViewAppointment(appointment:widget.appointment)));
        },
        child:  Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 2, 20),
              child: CircleAvatar(
                radius:27,
                backgroundColor: nameAvatarColor,
                child: Text(getInitials(widget.appointment.visitorName[0]),style: NameAvatar),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text(widget.appointment.visitorName[0],style: getStyle(16.0,Colors.black,'MontserratRegular',FontWeight.bold)),
                subtitle: Text(getAppDate(widget.appointment.appointmentTime) + '\n' + widget.appointment.phoneNumber.toString(),style: getStyle(14.0, Colors.black, 'MontserratLight',FontWeight.normal),),
                isThreeLine: true,
              ),
            ),
            Padding(
              padding:EdgeInsets.fromLTRB(0, 0, 13,0),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(getAppTime(widget.appointment.appointmentTime),style: getStyle(12.0, Colors.black, 'MontserratRegular',FontWeight.bold),),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
                      child:
                      Opacity(
                          opacity: showOrHide(widget.appointment.noOfParkingSlots,widget.appointment.parkingSlots),
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child:Text(getParkingStatus(widget.appointment.noOfParkingSlots,widget.appointment.parkingSlotsRejectionReason,widget.appointment.parkingSlots,widget.appointment.status),
                                  style: TextStyle(fontSize: 9,color: parkingStatus),),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child:getParkingStatusImage(widget.appointment.noOfParkingSlots,widget.appointment.parkingSlotsRejectionReason,widget.appointment.parkingSlots,widget.appointment.status),
                              )
                            ],
                          )
                      )
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}


