import 'package:appvts/Globals.dart';
import 'package:flutter/material.dart';
import 'package:appvts/services/Bloc.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/modals/Appointment.dart';


class FieldsWidget extends StatefulWidget{
  Appointment appointment;
  int index;
  TextEditingController nameController;

  FieldsWidget({
    this.appointment,
    this.index,
    this.nameController,
  });

  @override
  FieldsWidgetState createState() => FieldsWidgetState();
}

bool isMore = false;
class FieldsWidgetState extends State<FieldsWidget> {
  String listOfNames = '';
  int noOfVisitors;
  @override
  void initState() {
    String listOfNames = '';
    super.initState();
    if(isView){
      noOfVisitors = widget.appointment.visitorName.length;
      listOfNames = widget.appointment.visitorName[0];
      if(noOfVisitors > 1){
        isMore = true;
      }
      widget.nameController = new TextEditingController(text:listOfNames);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              StreamBuilder<String>(
                  initialData: ' ',
                  stream: bloc.nameFields.value[widget.index].outStream,
                  builder: (context, snapshot) {
                    return
                      Padding(
                          padding:EdgeInsets.only(right:10),
                          child:
                          TextField(
                            enabled: !isView,
                            controller: widget.nameController,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(fontSize: 16,color: hintColor),
                                labelText: 'Visitor Name',
                                contentPadding: EdgeInsets.all(5),
                                errorText: snapshot.error,
                                suffixIcon:
                                (widget.index >0) ? IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => bloc.removeFields(widget.index),
                                ):null
                            ),
                            onChanged: bloc.nameFields.value[widget.index].inStream,
                          )
                      );
                  }),
            ],
          ),
        ),
      ],
    );
  }
}