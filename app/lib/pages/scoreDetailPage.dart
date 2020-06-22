import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
//import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';


class ScoreDetailPage extends StatefulWidget {
  final studentId,currentLang,scoreId,rowData;
  ScoreDetailPage({this.studentId,this.currentLang,this.scoreId,this.rowData});

  @override
  _ScoreDetailPageState createState() => _ScoreDetailPageState();
}

class _ScoreDetailPageState extends State<ScoreDetailPage> {
  List scoreList = new List();
  bool isLoading = true;


  @override
  void initState(){
    _getJsonScoreDetail();
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    DemoLocalization lang = DemoLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Image.asset('images/score.png',height: 50.0),
            SizedBox(width: 10.0),
            Text(lang.tr('Score')+'('+widget.rowData['for_month'].toString()+')',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18.0,
                color: Colors.white)
            ),
//                  FlatButton.icon(
//                      onPressed: () async {
//                        debugPrint('here');
//                      }
//                      ,icon: Icon(Icons.cloud_download), label: Text("Download")
//                  )
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
            flex: 11,
            child:Container(
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
              child:  Container(//isLoading
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0),
                  child: isLoading ? new Center(
                    child: new CircularProgressIndicator()) : Container(
                    height: MediaQuery.of(context).size.height,
                    child: new ListView.builder(
                      itemCount:scoreList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildScoreItem(scoreList[index]);
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
                ])
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                            Text(widget.rowData['for_month'].toString(),style: TextStyle(fontSize:14.0,fontFamily: "khmer",color:Colors.yellow,fontWeight: FontWeight.bold)),
                            _rowSummerData("Year",widget.rowData['academicYear'].toString()),
                            _rowSummerData("Grade",widget.rowData['gradeTitle'].toString()),
                            _rowSummerData("Class",widget.rowData['groupCode'].toString()),
                          ]
                        )
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _rowSummerData(lang.tr('Total Score'),widget.rowData['totalScore'].toString()),
                            _rowSummerData(lang.tr('Score Average'),widget.rowData['totalAverage'].toString()),
                            _rowSummerData(lang.tr('MentionGrade'),widget.rowData['metionGrade'].toString()),
                            _rowSummerData(lang.tr('Mention'),widget.rowData['mention'].toString()),
                            _rowSummerData(lang.tr('Result'),lang.tr(widget.rowData['restultStatus'].toString())),
                            _rowSummerData(lang.tr("Rank"),widget.rowData['rank'].toString()),

                          ],
                        )
                      )
                    ]
                  ),
                  FlatButton.icon(
                    onPressed:(){
//                      Navigator.push(context,MaterialPageRoute(builder: (context) => AppVideoPage(currentLang:currentLang)));
                    },
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.red)
                    ),
                    icon: Icon(Icons.file_download,color: Colors.white),
                    label: Text(lang.tr("DOWNLOAD"),style:TextStyle(
                      color:Colors.white,fontSize: 16.0,
                    ))
                  ),
                ],
              )
            ),

        ]
      )
    );
  }


  _getJsonScoreDetail() async{
    final String urlApi = StringData.scoreDetail+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang+'&score_id='+widget.scoreId;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState((){
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          scoreList = json.decode(rawData.body)['result']['rowDetail'] as List;
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
        Text(strLabel,style: TextStyle(color: Colors.white,fontSize: 12.0,fontWeight: FontWeight.bold)),
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


  Widget _buildScoreItem(rowData) {
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
              child: _rowTitleScore(rowData['rank'].toString()),
            ),
            Expanded(
              child: Padding(padding: EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    _rowScoreType(lang.tr('Subject'),rowData['subjecTitle'].toString(),16.0),
                    _rowScoreType(lang.tr('Total Score'),rowData['score'].toString(),14.0),
                    _rowScoreType(lang.tr('Mention'),rowData['mention'].toString(),14.0),
                  ]
                )
              )
            ),
          ],
        )
    );
  }


  Widget _rowTitleScore(String strData){
    DemoLocalization lang = DemoLocalization.of(context);

    return CircleAvatar(
      minRadius: 40.0,
      backgroundColor: Color(0xff009ccf),
      child: Container(
        padding:EdgeInsets.only(left: 5.0,right: 5.0),
        alignment: AlignmentDirectional.center,
        child: CircleAvatar(
          minRadius: 40.0,
          backgroundColor: Color(0xff009ccf),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(lang.tr('Rank'), style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white
                )
              ),
              Text(
                strData, style:TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white
              )
              ),
            ],
          ) ,
        )
      )
    );
  }


  Widget _rowScoreType(String textData, String priceData,double fontSize){
    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26,width: 1.0))
      ),
      child: Row(
        children:[
         Expanded(
           child: Text(textData,style: TextStyle(
             fontFamily: 'Montserrat',
             fontSize: fontSize,
             fontWeight: FontWeight.w500,
             color: Color(0xff07548f).withOpacity(0.9)
           )),
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
         )]
      ),
    );
  }
}