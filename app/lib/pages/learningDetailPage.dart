import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
//import '../url_api.dart';


class LearningDetailPage extends StatefulWidget {
  final List rowData;
  final String currentLang;

  LearningDetailPage({this.currentLang,this.rowData});

  @override
  _LearningDetailPageState createState() => _LearningDetailPageState();
}

class _LearningDetailPageState extends State<LearningDetailPage> {
  List learningList = new List ();
  bool isLoading = true;
  @override
  void initState(){
    learningList = widget.rowData;
    isLoading = false;
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
                  Image.asset('images/elearning.png',height: 50.0),
                  SizedBox(width: 10.0),
                  Text(lang.tr('Detail'),
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
            flex: 10,
            child:  Container(
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
              child:  Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
                ),
                child: Padding(
                    padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
                    child: Container(
                        child:isLoading ? new Center(
                            child: new CircularProgressIndicator()) :  ListView.builder (
                            itemCount: learningList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  _buildCategoryItems(learningList[index]);
                            }
                        )
                )
                ),
              )
          ),
          ),

        ],
      )
    );
  }

  Widget _buildCategoryItems(rowData) {
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
              debugPrint('link to video page');
//              Navigator.of(context).push(MaterialPageRoute(
////                  builder: (context) => AttendanceDetailPage(studentId:widget.studentId, currentLang:widget.currentLang,currentMonth:rowData['dateAttendence'],groupId:rowData['group_id'],rowData:rowData)
//              ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.play_circle_filled,color:Colors.redAccent,size: 50.0),
                      ),
                      _rowTitleCategory(rowData['category_title'],rowData['created_date']),
                    ]
                  )
                ),
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Icon(Icons.arrow_forward_ios,color: Colors.redAccent),
                  ),
                )
              ],
            )
        )
    );
  }
  Widget _rowTitleCategory(String stringData,String stringData1){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
           Text(stringData,
            style: TextStyle(fontFamily: 'Khmer',fontSize: 12.0),
            overflow: TextOverflow.visible),
          Text(
            stringData1, style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0
            )
          ),
        ]
    );
  }
}