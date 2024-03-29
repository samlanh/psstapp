import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
import 'package:app/localization/localization.dart';
import 'package:app/pages/scoreDetailPage.dart';

class ScorePage extends StatefulWidget {

  final studentId,currentLang;
  ScorePage({this.studentId,this.currentLang});
  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {

  List scoreList = new List();
  bool isLoading = true;
  String currentFont='Khmer';

  @override
  void initState(){
    _getJsonScore();
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
            Image.asset('images/score.png',height: 50.0),
            SizedBox(width: 10.0),
            Text(lang.tr('Score'),
              style: TextStyle(
                fontFamily: currentFont,
                fontSize: 16.0,
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
      body: Column(
        children: <Widget>[
          Expanded(
            child:  Container(
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: isLoading ? new Center(
                      child: new CircularProgressIndicator()) :
                      scoreList.isNotEmpty ? ListView.builder (
                      itemCount: scoreList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  _buildScoreItem(scoreList[index]);
                      }
                    )
                    :Center(
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
            )
          )
        ]
      )
    );
  }


  _getJsonScore() async{
    final String urlApi = StringData.score+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          scoreList = json.decode(rawData.body)['result'] as List;
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
             child: Text(strData,style:TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold)
             )
           )
         )
       ]
     );
  }

  Widget _buildScoreItem(rowData) {
    DemoLocalization lang = DemoLocalization.of(context);
    String forSemesterName= lang.tr('FOR_SEMESTER');
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
            )
          ]
        ),
        padding: EdgeInsets.only(right: 5.0),
        child: InkWell(
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ScoreDetailPage(studentId:widget.studentId, currentLang:widget.currentLang,scoreId:rowData['id'],rowData:rowData)
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child:Container(
                  padding: EdgeInsets.all(5.0),
                  color: Color(0xff07548f),
                  child: _rowTitleScore(rowData['for_month'],forSemesterName+rowData['forSemesterId'].toString(),rowData['academicYear'].toString(),Image.asset("images/score.png",width:40.0),20.0),
                )
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
                      _rowScoreType(lang.tr('Total Score'),rowData['totalScore'].toString()),
                      _rowScoreType(lang.tr('Score Average'),rowData['totalAverage'].toString()),
                      _rowScoreType(lang.tr('MentionGrade'),rowData['metionGrade'].toString()),
                      _rowScoreType(lang.tr('Mention'),rowData['mention'].toString()),
                      _rowScoreType(lang.tr('Result'),lang.tr(rowData['restultStatus'].toString())),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(lang.tr("Rank")+" "+rowData['rank'].toString(),style: TextStyle(
                          fontFamily: currentFont,
                          fontSize: 14.0,color:Colors.red.shade700,fontWeight: FontWeight.w600),),
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


  Widget _rowTitleScore(forMonth,forSemester,year,Image image, double fontSize){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          image,
          Text(forMonth, style:TextStyle(
            fontFamily: currentFont,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white
            )
          ),
          SizedBox(height: 5.0),
          Text(forSemester, style:TextStyle(
              fontFamily: currentFont,
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.white
            )
          ),
          SizedBox(height: 10.0),
          Text(year, style:TextStyle(
            fontFamily: currentFont,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white
            )
          )
        ]
    );
  }


  Widget _rowScoreType(String textData, String priceData){
    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26,width: 1.0))
      ),
      child: Row(
        children: [
           Expanded(
             child: Text(textData,style: TextStyle(
               fontFamily: currentFont,
               fontSize: 14.0,
               fontWeight: FontWeight.w500,
               color: Color(0xff07548f).withOpacity(0.9))
             )
           ),
           Expanded(
             child:  Align(
               alignment: Alignment.topRight,
               child: Text(priceData,style: TextStyle(
                 fontFamily: currentFont,
                 fontSize: 14.0,
                 fontWeight: FontWeight.bold,
                 color: Color(0xff07548f),
                 fontStyle: FontStyle.italic
               )
               ),
             ),
           )
        ]
      )
    );
  }
}