import 'package:flutter/material.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
import 'package:app/pages/changePassword.dart';
import 'package:app/main.dart';

class SettingPage extends StatefulWidget {

  final String studentId;
  final String currentLang;

  SettingPage({this.studentId,this.currentLang});

  @override
  _SettingPageState createState() => _SettingPageState();

}

class _SettingPageState extends State<SettingPage> {
  List rsProfileList = new List();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getJsonProfile();
  }
  @override
  Widget build(BuildContext context) {

    DemoLocalization lang = DemoLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: InkWell(
          child: Text("Cancel",style:TextStyle(fontSize: 18.0)),
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeApp()), (Route<dynamic> route) => false);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors:<Color>[
                Color(0xff054798),
                Color(0xff009ccf),
              ])
          ),
        )
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.centerRight,
              colors:[
                Color(0xff054798),
                Color(0xff009ccf),
              ],
            ),
          ),
            child: isLoading ? new Stack(alignment: AlignmentDirectional.center,
                children: <Widget>[new CircularProgressIndicator()]): Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 75.0,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 70.0,),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.vertical(top: new Radius.elliptical(MediaQuery.of(context).size.width, 100.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          rowStudentTitle(Icon(Icons.person_outline,color: Color(0xff07548f)),lang.tr("STUDENT_INFO")),
                          rowStudentData(lang.tr("STUDENT_ID"), rsProfileList[0]['stu_code'].toString()),
                          rowStudentData(lang.tr("NAME_IN_KHMER"),rsProfileList[0]['stu_khname'].toString()),
                          rowStudentData(lang.tr("NAME_IN_LATIN"), rsProfileList[0]['name_englsih'].toString()),
                          rowStudentData(lang.tr("GENDER"),  rsProfileList[0]['genderTitle'].toString()),
                          rowStudentTitle(Icon(Icons.format_align_center,color: Color(0xff07548f)),lang.tr("ភាសា")),
                          rowStudentData(lang.tr("ភាសា"),"ខ្មែរ"),
                          rowStudentData(lang.tr("ភាសា"),"ខ្មែរ"),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            child: MaterialButton(
                              height: 60.0,
                              minWidth:MediaQuery.of(context).size.width,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              color:Color(0xff19a3b7),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  Text(lang.tr("CHANGE_PASSWORD"),
                                    style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,
                                        fontSize: 18.0
                                    ),
                                  ),
                                  Container(
                                    alignment: FractionalOffset.centerRight,
                                    child: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 28.0),
                                  )
                                ],
                              ),
                              onPressed:(){
                                Navigator.push(context,MaterialPageRoute(builder: (context) => ChangePassword(studentId: widget.studentId,currentLang:widget.currentLang)));
                              }
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
                Positioned(
                  top: 15.0,
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color:Color(0xff009ccf),width: 4.0),
                      image: DecorationImage(
                        image: AssetImage('images/student1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]
      )
    );
  }
  Widget rowStudentTitle(Icon icon,labelValue){
    return Container(
      padding: EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        color: Color(0xff19a3b7).withOpacity(0.6),
        border: Border(bottom: BorderSide(color: Color(0xffcccccc).withOpacity(0.5),width: 2.0)),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: const Color(0xcce4e6e8),
            offset: new Offset(2.0,2.0),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          icon,Text(labelValue,style: TextStyle(fontFamily: 'Khmermoul',color: Color(0xff07548f),
              fontSize:14.0,fontWeight: FontWeight.bold)),
        ],
      )
    );
  }

  _getJsonProfile() async{
    final String urlApi = StringData.studentProfile+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState((){
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          rsProfileList = json.decode(rawData.body)['result'] as List;
          isLoading = false;
        }
      });
    }
  }

  Widget rowStudentData(String labelData,labelValue){
    return Container(
      padding: EdgeInsets.only(left:5.0,right: 5.0,top:5.0,bottom:5.0),
      margin: EdgeInsets.only(left: 15.0,right: 10.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffededed),width: 1.0))
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(labelData,style: TextStyle(color: Color(0xff054798),fontWeight: FontWeight.w600,fontSize:14.0,fontFamily: 'Khmer')),
          ),
          Expanded(
            child: Container(
              child: Text(labelValue,style: TextStyle(color: Color(0xff092952))),
            )
          )
        ],
      )
    );
  }
}

