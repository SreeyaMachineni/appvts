import 'package:appvts/Globals.dart';
import 'package:flutter/material.dart';
import 'package:appvts/services/APIs.dart';
import 'package:appvts/services/Bloc.dart';
import 'package:appvts/screens/AppForm.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:appvts/services/FetchAppointmentList.dart';
import 'package:shared_preferences/shared_preferences.dart';

Appointment appointment;
createOrEdit(appointment,action,isParkingNeeded) async {
  String url;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var name = prefs.getString('username');
  Map appValues = new Map();
  switch(action){
    case 'create':
      url = ADD_APPOINTMENT;
      break;
    case 'edit':
      url = UPDATE_APPOINTMENT;
      appValues["_id"] = appointment.id;
      break;
  }
  List<String> visitorNames = [];
  for (int i = 0; i < bloc.nameFields.length; i++) {
    if(bloc.nameFields.value[i].value != null){
      visitorNames.add(bloc.nameFields.value[i].value);
    }
  }
  appValues["typeOfVisitor"] = typeOfVisitor;
  appValues["visitorName"] = visitorNames;
  appValues["whomToMeet"] = name;
  appValues["phoneNumber"] = phoneNumController.text;
  appValues["appointmentTime"] = date.toIso8601String();
  appValues["organizationName"] = companyController.text;
  appValues["instructions"] = instructionsController.text;
  appValues["username"] = name;
  if(noOfParkingSlots>0){
    appValues["noOfParkingSlots"] = noOfParkingSlots;
    if(isAdmin){
      List<String> parkingSlots = [];
      parkingSlots.add(parkingSlotsController.text);
      appValues["parkingSlots"] = parkingSlots;
      appValues["parkingSlotRejectReason"] = null;
    }else{appValues["status"] = "Pending";}
  }
  else{
    appValues["status"] = "Upcoming";
  }
  Map map = {"appointmentData":appValues};
  final response = await apiRequest(url, map);
  if(response.statusCode == 201){ return;}
}

postData(action,appointment) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var name = prefs.getString('username');
  String url;
  Map appValues = new Map();
  switch(action){
    case 'delete':
      url = UPDATE_APPOINTMENT;
      appValues["status"] = "Cancelled";
      break;
    case 'approve':
      url = APPROVE_APPOINTMENT;
      List<String> parkingSlots = [];
      parkingSlots.add(parkingSlotsController.text);
      appValues["status"] = "Pending";
      appValues["parkingSlots"] = parkingSlots;
      appValues["parkingSlotRejectReason"] = null;
      appValues["assets"] = null;
      appValues["attendedVisitors"] = null;
      appValues["inTime"] = null;
      appValues["noOfParkingSlots"]= appointment.noOfParkingSlots;
      appValues["outTime"]=null;
      appValues["visitorImage"]=null;
      break;
    case 'reject':
      url = REJECT_APPOINTMENT;
      appValues["parkingSlotRejectReason"] = rejectReasonController.text;
      break;
  }
  appValues["_id"] = appointment.id;
  appValues["typeOfVisitor"] = appointment.typeOfVisitor;
  appValues["visitorName"] = appointment.visitorName;
  appValues["whomToMeet"] = name;
  appValues["phoneNumber"] = appointment.phoneNumber;
  appValues["appointmentTime"] = appointment.appointmentTime;
  appValues["organizationName"] = appointment.organizationName;
  appValues["instructions"] = appointment.instructions;
  Map map = {"appointmentData":appValues};
  final response = await apiRequest(url, map);
  if(response.statusCode == 204){ return;}
}

resetAppForm(){
  visitorController = new TextEditingController();
  whomToMeetController = new TextEditingController();
  phoneNumController = new TextEditingController();
  companyController = new TextEditingController();
  instructionsController = new TextEditingController();
  parkingSlotsController = new TextEditingController();
  rejectReasonController = new TextEditingController();
  noOfParkingSlots = 0;
  typeOfVisitor = "Business Visitor";
  date = DateTime.now();
  bloc.nameFields.clear();
  bloc.nameFields.addElement(StreamedValue<String>());
}