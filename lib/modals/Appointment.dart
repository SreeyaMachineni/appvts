class Appointment{
  final String id;
  final String typeOfVisitor;
  final List<String> visitorName;
  final String whomToMeet;
  final int phoneNumber;
  final String appointmentTime;
  final String organizationName;
  final  String instructions;
  final int noOfParkingSlots;
  final String status;
  List<String> parkingSlots;
  String parkingSlotsRejectionReason;
  String CreatedBy;


  Appointment({this.id,this.typeOfVisitor,this.visitorName,this.whomToMeet,this.phoneNumber,this.appointmentTime,this.organizationName,
    this.noOfParkingSlots,this.instructions,this.parkingSlots,this.parkingSlotsRejectionReason,this.status
  });

  factory Appointment.fromJson(Map<String, dynamic> json){
    return Appointment(
        id:json['_id'] as String,
        status:json['status'] as String,
        typeOfVisitor: json['typeOfVisitor'] as String,
        visitorName: json['visitorName'] != null ? List<String>.from(json['visitorName']) : null,
    whomToMeet: json['whomToMeet'] as String,
    organizationName:json['organizationName'] as String,
    instructions: json['instructions'] as String,
    parkingSlots: json['parkingSlots'] != null ? List<String>.from(json['parkingSlots']) : null,
    phoneNumber: json['phoneNumber'] != null ? int.tryParse(json['phoneNumber']) : null,
    noOfParkingSlots: json['noOfParkingSlots'] != null ? json['noOfParkingSlots'].toInt() : null,
    appointmentTime:json['appointmentTime'] as String,
    );
  }
}