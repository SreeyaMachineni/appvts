import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:appvts/Globals.dart';
import 'package:appvts/services/APIs.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<List<Appointment>> fetchAppointmentsList(http.Client client,String status,[String filterWith,String textKey,String fromDate,String toDate]) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var name = prefs.getString('username');
  if(name != null){
    name = name.replaceFirst(' ', '.');
    Map map;
    switch(status){
      case 'all':
        map = {"AppointmentData":{"scope":"mine","pageNo": 1,"sortField":"appointmentTime|asc","username":name}};
        break;
      case 'Upcoming':
        map = {"AppointmentData":{"status":"Upcoming","scope":"mine","pageNo": 1,"sortField":"appointmentTime|asc","username":name}};
        break;
    }
    final response = await apiRequest(GET_APPOINTMENTS, map);
    return parseAppointments(response.body);
  }

}

Future<http.Response> apiRequest (String url,Map data) async {
  var body = json.encode(data);
  var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body );
  return response;
}

List<Appointment> parseAppointments(String responseBody) {
  final parsedj = json.decode(responseBody);
  Map<String, dynamic> map = jsonDecode(responseBody);
  noOfRecs = parsedj['appointmentsCount'];
  final parsejApps = parsedj['appointments'];
  final parsed = parsejApps.cast<Map<String, dynamic>>();
  return parsed.map<Appointment>((json) => Appointment.fromJson(json)).toList();
}
