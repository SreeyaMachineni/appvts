import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:appvts/Globals.dart';
import 'package:frideos/frideos.dart';
import 'package:appvts/screens/Home.dart';
import 'package:appvts/services/Bloc.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:frideos_core/frideos_core.dart';
import 'package:appvts/screens/AdminHome.dart';
import 'package:appvts/services/AppFormServices.dart';
import 'package:appvts/widgets/DynamicTextFields.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

Appointment app;
class AppForm extends StatefulWidget {
  final String action;
  final Appointment appointment;
  bool needParking = false;
  bool parkingSlots = false;
  AppForm({this.action,this.appointment});
  @override
  AppFormState createState() => AppFormState();
}

String heading = "";
int noOfParkingSlots = 0;
String typeOfVisitor = "Business Visitor";
TextEditingController visitorController;
TextEditingController whomToMeetController;
TextEditingController phoneNumController;
TextEditingController companyController;
TextEditingController instructionsController;
TextEditingController parkingSlotsController = new TextEditingController();
TextEditingController rejectReasonController =new TextEditingController();
TextEditingController dateController;
DateTime date;

class AppFormState extends State<AppForm> {
  bool isValid=false;
  bool showErr = false;
  final nameFieldsController = List<TextEditingController>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    switch(widget.action){
      case 'create':
        resetAppForm();
        break;
      case 'edit':
        visitorController = new TextEditingController(text:widget.appointment.visitorName[0]);
        whomToMeetController = new TextEditingController(text:widget.appointment.whomToMeet);
        phoneNumController = new TextEditingController(text:widget.appointment.phoneNumber.toString());
        companyController = new TextEditingController(text:widget.appointment.organizationName);
        instructionsController = new TextEditingController(text:widget.appointment.instructions);
        date = DateTime.parse(widget.appointment.appointmentTime);
        typeOfVisitor = widget.appointment.typeOfVisitor;
        if(widget.appointment.noOfParkingSlots > 0){
          widget.needParking = true;
          noOfParkingSlots = widget.appointment.noOfParkingSlots;
          widget.parkingSlots = true;
        }
        bloc.nameFields.clear();
        widget.appointment.visitorName.forEach((str) {
          bloc.newFieldsEdit(str);
        });
        break;
    }

  }
  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
  };
  InputType inputType = InputType.both;

  @override
  Widget build(BuildContext context) {
    //building and initializing text fields for name when the user takes edit
    List<Widget> _buildFields(int length) {
      nameFieldsController.clear();
      for (int i = 0; i < length; i++) {
        final name = bloc.nameFields.value[i].value;
        nameFieldsController.add(TextEditingController(text: name));
      }
      return List<Widget>.generate(length,
        (i) => FieldsWidget(appointment: widget.appointment,index: i,nameController: nameFieldsController[i],),
      );
    }
    // TODO: implement build
    return MaterialApp(
            theme: ThemeData(
                   inputDecorationTheme: InputDecorationTheme(
                       labelStyle: TextStyle(color: hintColor),hintStyle: TextStyle(color: hintColor),
                       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: appColor,width: 2))
                    )
            ),
            home: Scaffold(
              appBar: AppBar(
                title: ListTile(
                  leading: InkWell(
                    onTap: (){ Navigator.pop(context); },
                    child: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  title: Text(getHdgn(widget.action),style: F16CBlackMR),
                  trailing:editDelete(widget.action),
                ),
                backgroundColor: headerColor,
              ),
              body: Form(
                key: formKey,
                child: ListView(
                  children: <Widget>[
                    // generating a text field for Name(multiple)
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: ValueBuilder<List<StreamedValue<String>>>(
                        streamed: bloc.nameFields,
                        builder: (context, snapshot) {
                          return Column(children: _buildFields(snapshot.data.length));
                        },
                        noDataChild: const Text(' '),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //validates name
                        (showErr)?
                            Padding(
                              padding:EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child:Text('Please enter name',style: TextStyle(color: Colors.red),)
                            ):Text(''),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                              child:
                              InkWell(
                                  onTap: ()=> bloc.newFields(),
                                  child:Text('Add another visitor',style:TextStyle(color:appColor))
                              )
                            )
                        ],
                    ),
                    // type of visitor dropdown
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: DropdownButtonFormField<String>(
                        hint:Text('Type of Visitor'),
                        value: typeOfVisitor,
                        onChanged: (String newValue) {
                          setState(() { typeOfVisitor = newValue; });
                        },
                        items: <String>['Business Visitor', 'Interview CAndidate', 'Personal Visitor', 'Vendor']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    //textfield for company
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        controller: companyController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 16,color: hintColor),
                            labelText: 'Company Name',
                            contentPadding: EdgeInsets.all(5)
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return 'Enter Company Name';
                          }
                        },
                      ),
                    ),
                    //textfield for whom to meet
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        controller: whomToMeetController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 16,color: hintColor),
                            labelText: 'Whom To Meet',
                            contentPadding: EdgeInsets.all(5)
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return 'Enter Whom To Meet';
                          }
                        },
                      ),
                    ),
                    //textfield for Phone
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        controller: phoneNumController,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 16,color: hintColor),
                            labelText: 'Phone Number',
                            contentPadding: EdgeInsets.all(5)
                        ),
                        validator: (value){
                          if(value.isEmpty){
                            return 'Enter Phone Number';
                          }
                        },
                      ),
                    ),
                    //textfield for instructions
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: TextFormField(
                        controller: instructionsController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 16,color: hintColor),
                          labelText: 'Instructions',
                          contentPadding: EdgeInsets.all(5),
                        ),
                      ),
                    ),
                    //datepicker
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: DateTimePickerFormField(
                          initialValue: date,
                          inputType: inputType,
                          format: formats[inputType],
                          editable: false,
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(borderSide: new BorderSide(color: Colors.red)),
                              hintStyle: TextStyle(fontSize: 16,color: hintColor),
                              labelText: 'Date/Time',
                              contentPadding: EdgeInsets.all(5)
                          ),
                          onChanged: (dt) {
                            setState(() { date = dt;});
                          }
                      ),
                    ),
                    //dropdown for parking slots
                    Padding(
                        padding:EdgeInsets.fromLTRB(10,0, 10, 10),
                        child:  DropdownButtonFormField<int>(
                          //labelText: 'No of Parking Slots',
                          value: noOfParkingSlots,
                          onChanged: (int newValue) {
                            setState(() {
                              noOfParkingSlots = newValue;
                            });
                          },
                          items: <int>[0,1,2,3,4]
                              .map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        )
                    ),
                    //textfield for parking slots
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, MediaQuery.of(context).viewInsets.bottom),
                        child: (isAdmin)?TextFormField(
                          controller: parkingSlotsController,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 16,color: hintColor),
                            labelText: 'Parking Slots',
                            contentPadding: EdgeInsets.all(5),
                          ),
                          validator: (value){
                          if(noOfParkingSlots > 0){
                            if(value.isEmpty){
                              return 'Enter parking slots';
                            }
                            else if(value.allMatches(',').length < noOfParkingSlots-1){
                              return 'please enter the required parking slots';
                            }
                          }
                          },
                        ) :Text(''),
                    )
                  ],
                ),
              ),
              resizeToAvoidBottomInset: false,
              bottomNavigationBar:
              createApp(widget.action),
            ),
          );
  }
  editDelete(String action){
    if(action == 'view' && isFirstTab){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: ()
            {
              isView = false;
              isEdit = true;
              Navigator.push(context, MaterialPageRoute(builder: (context) => AppForm(action: 'edit', appointment: widget.appointment)),
              );
            },
            child:Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Icon(Icons.edit,color: Colors.black),
            ),
          ),
          InkWell(
            onTap: (){
              postData('delete',widget.appointment);
              Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Icon(Icons.delete,color: Colors.black),
            ),
          )
        ],
      );
    }
    else if(action == 'view' && !isFirstTab){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: ()
            {
              showDialog(context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Approve'),
                      content: TextFormField(
                        controller: parkingSlotsController,
                        decoration: InputDecoration(
                          //   hintText: "Phone Number",
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
                              postData('approve', widget.appointment);
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
          ),
          InkWell(
            onTap: (){
              showDialog(context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text('Reject'),
                      content: TextFormField(
                        controller: rejectReasonController,
                        decoration: InputDecoration(
                          //   hintText: "Phone Number",
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
          )
        ],
      );
    }
  }


  getCompanyName(String action,Appointment app){
    if(action == 'view'){
      return app.visitorName;
    }
    return null;
  }

  getHdgn(String action){
    if(action == 'view'){
      heading = 'View Appointment';
    }
    else if(action == 'edit'){
      heading = 'Edit Appointment';
    }
    else{
      heading = 'New Appointment';
    }
    return heading;
  }

  createApp(String action){
    if(action == 'view'){
      return null;
    }
    return BottomAppBar(
      child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: (){
                    if(widget.action == 'edit'){
                      createOrEdit(widget.appointment,'edit',widget.needParking);
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
                    }
                    else{
                      if(_validateInputs()){
                        createOrEdit(widget.appointment,'create',widget.needParking);
                        Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
                      }
                    }
                  },
                  child:Text(getButtonText(widget.action),style: F14CWhiteMR,)
              )
            ],
          )
      ),
      color: appColor,
    );
  }

  getButtonText(String action){
    String text = "Create Appointment";
    if(action == 'edit'){
      text = 'Done';
    }
    return text;
  }

  checkForm(){
    int len = bloc.nameFields.length;
   for(int i=0;i<len;i++){
     if(bloc.nameFields.value[i].value != null){
       break;
     }
     if(!isValid){
       setState(() {
         showErr = true;
       });
     }else{
         setState(() {
           showErr = false;
         });
     }
   }
   return isValid;
  }

   _validateInputs() {
     int len = bloc.nameFields.length;
     for(int i=0;i<len;i++){
       if(bloc.nameFields.value[i].value != null){
         isValid=true;
         break;
       }
     }
     if(!isValid){
       setState(() {
         showErr = true;
       });
     }else{
       setState(() {
         showErr = false;
       });
     }
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if(isValid){
        return true;
      }
    } else {
      return false;
    }
  }

}

TextFormField getTextfield(name,controller){
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(labelText: name),
    validator: (value){
      if(value.isEmpty){
        return 'enter'+name;
      }
    },
  );
}
