import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/url_api.dart';
import 'package:app/localization/localization.dart';

class AddNewAccount extends StatefulWidget {

  @override
  _AddNewAccountState createState() => _AddNewAccountState();
}

class _AddNewAccountState extends State<AddNewAccount> {

  bool isLoading = false;
  String currentLang = '2';
  String wrongLogin='';
  SharedPreferences sharedPreferences;
  var jsonResponse ;
  String currentFont='Khmer';

  @override
  void initState(){
    currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
    super.initState();
//    checkLoginStatus();
  }
//  checkLoginStatus() async {
//    sharedPreferences = await SharedPreferences.getInstance();
//    if(sharedPreferences.getStringList("token") != null) {
//      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);
//    }
//  }

  final TextEditingController stuIdController = new TextEditingController();
  final TextEditingController stuPasswordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    Locale _temp;
    return  Scaffold(
        //resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,

        appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: InkWell(
              child: Text(lang.tr("Cancel"),style:TextStyle(
                  fontSize: 18.0,
                  fontFamily: currentFont)),
              onTap: (){
                Navigator.pop(context);
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
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors:<Color>[
                      Color(0xff054798),
                      Color(0xff009ccf),
                    ]
                ),
              ),
              child: new Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        new Image.asset('images/schoollogo.png',width:120.0,),
                        SizedBox(height: 15.0),
                        new Text(lang.tr('SCHOOL_NAME_KH').toString(),
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            decoration: TextDecoration.none,
                            fontFamily: 'Khmermoul',
                          ),
                        ),
                        new Text(lang.tr('SCHOOL_NAME_EN'),
                            style: new TextStyle(
                                fontSize: 16.0,
                                color: Colors.white.withOpacity(0.9),
                                decoration: TextDecoration.none,
                                textBaseline: TextBaseline.alphabetic
                            )),
                        SizedBox(height:20.0),
                        new Text(wrongLogin,
                            style: new TextStyle(
                                fontSize: 12.0,
                                color: Colors.redAccent,
                                decoration: TextDecoration.none,
                                textBaseline: TextBaseline.alphabetic
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                      child: new Form(
                          key : _formKey,
                          child: Column(
                              children: <Widget>[

                                new TextFormField(
                                  controller: stuIdController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return lang.tr("REQUIRED_STUDENT_ID");
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    hintText: lang.tr("STUDENT_ID"),hintStyle: TextStyle(
                                      color:Color(0xffcfdfe8),
                                      fontWeight:FontWeight.bold,fontStyle:FontStyle.italic,
                                      fontFamily: currentFont),
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: new OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                    ),
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
                                      return lang.tr("REQUIRED_PASSWORD");
                                    }
                                    return null;
                                  },
                                  controller: stuPasswordController,
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText:lang.tr("PASSWORD"),hintStyle: TextStyle(
                                      color:Color(0xffcfdfe8),fontWeight:
                                      FontWeight.bold,fontStyle:FontStyle.italic,
                                  fontFamily: currentFont),
                                    contentPadding: EdgeInsets.all(10.0),
                                    border: new OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 1.0),
                                    ),
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
                                        Text(lang.tr("LOGIN"),
                                          style: TextStyle(color:Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              fontFamily: currentFont
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
                                        if (stuIdController.text == "" || stuPasswordController.text == "") {
                                          return null;
                                        } else {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          studentLogin(stuIdController.text,
                                              stuPasswordController.text);
                                        }
                                      }
                                    }
                                ),
                              ]
                          )
                      )
                  )
                ],
              )
          ),
        )
    );
  }
  Future studentLogin(String stuId, String password) async {

    Map data = {
      'studentCode': stuId,
      'password': password,
      'deviceType': '1',
      'mobileToken': 'asdkfwerqwer',
    };
    var response = await http.post(StringData.loginUrl,
        body: data);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = jsonDecode(response.body);
    if(response.statusCode == 200){
      if(jsonResponse != null){
        if(jsonResponse['code'].toString()=='SUCCESS'){
          setState((){
            isLoading = false;
            sharedPreferences.setString("token", jsonResponse['result']['id'].toString());
            sharedPreferences.setString("studentId",  jsonResponse['result']['id'].toString());
            sharedPreferences.setString("stuCode",  jsonResponse['result']['stuCode'].toString());
            sharedPreferences.setString("stuNameKH",  jsonResponse['result']['stuNameKH'].toString());
            sharedPreferences.setString("stuFirstName",  jsonResponse['result']['stuFirstName'].toString());
            sharedPreferences.setString("stuLastName",  jsonResponse['result']['stuLastName'].toString());
            sharedPreferences.setString("photo",  jsonResponse['result']['photo'].toString());
            sharedPreferences.setString("currentLang",currentLang);
            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeApp()), (Route<dynamic> route) => false);
          });

        }else{//wrong password
          setState((){
            wrongLogin='Wrong User Name and Password';
            isLoading = false;
          });
        }
      }
    }else{
      wrongLogin='can not login!';
      isLoading = false;
    }
  }
}
