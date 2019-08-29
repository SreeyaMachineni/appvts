import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:appvts/services/APIs.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appvts/services/FetchAppointmentList.dart';

Future<List<Appointment>> fetchAdminAppointments(http.Client client,String status,[String filterWith,String textKey,String fromDate,String toDate]) async {
  Map map;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var name = prefs.getString('username');
  if(name != null){
    name = name.replaceFirst(' ', '.');
    switch(status){
      case 'allApps':
        map = {"AppointmentData":{"endDate": null,"scope": "all","searchkey": null,"sortField": "appointmentTime|desc","startDate": null,"status": null}};
        break;
      case 'Pending':
        map = {"AppointmentData":{"status":"Pending","pageNo": 1,"sortField":"appointmentTime|asc","scope": "all","startDate": null,"endDate": null,}};
        break;
    }
    final response = await apiRequest(GET_APPOINTMENTS, map);
    return parseAppointments(response.body);
  }

}