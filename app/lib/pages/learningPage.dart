import 'package:flutter/material.dart';
import 'package:app/pages/learningDetailPage.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';

class LearningPage extends StatefulWidget {
  final String studentId;
  final String currentLang;
  LearningPage({this.studentId,this.currentLang});
  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  List learningList = new List();
  bool isLoading = true;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    _getJsonVideoList();
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
                  Text(lang.tr('Study History'),
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
                          Colors.red,
                          Colors.redAccent.withOpacity(0.9),
                        ])
                ),
              ),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 10,
                child: isLoading ? new Center(
                  child: new CircularProgressIndicator(),
                )
            :Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Colors.red,
                      Colors.redAccent.withOpacity(0.9),
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
//                        height: MediaQuery.of(context).size.height,
                        child: learningList.isNotEmpty
                            ? ListView.builder (
                            itemCount: learningList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return  _buildCategoryItems(learningList[index]);
                            }
                        ):Center(child:Text("No Result !"))
                )
                ),
              )
          ),
          ),

        ],
      )
    );
  }

  _getJsonVideoList() async{
    final String urlApi = StringData.eLearning+"&currentLang="+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          learningList = json.decode(rawData.body)['result'] as List;
          isLoading = false;
        }
      });
    }
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LearningDetailPage(currentLang:widget.currentLang,rowData:rowData['sub_cate'])
              ));
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