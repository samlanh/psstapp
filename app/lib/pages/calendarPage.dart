import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/localization/localization.dart';

class CalendarPage extends StatefulWidget  {
 final String currentLang;
 CalendarPage({this.currentLang});
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with TickerProviderStateMixin{

  final Map<DateTime, List> _holidays = {
    DateTime(2020, 6, 16): ['New Year\'s Day'],
    DateTime(2020, 3, 3): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2019, 4, 22): ['Easter Monday'],
  };

  List holidayList = new List();
  final Map<DateTime, List> _newHolidays= Map();

  Map<DateTime, List> _events = Map();
  Map<DateTime, List> _eventsByMonth = Map();
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  List allPost = new List();
  bool isLoading=true;
  @override
  void initState() {
    _getJsonData();
    super.initState();
    final _selectedDay = DateTime.now();
//    debugPrint('Noday Selected'+_selectedDay.toString());
//    _events = {
//      DateTime(2020, 6, 17): ['Easter Monday','Easter Monday'],
//      DateTime(2020, 6, 18): ['Easter Monday','Easter Monday'],
//      DateTime(2020, 6, 19): ['Easter Monday','Easter Monday'],
////      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
////      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
////      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
////      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
////      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
////      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
////      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
////      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
////      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
////      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
////      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
////      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
////      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
////      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
////      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
//    };
//    debugPrint("Events here"+_events.toString());
    _selectedEvents = _events[_selectedDay] ?? [];
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

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected'+day.toString()+'-events: '+events.toString());
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {

    print('CALLBACK: _onVisibleDaysChanged'+first.toString());
    print(DateFormat('MM-yyyy').format(first));

//    setState(() {
//      _selectedEvents = events;
//    });

//    _onDaySelected(date, events);
//    _animationController.forward(from: 0.0);
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  _getJsonData() async{
    final String urlApi = 'http://192.168.1.5/psst/trunk/public/api/index/?url=calendar&cateId=3';
//    final String urlApi = StringData.score+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          debugPrint('success');
          holidayList = json.decode(rawData.body)['result'] as List;
          String _lblHoliday ;

          setState(() {
            for(var i= 0;i< holidayList.length;i++){
//            debugPrint(holidayList[i]['date']+'/'+holidayList[i]['title_en'].toString());
//            _events[DateTime(holidayList[i]['date'])].add(holidayList[i]['title_en'].toString());
//            print(DateFormat('MM-yyyy').format(DateTime(holidayList[i]['date'].toString()));

              _lblHoliday = holidayList[i]['title_en'].toString();
              _events[DateTime.parse(holidayList[i]['date'])]=[_lblHoliday];

              DateTime tempDate = new DateFormat("yyyy-MM").parse(holidayList[i]['date'].toString());
              _eventsByMonth[tempDate]=[_lblHoliday];

//            DateTime(2020, 6, 19): ['Easter Monday','Easter Monday'],
//            _newHolidays[holidayList[i]['date']].add(holidayList[i]['title_en'].toString());
//
            }
            isLoading=false;
          });
          debugPrint(_eventsByMonth.toString());
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
//                  Image.asset('images/schedule.png',height: 50.0),
                  SizedBox(width: 10.0),
                  Text(lang.tr('Calendar'),
                      style: TextStyle(
                          fontFamily: 'Montserrat',
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
      body:
       isLoading ? new Center(
        child: new CircularProgressIndicator()) :
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // Switch out 2 lines below to play with TableCalendar's settings
                  //-----------------------
                  _buildTableCalendar(),
                  // _buildTableCalendarWithBuilders(),
                  const SizedBox(height: 8.0),
                  _buildButtons(),
                  const SizedBox(height: 8.0),
                  Expanded(child: _buildEventList()),
                ],
              ),
            ),
    );
  }


  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'km_KM',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.redAccent, //Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
        formatButtonVisible: false
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
//      headerVisible: false,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
//  Widget _buildTableCalendarWithBuilders() {
//    return TableCalendar(
//      locale: 'km_KM',
//      calendarController: _calendarController,
//      events: _events,
//      holidays: _holidays,
//      initialCalendarFormat: CalendarFormat.month,
//      formatAnimation: FormatAnimation.slide,
//      startingDayOfWeek: StartingDayOfWeek.sunday,
//      availableGestures: AvailableGestures.all,
//      availableCalendarFormats: const {
//        CalendarFormat.month: '',
//      },
//      calendarStyle: CalendarStyle(
//        outsideDaysVisible: false,
//        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//      ),
//      daysOfWeekStyle: DaysOfWeekStyle(
//        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//      ),
//      headerStyle: HeaderStyle(
//        centerHeaderTitle: true,
//        formatButtonVisible: false,
//      ),
//      builders: CalendarBuilders(
//        selectedDayBuilder: (context, date, _) {
//          return FadeTransition(
//            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//            child: Container(
//              margin: const EdgeInsets.all(4.0),
//              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//              color: Colors.deepOrange[300],
//              width: 100,
//              height: 100,
//              child: Text(
//                '${date.day}',
//                style: TextStyle().copyWith(fontSize: 16.0),
//              ),
//            ),
//          );
//        },
//        todayDayBuilder: (context, date, _) {
//          return Container(
//            margin: const EdgeInsets.all(4.0),
//            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//            color: Colors.amber[400],
//            width: 100,
//            height: 100,
//            child: Text(
//              '${date.day}',
//              style: TextStyle().copyWith(fontSize: 16.0),
//            ),
//          );
//        },
//        markersBuilder: (context, date, events, holidays) {
//          final children = <Widget>[];
//
//          if (events.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: 1,
//                bottom: 1,
//                child: _buildEventsMarker(date, events),
//              ),
//            );
//          }
//
//          if (holidays.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: -2,
//                top: -2,
//                child: _buildHolidaysMarker(),
//              ),
//            );
//          }
//
//          return children;
//        },
//      ),
//      onDaySelected: (date, events) {
//        debugPrint('Date Selected'+date.toString()+"Evented"+events.toString());
//        _onDaySelected(date, events);
//        _animationController.forward(from: 0.0);
//      },
//      onVisibleDaysChanged: _onVisibleDaysChanged,
//      onCalendarCreated: _onCalendarCreated,
//    );
//  }

//  Widget _buildEventsMarker(DateTime date, List events) {
//    return AnimatedContainer(
//      duration: const Duration(milliseconds: 300),
//      decoration: BoxDecoration(
//        shape: BoxShape.rectangle,
//        color: _calendarController.isSelected(date)
//            ? Colors.brown[500]
//            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
//      ),
//      width: 16.0,
//      height: 16.0,
//      child: Center(
//        child: Text(
//          '${events.length}',
//          style: TextStyle().copyWith(
//            color: Colors.white,
//            fontSize: 12.0,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildHolidaysMarker() {
//    return Icon(
//      Icons.add_box,
//      size: 20.0,
//      color: Colors.blueGrey[800],
//    );
//  }

  Widget _buildButtons() {
    final dateTime =  DateTime.now();//_selectedDay;_events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
//            RaisedButton(
//              child: Text('Month'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.month);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('2 weeks'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('Week'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.week);
//                });
//              },
//            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text('Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    debugPrint("my Event selected "+_selectedEvents.toString());
    return ListView(
      children: _selectedEvents
        .map((event) =>Row(
          children: <Widget>[
            Text("Date"),
           Expanded(
             child:  Container(
               padding: EdgeInsets.all(12.0),
               decoration: BoxDecoration(
                 border: Border.all(width: 0.8,color: Colors.black26),
                 borderRadius: BorderRadius.circular(8.0),
               ),
               margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
               child: Container(
                 child: Text(event.toString(),style: TextStyle(color: Colors.redAccent),),
//                onTap: () => print('$event tapped!'),
               ),
             ),
           )
          ],
        )
      ).toList(),
    );
  }
}


