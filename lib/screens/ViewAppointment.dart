import 'package:flutter/material.dart';
import 'package:appvts/Globals.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/screens/AppForm.dart';
import 'package:appvts/screens/AdminHome.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:appvts/services/AppTileServices.dart';
import 'package:appvts/services/AppFormServices.dart';
import 'package:appvts/services/FetchAppointmentList.dart';

class ViewAppointment extends StatefulWidget{
  final Appointment appointment;
  ViewAppointment({this.appointment});
  @override
  ViewAppointmentState createState() => ViewAppointmentState();
}

class ViewAppointmentState extends State<ViewAppointment>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    int noOfVisitors = widget.appointment.visitorName.length - 1;
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title:
              ListTile(
                  leading:
                  InkWell(
                    onTap: (){  Navigator.pop(context); },
                    child: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  title: Text('View Appointment',style: F16CBlackMR),
                  //do not allow user to change appointment in history.
                  trailing:(changeAppointment)? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getEditOrApproveIcon(),
                      getDeleteOrRejectIcon()
                    ],
                  ):null
              ),
              backgroundColor: headerColor,

            ),
            body:


            Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child:  ListView(
                      children:
                      [
                        ListTile(
                            title: Text('Type of visitor',style: ViewHintStyle,),
                            subtitle: Text(widget.appointment.typeOfVisitor,style: F16CBlackMR,),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ),
                        //Divider(color: hintColor,height: 1),
                        new SizedBox(
                          height: 10.0,
                          child: new Center(
                            child: new Container(
                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                              height: 0.8,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ListTile(
                            title: Text('Visitors',style: ViewHintStyle,),
                            subtitle: Text(widget.appointment.visitorName[0],style: F16CBlackMR,),
                            trailing:
                            (noOfVisitors >= 1) ?   InkWell(
                              onTap: (){
                                showDialog(context: context,
                                    builder: (BuildContext context){
                                      return AlertDialog(
                                          title: ListTile(
                                            leading: Text('Visitors'+'('+(noOfVisitors+1).toString()+')',style: F16CBlackMR,),
                                            trailing:
                                            InkWell(
                                                child: Icon(Icons.clear),
                                                onTap: (){Navigator.of(context).pop();}
                                            ),
                                          ),
                                          content:
                                          Container(
                                            /*height: 500.0, // Change as per your requirement
                                  width: 300.0,*/
                                            width: MediaQuery.of(context).size.width,
                                            //  height: MediaQuery.of(context).size.height - 48.0,
                                            child: new ListView.builder(
                                              itemCount: widget.appointment.visitorName.length,
                                              itemBuilder: (BuildContext buildContext, int index) =>
                                              //new Text(widget.appointment.visitorName[index]),
                                              ListTile(
                                                leading: CircleAvatar(
                                                  radius:27,
                                                  backgroundColor: nameAvatarColor,
                                                  child: Text(
                                                    //'SM',
                                                      getInitials(widget.appointment.visitorName[index]),
                                                      style: NameAvatar),
                                                ),
                                                title: Text(widget.appointment.visitorName[index]),
                                              ),
                                              shrinkWrap: true,
                                            ),
                                          )
                                      );
                                    });
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text('+'+noOfVisitors.toString(),style: moreStyle),
                              ),
                            ) : null,



                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ),
                        // Divider(color: hintColor,height: 1,),
                        new SizedBox(
                          height: 10.0,
                          child: new Center(
                            child: new Container(
                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                              height: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ListTile(
                            title: Text('Company Name',style: ViewHintStyle,),
                            subtitle: Text(widget.appointment.organizationName,style: F16CBlackMR,),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)

                        ),
                        //Divider(color: hintColor,height: 1,),
                        new SizedBox(
                          height: 10.0,
                          child: new Center(
                            child: new Container(
                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                              height: 0.8,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ListTile(
                            title: Text('Whom to meet',style: ViewHintStyle,),
                            subtitle: Text(widget.appointment.whomToMeet,style: F16CBlackMR,),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ),
                        //Divider(color: hintColor,height: 1,),
                        new SizedBox(
                          height: 10.0,
                          child: new Center(
                            child: new Container(
                              margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                              height: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        ListTile(
                            title: Text('Phone number',style: ViewHintStyle,),
                            subtitle: Text(widget.appointment.phoneNumber.toString(),style: F16CBlackMR,),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)

                        ),
                        Divider(color: hintColor,height: 1,),
                        ListTile(
                            title: Text('Appointment time',style: ViewHintStyle,),
                            subtitle: Text(widget.appointment.appointmentTime,style: F16CBlackMR,),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ),
                        Divider(color: hintColor,height: 1,),
                        ListTile(
                            title: Text('Instructions',style: ViewHintStyle,),
                            subtitle: Text(widget.appointment.instructions,style: F16CBlackMR,),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)

                        ),
                        (widget.appointment.noOfParkingSlots > 0)? Divider(color: hintColor,height: 1,):Divider(color: Colors.transparent,height: 1,),
                        (widget.appointment.noOfParkingSlots > 0) ?ListTile(
                          title: Text('Car Parking',style: F16CBlackMR),
                          trailing: getStatusOfParking(widget.appointment.parkingSlots, widget.appointment.status),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ):Text(''),
                        (widget.appointment.noOfParkingSlots > 1)?Divider(color: hintColor,height: 1,):Divider(color: Colors.transparent,height: 1,),
                        (widget.appointment.noOfParkingSlots > 1)?ListTile(
                          title: Text('Parking Slots Requested',style: F16CBlackMR),
                          trailing: Text(widget.appointment.noOfParkingSlots.toString()),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ):Text(''),
                        (widget.appointment.status == 'Reverted')?Divider(color: hintColor,height: 1,):Divider(color: Colors.transparent,height: 0,),
                        (widget.appointment.status == 'Reverted')?ListTile(
                            title: Text('Rejection Reason'),
                            trailing: Text(widget.appointment.parkingSlotsRejectionReason.toString()),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ):Text(''),
                        (widget.appointment.parkingSlots != null)? Divider(color: hintColor,height: 1,):Text(''),
                        (widget.appointment.parkingSlots != null)?ListTile(
                            title: Text('Parking Slots',style: F16CBlackMR),
                            trailing: getParkingSlots(widget.appointment.parkingSlots),
                            contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0)
                        ):Text(''),
                      ]
                  ),
                )
            )
        )
    );
  }
  getParkingSlots(parkingSLots){
    String slots='';
    for(var i in parkingSLots){
      slots=slots+i+',';
    }
    slots = slots.substring(0,slots.length-1);
    return Text(slots);
  }
  getStatusOfParking(parkingSlots,status){
    if(status == 'Reverted'){
      return Text('Unavailable');
    }else if(status == 'Pending'){
      return Text('Pending');
    }else{
      return Text('Approved');
    }
  }
  getEditOrApproveIcon(){
    return
      (adminEdit) ?InkWell(
        onTap: ()
        {
          showDialog(context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Approve'),
                  content: TextFormField(
                    controller: parkingSlotsController,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 16,color: hintColor),
                        labelText: 'Parking Slots',
                        contentPadding: EdgeInsets.all(5)
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter Parking slots';
                      }
                    },

                  ),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed:(){Navigator.of(context).pop();} ,
                        child: Text('close')
                    ),
                    new FlatButton(
                        onPressed: (){
                          isFirstTab = true;
                          postData('approve',widget.appointment);
                          Navigator.push(context,MaterialPageRoute(builder: (context) => AdminHome()));
                        },
                        child: Text('Approve')
                    ),
                  ],
                );
              }
          );

        },
        child:Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Icon(Icons.assignment_turned_in,color: Colors.black),
        ),
      ): InkWell(
        onTap: ()
        {
          Navigator.push(context,MaterialPageRoute(builder: (context) => AppForm(action: 'edit', appointment: widget.appointment)),
          );
        },
        child:Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Image.asset('assets/edit.png', width: 15),
        ),
      );
  }

  getDeleteOrRejectIcon(){
    return
      (adminEdit) ?
      InkWell(
        onTap: (){
          showDialog(context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('Reject'),
                  content: TextFormField(
                    controller: rejectReasonController,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontSize: 16,color: hintColor),
                        labelText: 'Parking Rejection reason',
                        contentPadding: EdgeInsets.all(5)
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Enter reason for rejecting parking';
                      }
                    },
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed:(){Navigator.of(context).pop();} ,
                        child: Text('close')
                    ),
                    new FlatButton(
                        onPressed: (){
                          isFirstTab = true;
                          postData('reject', widget.appointment);
                          Navigator.push(context,MaterialPageRoute(builder: (context) => AdminHome()));
                        },
                        child: Text('Reject')
                    ),
                  ],
                );
              }
          );

        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Icon(Icons.close,color: Colors.black),
        ),
      ):
      PopupMenuButton<String>(
        itemBuilder: (context)=>[
          PopupMenuItem(
            child: Text('Delete'),
            value: 'Delete',
          )
        ],
        onSelected: (value){
          showDialog(context: context,
              builder: (BuildContext context)
              {
                return AlertDialog(
                    title: Text('Delete Appointment ?',style: F16CGreyMR,),
                    content:
                    Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 15, 10, 0),
                            child: InkWell(
                              child: Text('CANCEL',style: AppColorRM14,),
                              onTap: (){Navigator.of(context).pop();},
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              child:  InkWell(
                                child: Text('DELETE',style: AppColorRM14,),
                                onTap: (){
                                  postData('delete', widget.appointment);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              )
                          )
                        ],
                      ),
                    )
                );
              }
          );
        },
      );
  }

  RejectPost() async{
    String url = 'http://192.168.1.85:92/VTS-UAT-CoreService/api/Appointment/rejectAppointmentNew';
    Map appValues = new Map();
    appValues["_id"] = widget.appointment.id;
    appValues["typeOfVisitor"] = widget.appointment.typeOfVisitor;
    appValues["visitorName"] = widget.appointment.visitorName;
    appValues["whomToMeet"] = "Sreeya Machineni";
    appValues["phoneNumber"] = widget.appointment.phoneNumber;
    appValues["appointmentTime"] = widget.appointment.appointmentTime;
    appValues["organizationName"] = widget.appointment.organizationName;
    appValues["instructions"] = widget.appointment.instructions;
    appValues["parkingSlots"] = widget.appointment.parkingSlots;
    appValues["parkingSlotRejectReason"] = rejectReasonController.text;
    Map map = {"appointmentData":appValues};
    final response = await apiRequest(url, map);
    if(response.statusCode == 204){ return;}
    return;

  }
}