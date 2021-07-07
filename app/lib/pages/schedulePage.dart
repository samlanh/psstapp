import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
import 'package:url_launcher/url_launcher.dart';

class SchedulePage extends StatefulWidget {
  final studentId;
  final currentLang,title;

  SchedulePage({this.title,this.studentId,this.currentLang});
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  bool isLoading = true;
  List scheduleList = new List();
  String currentFont='Khmer';
  static DateTime current = DateTime.now();
  String currentDate = DateFormat('EEEE').format(current);
  String dayNumber ;

  var colorArray = {'Monday':Colors.orange,'Tuesday':Colors.purple,'Wednesday':Color(0xff64DD17),
                    'Thursday':Colors.green,'Friday':Colors.blue,'Saturday':Color(0xff800220),'Sunday':Colors.red};
  var dayNoArray = {'Monday':'1','Tuesday':'2','Wednesday':'3','Thursday':'4','Friday':'5','Saturday':'6','Sunday':'7'};
   Color strColor ;
  @override
  void initState(){
    strColor = colorArray[currentDate];
    dayNumber = dayNoArray[currentDate];
    _getJsonSchedule();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(
      backgroundColor: Color(0xff07548f),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xff054798),
                Color(0xff009ccf)
              ]
            )
          )
        ),
        title: Row(
          children: <Widget>[
            Icon(Icons.calendar_today,color: Colors.white,),
            SizedBox(width: 10.0),
            Text(lang.tr(widget.title),
              style: TextStyle(
                fontFamily: currentFont,
                fontSize: 18.0,
                color: Colors.white
              )
            )
          ]
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          stops: [ 0.3,6],
            colors:[
              Color(0xff07548f),
              Color(0xff1290a2),
            ]
           )
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
          ),
         child:Column(
           children: <Widget>[
             Container(
                padding: EdgeInsets.only(top: 20.0,left: 5.0,right: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          dayBox(lang.tr("Monday"),colorArray['Monday'],'1'),//Colors.orange
                          dayBox(lang.tr("Tuesday"),colorArray['Tuesday'],'2'),//Colors.purple
                          dayBox(lang.tr("Wednesday"),colorArray['Wednesday'],'3')//Color(0xff64DD17)
                        ]
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          dayBox(lang.tr("Thursday"),colorArray['Thursday'],'4'),//Colors.green
                          dayBox(lang.tr("Friday"),colorArray['Friday'],'5'),//Colors.blue
                          dayBox(lang.tr("Saturday"),colorArray['Saturday'],'6')//Color(0xff800220)
                        ],
                      )
                  ],
              ),
            )
            ,Expanded(
             child: Container(
               padding: EdgeInsets.all(10.0),
                 child:isLoading ? new Stack(alignment: AlignmentDirectional.center,
                 children: <Widget>[new CircularProgressIndicator()]) :
                 scheduleList.isNotEmpty ?  new ListView.builder (
                   itemCount: scheduleList.length,
                   itemBuilder: (BuildContext context, int index) {
                     return  _buildScheduleItem(scheduleList[index]);
                   }
                 ): Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      notFoundPage()
                    ],
                  ),
                )
                )
             )
           ]
         )
        )
      )
    );
  }

  Widget dayBox(day, Color colorString,dayNum){
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap:(){
          this.setState((){
            isLoading = true;
            strColor = colorString;
            dayNumber = dayNum;
            _getJsonSchedule();
          });
        },
        child: Container(
          alignment: FractionalOffset.center,
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 10.0),
          decoration: BoxDecoration(
            color: colorString,
            border: Border.all(color: colorString,width: 1.0),
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  blurRadius: 2.0,
                  offset: Offset(0.0, 2)
              )
            ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.today,color: Colors.white70,size: 16.0),
              Text(day, style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: currentFont,
              ))
            ],
          )
        ),
      )
    );
  }


  _getJsonSchedule() async{
    final String urlApi = StringData.schedule+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang+'&dayId='+dayNumber;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      if(json.decode(rawData.body)['code']=='SUCCESS'){
        setState((){
          currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
          scheduleList = json.decode(rawData.body)['result']['arrStudyValue'] as List;
          isLoading = false;
        });
      }
    }
  }


  Widget _buildScheduleItem(scheduleData) {
     DemoLocalization lang = DemoLocalization.of(context);
     return new Container(
       margin: EdgeInsets.only(bottom: 10.0),
       decoration: new BoxDecoration(
          color: Colors.white,
          border: Border(bottom:BorderSide(width:4.0,color:strColor)),
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: Colors.black26,
                offset: new Offset(0.0, 2.0),
                blurRadius:2.0,
              )
            ]
        ),
        padding: EdgeInsets.only( right: 5.0),
        child: Row(
          children: <Widget>[
             Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [
                      0.3,
                      6,
                    ],
                    colors:[
                      strColor.withOpacity(0.7),
                      strColor
                    ]
                  )
                ),
                height: 89.0,
                  child:_rowTitleSchedule(Icon(Icons.access_time,color: Colors.white,size: 40.0,),scheduleData['times'].isEmpty ?"":scheduleData['times']),
              ) ,
            SizedBox(width: 5.0,height: 5.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  _rowScheduleList(Icon(Icons.featured_play_list,color:Colors.black.withOpacity(0.7),size: 20.0,),lang.tr('Subject'),(scheduleData['subject_name'].toString())!='null'?scheduleData['subject_name']:"N/A",0),
                  _rowScheduleList(Icon(Icons.person_pin,color:Colors.black.withOpacity(0.7),size: 20.0,),lang.tr('Teacher'),(scheduleData['teacher_name'].toString())!='null'?scheduleData['teacher_name']:"N/A",0),
                  _rowScheduleList(Icon(Icons.call,color:Colors.black.withOpacity(0.7),size: 20.0,),lang.tr('TEL'),(scheduleData['teacher_phone'].toString())!='null'?scheduleData['teacher_phone']:"N/A",1)
                ]
              )
            )
          ]
        )
    );
  }

  Widget _rowTitleSchedule(Icon iconType,String subjectName) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          iconType,
          Text(subjectName, style:
          TextStyle(
            fontFamily: currentFont,
            fontWeight: FontWeight.w600,
            color: Colors.white)
          )
        ]
      )
    );
  }
  Widget _rowScheduleList(Icon iconType,String textLabel, String stringValue,int isCall){
    return new Container(
      child: Row(
        children: [
          iconType,
         Expanded(
           child: Text(textLabel,style: TextStyle(
             fontFamily: currentFont,
             fontSize: 14.0,
             fontWeight: FontWeight.w500,
             color: Colors.black.withOpacity(0.7)
           )
           ),
         ),
         Expanded(
          child:  isCall==1 ?  Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap:() async{
                if (await canLaunch("tel://"+stringValue)) {//"tel://+85570418002"
                  await launch("tel://"+stringValue);
                }
              },
              child: Text(stringValue,style: TextStyle(
                fontFamily: currentFont,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
                fontStyle: FontStyle.italic
               ),
              )
            )
          ): Align(
            alignment: Alignment.topRight,
            child: Text(stringValue,style: TextStyle(
              fontFamily: currentFont,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.7),
              fontStyle: FontStyle.italic
            ))
          )
         )
        ]
      ),
    );
  }
}