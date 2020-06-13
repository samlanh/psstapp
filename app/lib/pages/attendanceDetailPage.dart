import 'package:flutter/material.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';

class AttendanceDetailPage extends StatefulWidget {
  final studentId,currentLang,currentMonth,groupId,rowData;

  AttendanceDetailPage({this.studentId,this.currentLang,this.currentMonth,this.groupId,this.rowData});
  @override
  _AttendanceDetailPageState createState() => _AttendanceDetailPageState();
}

class _AttendanceDetailPageState extends State<AttendanceDetailPage> {

  List attendanceList = new List();
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    _getJsonAttendance();
  }
  @override
  Widget build(BuildContext context) {

    DemoLocalization lang = DemoLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          children: <Widget>[
            Image.asset('images/attendance.png',height: 50.0),
            SizedBox(width: 10.0),
            Text(lang.tr('Attendance')+' ('+lang.tr(widget.rowData['dateLabel'].toString())+')',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18.0,
                color: Colors.white)
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xff054798),
                Color(0xff009ccf)
              ])
          )
        )
      ),
      body: new Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child:Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color(0xff054798),
                    Color(0xff009ccf)
                  ]
                )
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0))
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: new ListView.builder (
                      itemCount: attendanceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  _buildPaymentItem(attendanceList[index]);
                      }
                    )
                  )
                )
              )
            )
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color(0xff054798),
                  Color(0xff009ccf),
                ]
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      rowSummerData(lang.tr("Absent"),widget.rowData['ABSENT'].toString()+' '+lang.tr("TIMES")),
                      rowSummerData(lang.tr("Permission"),widget.rowData['PERMISSION'].toString()+' '+lang.tr("TIMES")),
                      rowSummerData(lang.tr("Late"),widget.rowData['LATE'].toString()+' '+lang.tr("TIMES")),
                      rowSummerData(lang.tr("Early Leave"),widget.rowData['EarlyLeave'].toString()+' '+lang.tr("TIMES")),
                      Text(lang.tr("Total")+" "+widget.rowData['TOTAL_ATTRECORD'].toString()+' '+lang.tr("TIMES"),style: TextStyle(fontSize:18.0,color: Colors.white,fontWeight: FontWeight.bold)),
                    ]
                  )
                )
              ]
            )
          )
        ],
      )
    );
  }


  _getJsonAttendance() async{
    final String urlApi = StringData.attendanceDetail+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang+'&currentMonth='+widget.currentMonth+'&groupId='+widget.groupId;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState((){
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          attendanceList = json.decode(rawData.body)['result'] as List;
          isLoading = false;
        }
      });
    }
  }


  Widget rowSummerData(String strLabel,String strData){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(strLabel,style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold)),
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(strData,style:TextStyle(color: Colors.white,fontSize: 14.0)
            )
          )
        )
      ]
    );
  }


  Widget _buildPaymentItem(rowData) {
    DemoLocalization lang = DemoLocalization.of(context);

    return new Container(
       margin: EdgeInsets.only(bottom: 10.0),
       decoration: new BoxDecoration(
         color: Colors.white,
         border: new Border.all(width: 1.0, color: Color(0xffdddddd),
         ),//width: 1.0,color:Color(0xffe4e6e8)),
         borderRadius: new BorderRadius.circular(4.0),
         boxShadow: <BoxShadow>[
           new BoxShadow (
             color: const Color(0xcce4e6e8),
             offset: new Offset(1.0,1.0),
             blurRadius: 1.0
           ),
         ],
       ),
      padding: EdgeInsets.only(right: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            height: 110.0,
            width: 125.0,
            padding: EdgeInsets.all(2.0),
            color: Color(0xff07548f),
            child: rowTitleAttendance(lang.tr(rowData['attendenceStatusTitle'].toString()),rowData['dateAttendence'],20.0),
          ),
          Expanded(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children:[
                _rowAttendanceType(lang.tr('Reason')+" : ",' ',14.0),
                Directionality( textDirection: TextDirection.ltr,
                  child: Text(" "+rowData['description'],textAlign: TextAlign.justify),
                )
              ]
            )
          ),
        ],
      )
    );
  }


  Widget rowTitleAttendance(String strData,String strDate,double fontSize){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(strData,style: TextStyle(fontSize: fontSize,color: Colors.white,fontWeight: FontWeight.bold),),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Icon(Icons.date_range,color: Colors.white,size: 16.0),
            Text(strDate, style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ))
          ]
        )
      ],
    );
  }


  Widget _rowAttendanceType(String textData, String priceData,double fontSize){
    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffdddddd),width: 1.0))
      ),
      child: Row(
        children: [
           Expanded(
             child: Text(textData,style: TextStyle(
               fontFamily: 'Montserrat',
               fontSize: fontSize,
               fontWeight: FontWeight.w500,
               color: Color(0xff07548f).withOpacity(0.9))
             ),
           ),
           Expanded(
             child:  Align(
               alignment: Alignment.topRight,
               child: Text(priceData,style: TextStyle(
                 fontFamily: 'Montserrat',
                 fontSize: fontSize,
                 fontWeight: FontWeight.bold,
                 color: Color(0xff07548f),
                 fontStyle: FontStyle.italic)
               )
             )
           )
        ]
      )
    );
  }
}