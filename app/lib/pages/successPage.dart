import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:app/pages/settingPage.dart';

class SuccessPage extends StatefulWidget {
  final String studentId,currentLang;
  SuccessPage({this.studentId,this.currentLang});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  bool isLoading = false;
  String wrongLogin='';
  var jsonResponse ;


  final TextEditingController currentPasswordController = new TextEditingController();
  final TextEditingController reTypePasswordController = new TextEditingController();
  final TextEditingController newPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);

    return  Scaffold(
        resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: new Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top:40.0,left:10.0,bottom:10.0,right: 10.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    stops: [
                      0.3,
                      6
                    ],
                    colors:[
                      Color(0xff07548f),
                      Color(0xff1290a2),
                    ],
                  ),
                ),
                child: new Column(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 90,
                            height: 90,
                            child: Hero(
                                tag: "hero",
                                child: CircleAvatar(
                                 child:Icon(Icons.done,size: 50.0,color: Colors.white70),
                                )),
                          ),
                          SizedBox(height: 15.0),
                          new Text(lang.tr('Changed Success'),
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white.withOpacity(0.9),
                                  decoration: TextDecoration.none,
                                  textBaseline: TextBaseline.alphabetic
                              )),
                          SizedBox(height:100.0),
                          InkWell(
                            child: Text(lang.tr('Go Back'),
                                style: new TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white70.withOpacity(0.9),
                                    decoration: TextDecoration.none,
                                    textBaseline: TextBaseline.alphabetic
                                )),
                            onTap: (){
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SettingPage(studentId:widget.studentId,currentLang:widget.currentLang)), (Route<dynamic> route) => false);
                            },
                          )


                        ],
                      ),
                    ),

                  ],
                )
            ),
          )
    );
  }
  changePassword(currentPassword, newPassword) async {
  }
}
