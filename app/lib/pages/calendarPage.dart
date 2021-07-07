import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/localization/localization.dart';
import '../url_api.dart';

class CalendarPage extends StatefulWidget  {
  final String currentLang;
  CalendarPage({this.currentLang});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin{

  List holidayList = new List();
  List holidayListMonth = new List();
  String currentFont='Khmer';

  Map<DateTime, List> _events = Map();
  Map<DateTime, List> _eventsByMonth = Map();
  AnimationController _animationController;
  CalendarController _calendarController;
  bool isLoading=true;
  @override
  void initState() {
    _getJsonData();
    _onVisibleDaysChanged;
    super.initState();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

//  @override
//  void dispose() {
//    _animationController.dispose();
//    _calendarController.dispose();
//    super.dispose();
//  }

//  void _onDaySelected(DateTime day, List events) {
//    print('CALLBACK: _onDaySelected'+day.toString()+'-events: '+events.toString());
//    setState(() {
////      _selectedEvents = events;
//    });
//  }

  void _onVisibleDaysChanged (DateTime first, DateTime last, CalendarFormat format) async{

    String dateString = (DateFormat('yyyy-MM-dd').format(first)).toString();
    final String urlApi = StringData.getDateHoliday+'&mothHoliday='+dateString+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState((){
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          setState(() {
            isLoading=false;
            holidayListMonth = json.decode(rawData.body)['result'] as List;
          });
        }
      });
    }

  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
  }

  _getJsonData() async{
    final String urlApi = StringData.calendar+'&cateId=3';
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          holidayList = json.decode(rawData.body)['result'] as List;
          String _lblHoliday ;
          setState(() {
            currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
            for(var i= 0;i< holidayList.length;i++){
              _lblHoliday = holidayList[i]['title_en'].toString();
              _events[DateTime.parse(holidayList[i]['date'])]=[_lblHoliday];
              DateTime tempDate = new DateFormat("yyyy-MM").parse(holidayList[i]['date'].toString());
              _eventsByMonth[tempDate]=[_lblHoliday];
            }
            isLoading=false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Row(
              children: <Widget>[
                Image.asset('images/schedule.png',height: 50.0),
                SizedBox(width: 10.0),
                Text(lang.tr('Calendar'),
                    style: TextStyle(
                        fontFamily: currentFont,
                        fontSize: 18.0,
                        color: Colors.white)
                )
              ]
          ),
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Color(0xff054798),
                        Color(0xff009ccf),
                      ])
              )
          )
      ),
      body: isLoading ? new Center(
          child: new CircularProgressIndicator()) :
      Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            _buildTableCalendar(),
            isLoading ?SizedBox(height: 8.0)
                : Container(
              padding: EdgeInsets.only(left:10.0,top: 5.0,bottom: 5.0,right: 8.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Colors.deepOrange[400],
                        Colors.deepOrange[300],
                      ])
              ),
              child: Text('ថ្ងៃឈប់សម្រាក និងថ្ងៃបុណ្យផ្សេងៗ',style: TextStyle(
                  fontFamily: currentFont,
                  color: Colors.white),),
            ),
            const SizedBox(height: 8.0),
            Expanded(child: _buildEventList()),
          ],
        ),
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    String strLocale = (Localizations.localeOf(context).languageCode=='km')?'km_KM':'en_US';
    return TableCalendar(
      locale:strLocale,
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[300],
        markersColor: Colors.deepOrange[700], //Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
          formatButtonTextStyle: TextStyle().copyWith(
              color: Colors.white, fontSize: 15.0,
              fontFamily: currentFont),
          formatButtonDecoration: BoxDecoration(
            color: Colors.deepOrange[900],
            borderRadius: BorderRadius.circular(16.0),
          ),
          formatButtonVisible: true
      ),
//      onDaySelected: _onDaySelected,
//      onUnavailableDaySelected: false,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
//      headerVisible: false,
    );
  }


  Widget _buildEventList() {
    DemoLocalization lang = DemoLocalization.of(context);

    return Container(
        child: ListView.builder(
          itemCount: holidayListMonth.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(left: 5.0,bottom: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 70.0,
                    decoration: BoxDecoration(
                        border: Border(left: BorderSide(width: 5.0,color: Colors.deepOrange[800])),
                        color:Colors.deepOrange[200]
                    ),
                    child: Column(

                      children: <Widget>[
                        Text(lang.tr(holidayListMonth[index]['holiday_string'].toString()),
                            style: TextStyle(
                                fontFamily: currentFont,
                                fontSize: 12.0
                            )
                        ),
                        Text(holidayListMonth[index]['holiday_day'].toString(),
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight:FontWeight.bold
                            )
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child:  Container(
                        padding: EdgeInsets.only(left:10.0,bottom: 8.0,right: 8.0),
                        child:Text(
                            holidayListMonth[index]['holiday_name'],
                            style: TextStyle(
                                fontFamily: currentFont,
                                color: Colors.black54,
                                fontSize: 14.0
                            )
                        ),
                      )
                  ),
                ],
              ),
            );
          },
        )
    );
  }
}


