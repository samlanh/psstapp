import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../url_api.dart';

class ProfilePage extends StatefulWidget {
  final String studentId;
  final String currentLang;
  ProfilePage({this.studentId,this.currentLang});
  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {
  List rsProfileList = new List();
  bool isLoading = true;
  String currentFont='Khmer';

  @override
  void initState() {
    super.initState();
    _getJsonProfile();

  }
  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    String noValue = lang.tr("N/A");
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(lang.tr("Student Profile"),
          style: TextStyle(fontFamily: currentFont,
          fontSize: 18.0)),
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
          )),
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
                              borderRadius: new BorderRadius.vertical(
                                  top: new Radius.elliptical(
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width, 100.0)),
                            ),
                            child: Column(
                              children: <Widget>[
                                rowStudentTitle(Icon(Icons.person_outline, color: Color(0xff07548f)),lang.tr("STUDENT_INFO")),
                                rowStudentData(lang.tr("NAME_IN_KHMER"),rsProfileList[0]['stu_khname'].toString()),
                                rowStudentData(lang.tr("NAME_IN_LATIN"), rsProfileList[0]['name_englsih'].toString()),
                                rowStudentData(lang.tr("STUDENT_ID"), rsProfileList[0]['stu_code'].toString()),
                                rowStudentData(lang.tr("GENDER"),  rsProfileList[0]['genderTitle'].toString()),
                                rowStudentData(lang.tr("DOB"),  rsProfileList[0]['dob'].toString()),

                                rowStudentData(lang.tr("NATION"),  rsProfileList[0]['nationality'].toString()),
                                rowStudentData(lang.tr("TEL"),  rsProfileList[0]['tel'].toString()),
                                rowStudentData(lang.tr("PRIMARY_TEL"), rsProfileList[0]['PrimaryContact'].toString()),
                                SizedBox(height: 15.0, width: 10.0),
                                rowStudentTitle(Icon(Icons.pin_drop, color: Color(0xff07548f)),lang.tr("ADDRESS")),
                                rowStudentData(lang.tr("POB"),rsProfileList[0]['pob'].toString()!=''? rsProfileList[0]['pob'].toString():noValue),
                                rowStudentData(lang.tr("CURRENT_ADDRESS"), "#"+rsProfileList[0]['home_num'].toString()+", "+rsProfileList[0]['street_num'].toString()+", "+rsProfileList[0]['village_name'].toString()+", "+rsProfileList[0]['communeTitle'].toString()+", "+rsProfileList[0]['districtTitle'].toString()+", "+rsProfileList[0]['provinceTitle'].toString()),

                                SizedBox(height: 15.0, width: 10.0),
                                rowStudentTitle(Icon(Icons.person, color: Color(0xff07548f)),lang.tr("FATHER_INFO").toString()),
                                rowStudentData(lang.tr("FATHER_NAME"), rsProfileList[0]['father_enname'].toString()),
                                rowStudentData(lang.tr("DOB"), rsProfileList[0]['father_dob'].toString()!=''? rsProfileList[0]['father_dob'].toString():noValue),
                                rowStudentData(lang.tr("NATION"), rsProfileList[0]['fatherNation'].toString()!='null'? rsProfileList[0]['fatherNation'].toString():noValue),
                                rowStudentData(lang.tr("JOB"), rsProfileList[0]['fatherOccupation'].toString()!='null'? rsProfileList[0]['fatherOccupation'].toString():noValue),
                                rowStudentData(lang.tr("TEL"), rsProfileList[0]['father_phone'].toString()!=''? rsProfileList[0]['father_phone'].toString():noValue),

                                SizedBox(height: 15.0, width: 10.0),
                                rowStudentTitle(Icon(Icons.person_pin, color: Color(0xff07548f)), lang.tr("MOTHER_INFO").toString()),
                                rowStudentData(lang.tr("MOTHER_NAME"), rsProfileList[0]['mother_enname'].toString()),
                                rowStudentData(lang.tr("DOB"), rsProfileList[0]['mother_dob'].toString()!='null' ? rsProfileList[0]['mother_dob'].toString():noValue),
                                rowStudentData(lang.tr("NATION"), rsProfileList[0]['motherNation'].toString()!='null' ? rsProfileList[0]['motherNation'].toString():noValue),
                                rowStudentData(lang.tr("JOB"), rsProfileList[0]['motherOccupation'].toString() !='null' ? rsProfileList[0]['motherOccupation'].toString():noValue),
                                rowStudentData(lang.tr("TEL"), rsProfileList[0]['mother_phone'].toString()!='' ? rsProfileList[0]['mother_phone'].toString():noValue),

                                SizedBox(height: 15.0, width: 10.0),
                                rowStudentTitle(Icon(Icons.supervised_user_circle,color: Color(0xff07548f)),lang.tr("Guardian Info").toString()),
                                rowStudentData(lang.tr("Guardian_Name").toString(),rsProfileList[0]['guardian_enname'].toString()),
                                rowStudentData(lang.tr("DOB"),rsProfileList[0]['guardian_dob'].toString()!='' ? rsProfileList[0]['guardian_dob'].toString():noValue),
                                rowStudentData(lang.tr("NATION"),rsProfileList[0]['guardianNation'].toString()!='null' ? rsProfileList[0]['guardianNation'].toString():noValue),
                                rowStudentData(lang.tr("JOB"), rsProfileList[0]['guardian_job'].toString()!='null' ? rsProfileList[0]['guardian_job'].toString():noValue),
                                rowStudentData(lang.tr("TEL"),rsProfileList[0]['guardian_tel'].toString()!='' ? rsProfileList[0]['guardian_tel'].toString():noValue),
                              ],
                            )
                        )
                      ],
                    ),
                    // Profile image
                    Positioned(
                      top: 15.0, // (background container size) - (circle height / 2)
                      child: Container(
                        height: 120.0,
                        width: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color:Color(0xff009ccf),width: 4.0),
                          image: DecorationImage(
                             image: rsProfileList[0]['photo'].toString() ==''? AssetImage('images/studentprofile.png'):
                             NetworkImage(StringData.imageURL+'/photo/'+rsProfileList[0]['photo'].toString()),
                            fit: BoxFit.fill
                          )
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
  Widget rowStudentTitle(Icon icon,lableValue){
    return Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffcccccc).withOpacity(0.5),width: 2.0))
        ),
        child: Row(
          children: <Widget>[
            icon,
            Text(lableValue,style: TextStyle(fontFamily: 'Khmermoul',color: Color(0xff07548f),
                fontSize:14.0,fontWeight: FontWeight.bold)),
          ],
        )
    );
  }

  _getJsonProfile() async{
    final String urlApi = StringData.studentProfile+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    debugPrint(urlApi.toString());
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState((){
        currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          rsProfileList = json.decode(rawData.body)['result'] as List;
          isLoading = false;
        }
      });
    }
  }
  /*_getJsonProfile() async{
    final String urlApi ="https://www.googleapis.com/books/v1/volumes?q={http}";
   //debugPrint(urlApi);

    var response = await http.get(urlApi);
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      //rsProfileList = convert.jsonDecode(response.body)['result'] as List;
      isLoading = false;
      //print('Number of books about http: $itemCount.');

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }*/

  Widget rowStudentData(String labelData,lableValue){
    return Container(
      padding: EdgeInsets.only(left:5.0,right: 5.0,top:1.0,bottom:1.0),
      margin: EdgeInsets.only(left: 15.0,right: 10.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffededed),width: 1.0))
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(labelData,style: TextStyle(color: Color(0xff054798),fontWeight: FontWeight.w600,fontSize:14.0,
                fontFamily: currentFont)),
          ),
          Expanded(
            child: Text(lableValue,style: TextStyle(
                color: Color(0xff092952),
              fontFamily: currentFont,
              fontSize: 14.0
            )),
          )
        ],
      )
    );
  }
}

