import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:appvts/Globals.dart';
import 'package:appvts/screens/Home.dart';
import 'package:appvts/widgets/Styles.dart';
import 'package:appvts/screens/Filters.dart';
import 'package:appvts/modals/Appointment.dart';
import 'package:appvts/services/HistoryServices.dart';
import 'package:appvts/widgets/AppointmentListView.dart';

class History extends StatefulWidget{
  //this'll receive params from filters page to filter based on date
  String fromDate;
  String toDate;
  DateTime fromDateFilter;
  DateTime toDateFilter;
  History({this.fromDate,this.toDate,this.fromDateFilter,this.toDateFilter});

  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> with SingleTickerProviderStateMixin{
  TabController tabController;
  String fromDateStr;
  String toDateStr;
  bool searchWithText = false;
  String searchText;
  String filterWith;
  TextEditingController textFilter =new TextEditingController();

  HistoryState(){
    textFilter.addListener(() {
      if (textFilter.text.isEmpty) {
        setState(() {
          searchText = "";
        });
      } else {
        setState(() {
          searchText = textFilter.text;
          print(searchText);

        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    filterWith = 'Date';
    if(isSearchHistory == true){
      var formatter = new DateFormat('dd-MM-yyyy');
      fromDateStr  = formatter.format(widget.fromDateFilter);
      toDateStr = formatter.format(widget.toDateFilter);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: (!searchWithText)?
          ListTile(
            leading: InkWell(
              onTap: (){
                isSearchHistory = false;
                changeAppointment=true;
                Navigator.push(context,MaterialPageRoute(builder: (context) => Home()));
              },
              child: Icon(Icons.arrow_back,color: Colors.black,),
            ),
            title: getHistoryTitle(),
            subtitle: (isSearchHistory) ? Text('$noOfRecs records found') : null,
          ):
          ListTile(
            leading: InkWell(
              onTap: (){
                setState(() {
                  searchWithText = false;
                });
              },
              child: Icon(Icons.arrow_back,color: Colors.black,),
            ),
            title: TextField(
              controller: textFilter,
              decoration: new InputDecoration(
                  prefixIcon: new Icon(Icons.search),
                  hintText: 'Search...'
              ),
            ),
          ),
        actions: (!isSearchHistory && !searchWithText)?<Widget>[
          InkWell(
            onTap: (){
              filterWith = 'Date';
              Navigator.push(context,MaterialPageRoute(builder: (context) => Filters(from:'History')));
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 20, 0),
              child: Image.asset('assets/filter.png', width: 20),
            ),
          ),
          InkWell(
              onTap: (){
               setState(() {
                 searchWithText = true;
                 filterWith="textKey";
               });
              },
              child:Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Image.asset('assets/search.png', width: 20),
              )
          )
        ]:null,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('All',style: TextStyle(color: Colors.black),),),
              Tab(child: Text('Visited',style: TextStyle(color: Colors.black),),),
              Tab(child: Text('Cancelled',style: TextStyle(color: Colors.black),),)
            ],
            indicatorColor: appColor,
            controller: tabController,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            FutureBuilder<List<Appointment>>(
              future: (isSearchHistory || searchWithText) ?fetchHistory(http.Client(),'none',filterWith,searchText,fromDateStr,toDateStr) : fetchHistory(http.Client(),'none'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? AppointmentList(photos: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },

            ),
            FutureBuilder<List<Appointment>>(
              future:(isSearchHistory || searchWithText) ?fetchHistory(http.Client(),'Visited',filterWith,searchText,fromDateStr,toDateStr) : fetchHistory(http.Client(),'Visited'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? AppointmentList(photos: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
            FutureBuilder<List<Appointment>>(
              future: (isSearchHistory || searchWithText) ?fetchHistory(http.Client(),'Cancelled',filterWith,searchText,fromDateStr,toDateStr) :fetchHistory(http.Client(),'Cancelled'),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);
                return snapshot.hasData
                    ? AppointmentList(photos: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            )
          ],
        ),
      ),
    );
  }

  getHistoryTitle(){
    if(isSearchHistory){
      return Text(widget.fromDate.toString()+' - '+widget.toDate.toString());
    }
    else {
      return Text('History');
    }
  }
}