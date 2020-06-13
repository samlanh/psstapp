import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import '../url_api.dart';
import 'package:app/pages/disciplineDetailPage.dart';

class DisciplinePagePage extends StatefulWidget {
  final String studentId;
  final String currentLang;

  DisciplinePagePage({this.studentId,this.currentLang});
  @override
  _DisciplinePagePageState createState() => _DisciplinePagePageState();
}

class _DisciplinePagePageState extends State<DisciplinePagePage> {
  List disciplineList = new List();
  List disciplineNoteList = new List();
  bool isLoading = true;

  String moderate = '0';
  String minor = '0';
  String major = '0';
  String other = '0';
  String earlyLeave='0';
  String className='';
  String academicYear='';
  String totalAmt ='0';

  @override
  void initState(){
    super.initState();
    _getJsonDiscipline();
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
            Text(lang.tr('Discipline'),
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
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 11,
            child: isLoading? new Stack(alignment: AlignmentDirectional.center,
              children: <Widget>[new CircularProgressIndicator()]) : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Color(0xff054798),
                      Color(0xff009ccf),
                    ]
                  ),
                ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0,left:10.0,right: 10.0,bottom: 10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: disciplineList.isNotEmpty ? ListView.builder (
                      itemCount: disciplineList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildDisciplineItem(disciplineList[index]);
                      }
                    ):Center(child:Text("No Result !"))
                  )
                ),
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
                ])
            ),
              child: Column(

                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            _rowSummerData(lang.tr("Year"),academicYear),
                            _rowSummerData(lang.tr("Class"),className),
                          ],
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _rowSummerData(lang.tr('Minor'),minor+' '+lang.tr('TIMES')),
                            _rowSummerData(lang.tr('Moderate'),moderate+' '+lang.tr('TIMES')),
                            _rowSummerData(lang.tr('Major'),major+' '+lang.tr('TIMES')),
                            _rowSummerData(lang.tr('Other'),other+' '+lang.tr('TIMES')),
                            Text(lang.tr("Total")+" : "+totalAmt+' '+lang.tr('TIMES'),style: TextStyle(fontSize:18.0,color: Colors.white,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width,
                    child:  FloatingActionButton.extended(
                      onPressed: () {
                        _showTermDialog(context);
                      },
                      label: Text(lang.tr('Discipline Note')),
                      icon: Icon(Icons.person_pin),
                      backgroundColor: Colors.redAccent,
                    ),
                  )
                ],
              )
            ),

        ],
      )
    );
  }


  _getJsonDiscipline() async{
    final String urlApi = StringData.discipline+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          disciplineList = json.decode(rawData.body)['result']['rsDetail'] as List;
          disciplineNoteList = json.decode(rawData.body)['result']['rsNote'] as List;

          minor = json.decode(rawData.body)['result']['rsSummary']['Minor'].toString();
          moderate = json.decode(rawData.body)['result']['rsSummary']['MODERATE'].toString();
          major = json.decode(rawData.body)['result']['rsSummary']['MAJOR'].toString();
          other = json.decode(rawData.body)['result']['rsSummary']['OTHER'].toString();
          totalAmt = json.decode(rawData.body)['result']['rsSummary']['TOTALAMT'].toString();
          className = json.decode(rawData.body)['result']['rsSummary']['className'].toString();
          academicYear = json.decode(rawData.body)['result']['rsSummary']['acarYear'].toString();
          isLoading = false;
        }
      });
    }
  }


  Widget _rowSummerData(String strLabel,String strData){
     return Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.start,
       children: <Widget>[
         Text(strLabel,style: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold)),
         Expanded(
           child: Align(
             alignment: Alignment.bottomRight,
             child: Text(strData,style:TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold)
             ),
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
            right: BorderSide(width: 1.0, color: Color(0xffdddddd)),
            bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
            left: BorderSide(width: 1.0, color: Color(0xffdddddd)),
          ),
            boxShadow: <BoxShadow>[
              new BoxShadow (
                color: Colors.black26,
                offset: new Offset(0.0, 2.0),
                blurRadius: 3.0,
              ),
            ],
        ),
        padding: EdgeInsets.only(right: 5.0),
        child: InkWell(
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DisciplineDetailPage(studentId:widget.studentId, currentLang:widget.currentLang,currentMonth:rowData['dateDiscipline'],groupId:rowData['group_id'],rowData:rowData,academicYear:academicYear,className:className)
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 110.0,
                padding: EdgeInsets.all(5.0),
                color: Color(0xff07548f),
                child: _rowTitleDiscipline(lang.tr(rowData['dateLabel'].toString()),Image.asset("images/schedule.png",width:40.0),20.0),
              ),
              Expanded(
                child: Padding(padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Align(
                        alignment: FractionalOffset.topRight,
                        child:  Icon(Icons.more_horiz,size: 22.0,color:Colors.black45),
                      ),
                      _rowDisciplineType(lang.tr('Minor'),rowData['Minor'].toString()+' '+lang.tr('TIMES'),14.0),
                      _rowDisciplineType(lang.tr('Moderate'),rowData['MODERATE'].toString()+' '+lang.tr('TIMES'),14.0),
                      _rowDisciplineType(lang.tr('Major'),rowData['MAJOR'].toString()+' '+lang.tr('TIMES'),14.0),
                      _rowDisciplineType(lang.tr('Other'),rowData['OTHER'].toString()+' '+lang.tr('TIMES'),14.0),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(lang.tr("Total")+" : "+rowData['TOTAL_ATTRECORD'].toString()+' '+lang.tr('TIMES'),style: TextStyle(
                            fontSize: 14.0,color:Colors.red.shade700,fontWeight: FontWeight.w600),),
                      )
                    ]
                  )
                )
              ),
            ],
          )
        )
    );
  }


  Widget _rowTitleDiscipline(String stringData,Image image, double fontSize){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          image,
          Text(stringData, style:TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white
            )),
        ]
    );
  }


  Widget _rowDisciplineType(String textData, String priceData,double fontSize){
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
               fontStyle: FontStyle.italic
             )
             ),
           ),
         )
        ]
      ),
    );
  }


  void _showTermDialog(BuildContext context){

    DemoLocalization lang = DemoLocalization.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          title: new Text(lang.tr("Discipline Note"),textAlign: TextAlign.center,style: TextStyle(fontSize: 14.0,color: Colors.redAccent)),
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
                  itemCount: disciplineNoteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  _termCondition(disciplineNoteList[index]);
                  }
                ),
              )
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(lang.tr("Close")),
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
          Text(rowData['title'].toString(),style: TextStyle(fontSize: 14.0,fontFamily: 'Khmer',fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child:Html(
              data: rowData['description'].toString(),
            )
          )
        ],
      ),
    );
  }
}