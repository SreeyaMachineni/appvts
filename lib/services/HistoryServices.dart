import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:appvts/services/APIs.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:appvts/services/FetchAppointmentList.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<List<Appointment>> fetchHistory(http.Client client,String status,[String filterWith,String textKey,String fromDate,String toDate]) async {
  Map map;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var name = prefs.getString('username');
  if(name != null){
    name = name.replaceFirst(' ', '.');
    switch(status){
      case 'none':
        map = {"AppointmentData":{"endDate": null,"scope": "myhistory","searchkey": null,"sortField": "appointmentTime|desc","startDate": null,"status": null,"username":name}};
        if(filterWith == 'Date'){
          map = {"AppointmentData":{"startDate": fromDate,"endDate": toDate,"scope": "myhistory","searchkey": null,"sortField": "appointmentTime|desc","status": null,"username":name}};
        }else if(filterWith == 'textKey'){
          map = {"AppointmentData":{"startDate": null,"endDate": null,"scope": "myhistory","searchkey": textKey,"sortField": "appointmentTime|desc","status": "Cancelled","username":name}};
        }
        break;
      case 'Cancelled':
        map = {"AppointmentData":{"endDate": null,"scope": "myhistory","searchkey": null,"sortField": "appointmentTime|desc","startDate": null,"status": "Cancelled","username":name}};
        if(filterWith == 'Date'){
          map = {"AppointmentData":{"startDate": fromDate,"endDate": toDate,"scope": "myhistory","searchkey": null,"sortField": "appointmentTime|desc","status": "Cancelled","username":name}};
        }else if(filterWith == 'textKey'){
          map = {"AppointmentData":{"startDate": null,"endDate": null,"scope": "myhistory","searchkey": textKey,"sortField": "appointmentTime|desc","status": "Cancelled","username":name}};
        }
        break;
      case 'Visited':
        map = {"AppointmentData":{"endDate": null,"scope": "myhistory","searchkey": null,"sortField": "appointmentTime|desc","startDate": null,"status": "Visited","username":name}};
        if(filterWith == 'Date'){
          map = {"AppointmentData":{"startDate": fromDate,"endDate": toDate,"scope": "myhistory","searchkey": null,"sortField": "appointmentTime|desc","status": "Visited","username":name}};
        }else if(filterWith == 'textKey'){
          map = {"AppointmentData":{"startDate": null,"endDate": null,"scope": "myhistory","searchkey": textKey,"sortField": "appointmentTime|desc","status": "Cancelled","username":name}};
        }
        break;
    }
    final response = await apiRequest(GET_APPOINTMENTS, map);
    return parseAppointments(response.body);
  }
}