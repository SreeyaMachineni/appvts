import 'package:flutter/material.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/services/AppTileServices.dart';
import 'package:appvts/Globals.dart';
import 'package:appvts/screens/History.dart';

class Filters extends StatefulWidget{
  final String from;
  Filters({this.from});
  @override
  FiltersState createState() => FiltersState();
}

String fromDay = DateTime.now().day.toString();
String toDay = DateTime.now().day.toString();
String fromMonthYear = months[DateTime.now().month - 1] + ' '+ DateTime.now().year.toString().substring(2);
String toMonthYear = months[DateTime.now().month - 1] + ' '+ DateTime.now().year.toString().substring(2);
class FiltersState extends State<Filters>{
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: ListTile(
              leading:
              InkWell(
                onTap: (){ Navigator.pop(context);},
                child: Icon(Icons.arrow_back),
              ),
              title: Text('Filters',style: F16CBlackMR,),
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
          ),
          body:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('From',style: F16CBlackMR,),
                        InkWell(
                          onTap: () async {
                            fromDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101)
                            );
                            setState(() {
                              fromDay = fromDate.day.toString();
                              fromMonthYear = months[fromDate.month - 1] + ' '+ fromDate.year.toString().substring(2);
                            });
                          },
                          child: Text(fromDay,style: filterDay,),
                        ),
                        Text(fromMonthYear,style: NoAppointments,),
                      ],
                    ),
                    new Container(
                      height: 100.0,
                      width: 0.7,
                      color: Colors.black,
                    ),
                    Column(
                      children: <Widget>[
                        Text('To',style: F16CBlackMR,),
                        InkWell(
                          onTap: () async {
                            toDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101)
                            );
                            setState(() {
                              toDay = toDate.day.toString();
                              toMonthYear = months[toDate.month - 1] + ' '+ toDate.year.toString().substring(2);
                            });
                          },
                          child: Text(toDay,style: filterDay,),
                        ),
                        Text(toMonthYear,style: NoAppointments,),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child:  Text('SEARCH',style: F14CWhiteMM,),
                        onPressed: (){
                          isSearchHistory = true;
                          String fromHistoryHeader = fromDay+' '+fromMonthYear.substring(0,1).toUpperCase()+fromMonthYear.substring(1).toLowerCase();
                          String toHistoryHeader =toDay+' '+toMonthYear.substring(0,1).toUpperCase()+toMonthYear.substring(1).toLowerCase();
                            Navigator.push(context,MaterialPageRoute(builder: (context) => History(fromDate: fromHistoryHeader,toDate: toHistoryHeader,
                                fromDateFilter:fromDate,toDateFilter:toDate
                            )));
                        },
                        color: appColor,
                      )
                    ],
                  )
              )
            ],
          )
      ),
    );
  }
}