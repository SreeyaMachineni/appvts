import 'package:flutter/material.dart';
List<String> months = ["JANUARY","FEBRUARY","MARCH","APRIL","MAY","JUNE","JULY","AUGUST","SEPTEMBER","OCTOBER","NOVEMBER","DECEMBER"];
String getAppDate(appDate){
  List<String> dayOfWeek = ["MON","TUE","WED","THU","FRI","SAT","SUN"];
  var parsedDate = DateTime.parse(appDate);
  String weekDay = dayOfWeek[parsedDate.weekday - 1];
  String month = months[parsedDate.month-1];
  String year = parsedDate.year.toString();
  String appointmentTime = weekDay + ', ' + parsedDate.day.toString() + '-' + month.substring(0,3) + '-' + year;
  return appointmentTime;
}

String getAppTime(appTime){
  TimeOfDay appmntTime = TimeOfDay.fromDateTime(DateTime.parse(appTime));
  String appointmentTime = appmntTime.hour.toString() + ':' + appmntTime.minute.toString()+appmntTime.period.toString().substring(appmntTime.period.toString().indexOf('.')+1);
  return appointmentTime;
}

bool parkingSlotsAvailable = false;
Color parkingStatus = Colors.transparent;
showOrHide(parkingSlots,parkingSlotsRejectionReason){
  if (parkingSlots >0){
    if(parkingSlotsRejectionReason == null){
      parkingSlotsAvailable = false;
    }
    else{
      parkingSlotsAvailable = true;
    }
    return 1.0;
  }
  return 0.0;
}

getColor(parkingSlotRejected){
  if(parkingSlotRejected != null){
    return Colors.red;
  }
  if(parkingSlotsAvailable){
    return Colors.green;
  }
  else{
    return Colors.grey;
  }


}

getInitials(String name){
  String initial;
  if(name.trim().length > 0){
    List<String> names = name.trim().split(" ");
    if(names.length > 1){
      initial = (names[0].substring(0,1) + names[names.length - 1].substring(0,1)).toUpperCase();
    }
    else {
      initial = names[0].substring(0,1).toUpperCase();
    }
    return initial;
  }
  return ' ';
}

getParkingStatusImage(noOfParkingSlots,parkingSlotsRejectionReason,parkingSlots,status){
  if(noOfParkingSlots > 0){
    if(status == 'Reverted'){
      return Image.asset('assets/ParkingRejected.png', width: 25,);
    }
    else if(parkingSlots != null){
      return Image.asset('assets/ParkingAvailable.png', width: 25,);
    }
    else{
      return Image.asset('assets/parkingPending.png', width: 25,);
    }

  }

}


getParkingStatus(noOfParkingSlots,parkingSlotsRejectionReason,parkingSlots,status){
  if(noOfParkingSlots > 0){
    if(status == 'Reverted'){
      parkingStatus = Colors.red;
      return 'Parking Unavailable';
    }
    else if(parkingSlots != null){
      parkingStatus = Colors.green;
      return 'Parking Available';
    }
    else{
      parkingStatus = Colors.grey;
      return 'Parking Pending';
    }
  }
  return ' ';

}

