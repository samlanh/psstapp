import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app/url_api.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:app/localization/localization.dart';
import 'package:app/pages/successPage.dart';
import 'package:app/pages/settingPage.dart';

class ChangePassword extends StatefulWidget {
  final String studentId,currentLang;
  ChangePassword({this.studentId,this.currentLang});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = false;
  String wrongLogin='';
  var jsonResponse ;

  @override
//  void initState(){
//    super.initState();
//  }

  final TextEditingController currentPasswordController = new TextEditingController();
  final TextEditingController reTypePasswordController = new TextEditingController();
  final TextEditingController newPasswordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);

    return Scaffold(
//        resizeToAvoidBottomPadding: false,
//          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: InkWell(
              child: Text("Cancel",style:TextStyle(fontSize: 18.0)),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SettingPage(studentId:widget.studentId,currentLang:widget.currentLang)), (Route<dynamic> route) => false);
              },
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors:<Color>[
                    Color(0xff07548f),
                    Color(0xff07548f),
                  ]
                )
              ),
            )
          ),
          body: SingleChildScrollView(
            child: new Container(
              height: MediaQuery.of(context).size.height,
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
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.blur_circular,size: 120.0,color: Colors.white70),
                        SizedBox(height: 15.0),

                        new Text(lang.tr('CHANGE_PASSWORD'),
                          style: new TextStyle(
                              fontSize: 22.0,
                              color: Colors.white.withOpacity(0.9),
                              decoration: TextDecoration.none,
                              textBaseline: TextBaseline.alphabetic
                          )),
                        SizedBox(height:20.0),
                        new Text(wrongLogin,
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Colors.redAccent.withOpacity(0.9),
                              decoration: TextDecoration.none,
                              textBaseline: TextBaseline.alphabetic
                          )),
                      ],
                    ),
                  ),
                  Expanded(flex: 5,
                    child: new Form(
                      key : _formKey,
                      child: Column(
                        children: <Widget>[

                          new TextFormField(
                            controller: currentPasswordController,
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return lang.tr("REQUIRED_PASSWORD");
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: lang.tr("CURRENT_PASSWORD"),hintStyle: TextStyle(color:Color(0xffcfdfe8),fontWeight:
                              FontWeight.bold,fontStyle:FontStyle.italic),
                              contentPadding: EdgeInsets.all(10.0),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                            ),
                          ),

                          SizedBox(height:20.0),

                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                  return lang.tr("REQUIRED");
                              }
                              return null;
                            },
                            controller: newPasswordController,
                            decoration: InputDecoration(
                              hintText: lang.tr("NEW_PASSWORD"),hintStyle: TextStyle(color:Color(0xffcfdfe8),fontWeight:
                            FontWeight.bold,fontStyle:FontStyle.italic),
                              contentPadding: EdgeInsets.all(10.0),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                            ),
                          ),

                          SizedBox(height:10.0),

                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if(value.isEmpty){
                                return lang.tr("REQUIRED");
                              }
                              if(value!=newPasswordController.text){
                                return lang.tr('PASSWORD_NOT_MATCH');
                              }
                              return null;
                            },
                            controller: reTypePasswordController,
                            decoration: InputDecoration(
                              hintText: lang.tr("RETYPE_PASSWORD"),hintStyle: TextStyle(color:Color(0xffcfdfe8),fontWeight:
                              FontWeight.bold,fontStyle:FontStyle.italic),
                              contentPadding: EdgeInsets.all(10.0),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.white, width: 1.0),
                              ),
                            ),
                          ),
                          SizedBox(height:20.0),
                          MaterialButton(
                            height: 60.0,
                            minWidth:MediaQuery.of(context).size.width,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
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
                            onPressed:() {
                              if (_formKey.currentState.validate()) {
                                if (currentPasswordController.text == "" || newPasswordController.text == "" || reTypePasswordController.text == "" ) {
                                  return null;
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  changePassword(currentPasswordController.text,newPasswordController.text);
                                }
                              }
                            }
                          ),
                        ],
                      ),)
                  )
                ],
              )
            ),
          )
    );
  }
  changePassword(currentPassword, newPassword) async {

    DemoLocalization lang = DemoLocalization.of(context);
    Map data = {
      'stu_id': widget.studentId,
      'oldPassword': currentPassword,
      'newPassword': newPassword
    };

    var response = await http.post(StringData.changePassword, body: data);
    if(response.statusCode == 200){
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null){
        if(jsonResponse['code'].toString()=='SUCCESS'){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SuccessPage(studentId: widget.studentId,currentLang:widget.currentLang)), (Route<dynamic> route) => false);
      }else{
          setState(() {
            wrongLogin=lang.tr(jsonResponse['message'].toString());
          });
        }
      }
    }
  }
}
