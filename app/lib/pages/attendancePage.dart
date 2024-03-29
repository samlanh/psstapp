import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/pages/attendanceDetailPage.dart';
import '../url_api.dart';

class AttendancePage extends StatefulWidget {

  final String studentId;
  final String currentLang;

  AttendancePage({this.studentId,this.currentLang});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List attendanceList = new List();
  List noteList = new List();
  bool isLoading = true;
  String currentFont='Khmer';

  String absent = '0';
  String come = '0';
  String permission = '0';
  String late = '0';
  String earlyLeave='0';
  String className='';
  String academicYear='';
  String totalAmt ='0';

  @override
  void initState(){
    _getJsonAttendance();
    super.initState();
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
            Text(lang.tr('Attendance'),
              style: TextStyle(
              fontFamily: currentFont,
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
            flex: 10,
            child: isLoading ? new Stack(alignment: AlignmentDirectional.center,
              children: <Widget>[new CircularProgressIndicator()]) :
                Container(
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
                  child:  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
                    ),
                    child:  Padding(
                      padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
                      child: attendanceList.isNotEmpty
                    ? ListView.builder (
                    itemCount: attendanceList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  _buildAttendanceItem(attendanceList[index]);
                      }
                    )
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          notFoundPage()
                        ],
                      ),
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
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(lang.tr("Total Attendance"),style: TextStyle(fontSize:16.0,
                              color: Colors.white,fontWeight: FontWeight.bold,
                              fontFamily: currentFont)),
                          SizedBox(height: 5.0),
                          rowSummerData(lang.tr("Year"),academicYear.toString()),
                          rowSummerData(lang.tr("Class"),className.toString()),
                        ]
                      )
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          rowSummerData(lang.tr("Absent"),absent.toString()+' '+lang.tr('TIMES')),
                          rowSummerData(lang.tr("Permission"),permission.toString()+' '+lang.tr('TIMES')),
                          rowSummerData(lang.tr("Late"),late.toString()+' '+lang.tr('TIMES')),
                          rowSummerData(lang.tr("Early Leave"),earlyLeave.toString()+' '+lang.tr('TIMES')),
                          Text(lang.tr("Total")+" "+totalAmt.toString()+' '+lang.tr('TIMES'),style: TextStyle(
                            fontSize:16.0,color: Colors.white,fontWeight: FontWeight.bold,
                            fontFamily: currentFont
                          )),
                        ]
                      )
                    )
                  ]
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  width: MediaQuery.of(context).size.width,
                  child:  FloatingActionButton.extended(
                    onPressed: () {
                      _showTermDialog(context);
                    },
                    label: Text(lang.tr('Attendance Note'),style: TextStyle(
                        fontFamily: currentFont
                    )),
                    icon: Icon(Icons.person_pin),
                    backgroundColor: Colors.redAccent
                  )
                )
              ]
            )
          )
        ]
      )
    );
  }


  _getJsonAttendance() async{
    final String urlApi = StringData.attendance+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
          attendanceList = json.decode(rawData.body)['result']['rsDetail'] as List;
          noteList = json.decode(rawData.body)['result']['rsNote'] as List;
          come = json.decode(rawData.body)['result']['rsSummary']['COME'].toString();
          absent = json.decode(rawData.body)['result']['rsSummary']['ABSENT'].toString();
          permission = json.decode(rawData.body)['result']['rsSummary']['PERMISSION'].toString();
          late = json.decode(rawData.body)['result']['rsSummary']['LATE'].toString();
          earlyLeave = json.decode(rawData.body)['result']['rsSummary']['EarlyLeave'].toString();
          totalAmt = json.decode(rawData.body)['result']['rsSummary']['TOTALAMT'].toString();
          className = json.decode(rawData.body)['result']['rsSummary']['className'].toString();
          academicYear = json.decode(rawData.body)['result']['rsSummary']['acarYear'].toString();
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
       Text(strLabel,style: TextStyle(color: Colors.white,
         fontSize: 14.0,fontWeight: FontWeight.bold,
         fontFamily: currentFont
       )),
       Expanded(
         child: Align(
           alignment: Alignment.bottomRight,
           child: Text(strData,style:TextStyle(color: Colors.white,fontSize: 14.0,
               fontWeight: FontWeight.bold,
               fontFamily: currentFont)
           )
         )
       )
     ],
   );
}


  Widget _buildAttendanceItem(rowData) {
    DemoLocalization lang = DemoLocalization.of(context);
     return new Container(
       margin: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(width: 1.0, color: Color(0xffdddddd)),
            bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
            left: BorderSide(width: 1.0, color: Color(0xffdddddd)),
          ),
            boxShadow: <BoxShadow>[
              new BoxShadow (
                color: Colors.black26,
                offset: new Offset(0.0, 2.0),
                blurRadius: 3.0
              ),
            ],
        ),
        padding: EdgeInsets.only(right: 5.0),
        child: InkWell(
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AttendanceDetailPage(studentId:widget.studentId, currentLang:widget.currentLang,currentMonth:rowData['dateAttendence'],groupId:rowData['group_id'],rowData:rowData)
            ));
          },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex:1,
                  child: Container(
                    height: 110.0,
                    padding: EdgeInsets.all(5.0),
                    color: Color(0xff07548f),
                    child: _rowTitleAttendance(lang.tr(rowData['dateLabel'].toString()),Image.asset("images/schedule.png",width:40.0),20.0),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        Align(
                          alignment: FractionalOffset.topRight,
                          child:  Icon(Icons.more_horiz,size: 22.0,color:Colors.black45),
                        ),
                        _rowAttendanceType(lang.tr('Absent'),rowData['ABSENT'].toString()+' '+lang.tr('TIMES'),14.0),
                        _rowAttendanceType(lang.tr('Permission'),rowData['PERMISSION'].toString()+' '+lang.tr('TIMES'),14.0),
                        _rowAttendanceType(lang.tr('Late'),rowData['LATE'].toString()+' '+lang.tr('TIMES'),14.0),
                        _rowAttendanceType(lang.tr('Early Leave'),rowData['EarlyLeave'].toString()+' '+lang.tr('TIMES'),14.0),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(lang.tr("Total")+' '+rowData['TOTAL_ATTRECORD'].toString()+' '+lang.tr('TIMES'),style: TextStyle(
                              fontSize: 14.0,color:Colors.red.shade700,fontWeight: FontWeight.w600)
                          )
                        )
                      ]
                      )
                  )
                )
              ]
            )
        )
    );
  }


  Widget _rowTitleAttendance(String stringData,Image image, double fontSize){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          image,
          Text(stringData, style:TextStyle(
            fontFamily: currentFont,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white
            ))
        ]
    );
  }


  Widget _rowAttendanceType(String textData, String priceData,double fontSize){
    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26,width: 1.0))
      ),
      child: Row(
        children: [
         Expanded(
           child: Text(textData,style: TextStyle(
             fontFamily: currentFont,
             fontSize: fontSize,
             fontWeight: FontWeight.w500,
             color: Color(0xff07548f).withOpacity(0.9)
             )
           )
         ),
         Expanded(
           child: Align(
             alignment: Alignment.topRight,
             child:Text(priceData,style: TextStyle(
               fontFamily: currentFont,
               fontSize: fontSize,
               fontWeight: FontWeight.bold,
               color: Color(0xff07548f),
               fontStyle: FontStyle.italic
             )
             )
           )
         )
        ]
      )
    );
  }


  void _showTermDialog(BuildContext context){
    DemoLocalization lang = DemoLocalization.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          title: new Text(lang.tr("Attendance Note"),textAlign: TextAlign.center
            ,style: TextStyle(
            fontSize: 14.0,
            fontFamily: currentFont)
          ),
          content: Container(
            margin: EdgeInsets.all(5.0),
            height:MediaQuery.of(context).size.height*0.5,
            width: MediaQuery.of(context).size.width*1,
              decoration: new BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(width: 2.0, color:Colors.black26),
                ),
              ),
            child: Container(
              child: ListView.builder (
                  itemCount: noteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  _termCondition(noteList[index]);
                  }
              ),
            )
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(lang.tr("Close"),style: TextStyle(
               fontFamily: currentFont
              ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget _termCondition(rowData){
    return Container(
      padding: EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(rowData['title'].toString(),style: TextStyle(
            fontSize: 12.0,
            fontFamily: currentFont),)
        ],
      ),
    );
  }
}