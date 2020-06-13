import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:app/localization/localization.dart';

class DisciplineDetailPage extends StatefulWidget {
  final studentId,currentLang,currentMonth,groupId,rowData,academicYear,className;

  DisciplineDetailPage({this.studentId,this.currentLang,this.currentMonth,
    this.groupId,this.rowData,this.academicYear,this.className});
  @override
  _DisciplineDetailPageState createState() => _DisciplineDetailPageState();
}

class _DisciplineDetailPageState extends State<DisciplineDetailPage> {

  List attendanceList = new List();
  bool isLoading= true;

  @override
  void initState(){
    super.initState();
    _getJsonAttendanceDetail();
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
            Image.asset('images/attendance.png',height: 50.0),
            SizedBox(width: 10.0),
            Text(lang.tr('Discipline')+' ('+lang.tr(widget.rowData['dateLabel'])+')',
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
                Color(0xff009ccf),
              ])
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: isLoading? new Stack(alignment: AlignmentDirectional.center,
              children: <Widget>[new CircularProgressIndicator()]) : Container(
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: new ListView.builder(
                        itemCount: attendanceList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  _buildDisciplineItem(attendanceList[index]);
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
                    Color(0xff009ccf)
                  ])
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  rowSummerData(lang.tr('Year'),widget.academicYear),
                  rowSummerData(lang.tr('Class'),widget.className),
                  Container(
                    margin: EdgeInsets.only(top:10.0,bottom: 10.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      boxShadow: <BoxShadow>[
                        new BoxShadow (
                          color: Colors.black26,
                          offset: new Offset(0.0, 2.0),
                          blurRadius: 3.0,
                        ),
                      ],
                    ),
                  ),
                  rowSummerData(lang.tr('Minor'),widget.rowData['Minor'].toString()+' '+lang.tr('TIMES')),
                  rowSummerData(lang.tr('Moderate'),widget.rowData['MODERATE'].toString()+' '+lang.tr('TIMES')),
                  rowSummerData(lang.tr('Major'),widget.rowData['MAJOR'].toString()+' '+lang.tr('TIMES')),
                  rowSummerData(lang.tr('Other'),widget.rowData['OTHER'].toString()+' '+lang.tr('TIMES')),
                  Text(lang.tr('Total')+" "+widget.rowData['TOTAL_ATTRECORD'].toString()+' '+lang.tr('TIMES'),style: TextStyle(fontSize:18.0,color: Colors.white,fontWeight: FontWeight.bold)),
                ]
              )
            )
        ],
      )
    );
  }


  _getJsonAttendanceDetail() async{
    final String urlApi = StringData.disciplineDetail+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang+'&currentMonth='+widget.currentMonth+'&groupId='+widget.groupId;
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
        Expanded(
          child: Text(strLabel,style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Text(strData,style:TextStyle(color: Colors.white,fontSize: 14.0)
          )
        )
      ],
    );
  }


  Widget _buildDisciplineItem(rowData) {
    DemoLocalization lang = DemoLocalization.of(context);
     return new Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
          ),
            boxShadow: <BoxShadow>[
              new BoxShadow (
                color: Colors.black26,
                offset: new Offset(0.0, 2.0),
                blurRadius: 3.0,
              ),
            ],
        ),
        padding: EdgeInsets.only(right: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 110.0,
              padding: EdgeInsets.all(5.0),
              color: Color(0xff07548f),
              child: rowTitleDiscipline(lang.tr(rowData['attendenceStatusTitle']),rowData['dateAttendence'],22.0),
            ),
          Expanded(
            child: Padding(padding: EdgeInsets.only(left: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children:[
                  rowDiscipline(lang.tr('Reason'),'',14.0),
                  Directionality( textDirection: TextDirection.ltr,
                    child: Text(rowData['description'],textAlign: TextAlign.justify),
                  )
                ]
              )
            )
          ),
        ],
      )
    );
  }


  Widget rowTitleDiscipline(String strData,String strDate,double fontSize){
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
            )),
          ]
        )
      ],
    );
  }


  Widget rowDiscipline(String textData, String priceData,double fontSize){

    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26,width: 1.0))
      ),
      child: Row(
        children: [
         Expanded(
           child: Text(textData,style: TextStyle(
             fontFamily: 'Montserrat',
             fontSize: fontSize,
             fontWeight: FontWeight.w500,
             color: Color(0xff07548f).withOpacity(0.9)
           )
           )
         ),
         Expanded(
           child:  Align(
             alignment: Alignment.topRight,
             child: Text(priceData,style: TextStyle(
               fontFamily: 'Montserrat',
               fontSize: fontSize,
               fontWeight: FontWeight.bold,
               color: Color(0xff07548f),
               fontStyle: FontStyle.italic
             )
             )
           )
         )
        ]
      ),
    );
  }
}