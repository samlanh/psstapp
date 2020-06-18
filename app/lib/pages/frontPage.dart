import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import '../url_api.dart';
import 'package:app/main.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:app/functions/GrideFunction.dart';
//import '../classes/blogWiget.dart';

import 'package:app/pages/aboutPage.dart';
import 'package:app/pages/newsPage.dart';
import 'package:app/pages/coursePage.dart';
import 'package:app/pages/loginpage.dart';
import 'package:app/pages/calendarPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrontPage extends StatefulWidget {
  final String currentLang;
  FrontPage({this.currentLang});

  @override
  _FrontPageState createState() => _FrontPageState();

}

class _FrontPageState extends State<FrontPage> {

  List rsProfileList = new List();
  List grideList = getGride();
  bool isLoading = true;
  bool isLoadingaddress = true;
  List sliderList = new List();
 String currentLang='1';
  var contactList = {'title': '','address':'',
  'phone':''};
  SharedPreferences sharedPreferences;


  List<NetworkImage> imagesList = List<NetworkImage>();

  @override
  void initState() {
    checkLoginStatus();
    _getSlider();
    _getJsonContact();
    super.initState();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    currentLang = (Localizations.localeOf(context).languageCode == "km")?'1':'2';
    if(sharedPreferences.getString('token') != null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeApp()), (Route<dynamic> route) => false);
    }
  }


  @override
  Widget build(BuildContext context) {

    DemoLocalization lang = DemoLocalization.of(context);
    Locale _temp;

    return Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
              Image.asset('images/icon.png',height: 40.0,fit: BoxFit.fill,),
              SizedBox(width: 10.0),
              InkWell(child: Text(lang.tr("SCHOOL_NAME_KH"),style:TextStyle(fontSize: 16.0,fontFamily: 'Khmer',color: Colors.white)),
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeApp()), (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
          actions: <Widget>[
            GestureDetector(child:(Localizations.localeOf(context).languageCode == "km")?
            Image.asset('images/en.png',width: 32.0):Image.asset('images/kh.png',width: 32.0)
              ,onTap: (){
                this.setState((){
                  if(Localizations.localeOf(context).languageCode == "km") {
                    _temp = Locale('en','US');
                    currentLang='2';
                    MyApp().setLocale(context,_temp);
                  }else{
                    _temp = Locale('km','KH');
                    currentLang='1';
                    MyApp().setLocale(context,_temp);
                  }

                });
              },
            ),
//            new IconButton(icon: new Icon(Icons.notifications,color: Colors.redAccent.shade50,), onPressed: (){
//              Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationPage(studentId: studentId,currentLang:currentLang)));
//            }),
          ],
        flexibleSpace: Container(
//          color: Colors.white,
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
            child:  Stack(
              alignment: Alignment.center,
              children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 230.0,
                        width: MediaQuery.of(context).size.width,
                        child:  isLoading ? new Stack(alignment: AlignmentDirectional.center,
                            children: <Widget>[new CircularProgressIndicator()]) : sliderBlog(),
                      ),
                      Container(
                        height: 90.0,
//                        child: Text('Blank'),
                      ),
                      Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: Text("Video",style: TextStyle(color: Colors.red)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            appIntroductionBlog()
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          child: Column(children: <Widget>[
                            SizedBox(height: 20.0),
                            (isLoadingaddress==false)?
                            contactAddress(contactList):
                                Text('')
                          ]),
                        )
                      ),
                      copyRightBlog()
                    ],
                  ),
              Positioned(
                top: 220.0,
                child: Container(
                  height: 90.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                      boxShadow: <BoxShadow>[
                      new BoxShadow (
                          color: const Color(0xcce4e6e8),
                          offset: new Offset(0.0,9.0),
                          blurRadius: 40.0
                          )
                      ],
                      borderRadius: new BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                    ),
                  child:new GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: grideList.length,
                    itemBuilder: (BuildContext context ,int index){
                      return InkWell(
                        child: myGridMenu(context, index),
                        onTap: (){
                            routerAntherPage(index);
                        },
                      );
                    },
                  ), //
                ),
              )
              ],
            ),
          )
        ]
      )
    );
  }


  _getSlider() async{
    final String urlApi = StringData.slieshow;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          sliderList = json.decode(rawData.body)['result'] as List;
          for (var i = 0; i < sliderList.length; i++) {
            imagesList.add(NetworkImage(StringData.imageURL+'/slide/'+sliderList[i]['images'].toString()));
          }
          isLoading = false;
        }
      });
    }
  }


  _getJsonContact() async{
    final String urlApi = StringData.singlecontact+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
            contactList['title']= json.decode(rawData.body)['result']['title'].toString();
            contactList['description']= json.decode(rawData.body)['result']['description'].toString();
            contactList['phone']= json.decode(rawData.body)['result']['phone'].toString();
            contactList['email']= json.decode(rawData.body)['result']['email'].toString();
            contactList['website']= json.decode(rawData.body)['result']['website'].toString();
            contactList['facebook']= json.decode(rawData.body)['result']['facebook'].toString();
            contactList['youtube']= json.decode(rawData.body)['result']['youtube'].toString();
            contactList['instagram']= json.decode(rawData.body)['result']['instagram'].toString();
            isLoadingaddress = false;
        }
      });
    }
  }



  Widget sliderBlog(){
    return SizedBox(
        height: 220.0,
        width: MediaQuery.of(context).size.width,
        child:  Carousel(
          images:imagesList,
          dotSize: 0.0,
          dotSpacing: 0.0,
          dotColor: Color(0xff07548f),
          indicatorBgPadding: 0.0,
          dotBgColor: Colors.transparent,
          borderRadius: false,
          noRadiusForIndicator: false,
        )
    );
  }

  static List<MyGrideView> getGride(){
    var gridList = new List<MyGrideView>();
    gridList.add(new MyGrideView(("About us"), "Installment Management System", "images/about.png"));
    gridList.add(new MyGrideView(("COURSE"), "Enrollment Management System",  "images/studenthistory.png"));
    gridList.add(new MyGrideView(("News"), "Enrollment Management System",  "images/news.png"));
    gridList.add(new MyGrideView(("Calendar"), "Enrollment Management System",  "images/schedule.png"));
    return gridList;
  }

  void routerAntherPage(index){
    var router = new MaterialPageRoute(builder: (context){
      if(index==0){
        return new AboutPage(currentLang:widget.currentLang);
      }else if(index==1){
        return new CoursePage(title:grideList[index].name,currentLang:widget.currentLang);//course
      }else if(index==2){
        return new NewsEventPage(currentLang:widget.currentLang);//news
      }
      else if(index==3){
        return new CalendarPage(currentLang:widget.currentLang);//calendar
      }
    });
    Navigator.of(context).push(router);
  }

  Container myGridMenu(BuildContext context,int i){
    DemoLocalization lang = DemoLocalization.of(context);
    return Container(
        alignment: FractionalOffset.center,
        margin: EdgeInsets.all(1.0),
        child:Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.only(top: 10.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(4.0),
          ),
          child:  new Column(
            children: <Widget>[
              new Image.asset('${grideList[i].image}',width: 40.0,color: Color(0xff3568aa)),
              new SizedBox(height: 5.0),
              new Expanded(
                  child: new Text(lang.tr(grideList[i].name),
                      style: TextStyle(color:Color(0xff3568aa),//Colors.black54,
                          fontSize: 13.5,
                          fontFamily: 'Beba',
                          fontWeight: FontWeight.bold
                      )
                  )
              )
            ],
          ),
        )
    );
  }

  Widget copyRightBlog(){
    return Container(
      padding: EdgeInsets.only(top: 50.0,bottom: 20.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Text('Copyright© 2020 PSIS.',style:TextStyle(fontSize: 10.0,)),
          Text('All Rights Reserved.',style:TextStyle(fontSize: 10.0,)),
        ],
      ),
    );
  }
  Widget appIntroductionBlog(){
    DemoLocalization lang = DemoLocalization.of(context);
    return Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xffededed),width: 1.0))
        ),
        child: Column(
            children: <Widget>[
              Container(
                child: Text('សាលាបញ្ញាសាស្ត្រ​ សាខាទី១'
                    'បានបង្កើតកម្មវិធីលើទូរសព្ទដែលអោយសិស្យនិងអាណាព្យាបាលសិស្សអាចតាមដាន'
                    'ការសិក្សាបានដោយងាយស្រួល!',style: TextStyle(color: Color(0xff054798),fontSize:14.0,fontFamily: 'Khmer')),
              ),
              Text('សូមចុចចូលប្រើប្រាស់ខាងក្រោមដើម្បីប្រើប្រាស់។',style: TextStyle(color: Color(0xff054798),fontWeight: FontWeight.w600,fontSize:14.0,fontFamily: 'Khmer')),
              Container(
                child: Container(
                    padding: EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width,
                    child:  FloatingActionButton.extended(
                        onPressed: () {
//                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
                          Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                        },
                        label: Text(lang.tr('LOGIN'),style: TextStyle(fontFamily: 'Khmer',fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.person_pin),
                        backgroundColor: Colors.redAccent
                    )
                ),
              )
            ]
        )
    );
  }

  Widget contactAddress(dataRow) {
    return Container(
      padding: EdgeInsets.only(left: 5.0,bottom: 5.0,right: 5.0),
      margin: EdgeInsets.only(left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
              ),
            ),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text("- " + contactList['title'].toString(),
              style: TextStyle(fontSize: 14.0, fontFamily: 'Khmer'),
            ),
          ),
          rowContact(Icon(Icons.pin_drop, color: Color(0xff2a62b4)),
              dataRow['description'].toString(), 2),
          SizedBox(height: 10.0),
          rowContact(Icon(Icons.call, color: Color(0xff2a62b4)),
              dataRow['phone'].toString(), 1),
          SizedBox(height: 10.0),
          rowContact(Icon(Icons.email, color: Color(0xff2a62b4)),
              dataRow['email'].toString(), 1),
          SizedBox(height: 10.0),
          rowContact(Icon(Icons.language, color: Color(0xff2a62b4)),
              dataRow['website'].toString(), 1),
          SizedBox(height: 25.0),
          Text("Find us", style: TextStyle(fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black45)),
          SizedBox(height: 10.0),
          Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                      child: GestureDetector(
                          child:  Image.asset(
                              'images/call.png',fit: BoxFit.fill,width: 50.0),
                          onTap: () async {
                            if (await canLaunch("tel://" + dataRow['phone']
                                .toString())) { //"tel://+85570418002"
                              await launch(
                                  "tel://" + dataRow['phone'].toString());
                            }
                          }
                      )
                  ),
                  SizedBox(width: 10.0),
                  Container(
                      child: GestureDetector(
                        child:Image.asset(
                        'images/facebook.png', fit: BoxFit.fill,width: 50.0),
                        onTap: () async {
                          if (await canLaunch(dataRow['facebook'].toString())) {
                            await launch(dataRow['facebook'].toString());
                          }
                        },//
                      )
                  ),

                  SizedBox(width: 10.0),
                  Container(
                      child: GestureDetector(
                          onTap: () async {
                            if (await canLaunch(
                                dataRow['instagram'].toString())) {
                              await launch(dataRow['instagram'].toString());
                            }
                          },
                          child: Image.asset(
                            'images/telegram.png', fit: BoxFit.fill,width: 50.0)
                      )
                  ),
                  SizedBox(width: 10.0),
                  Container(
                      child: GestureDetector(
                          onTap: () async {
                            if (await canLaunch(dataRow['youtube'].toString())) {
                              await launch(dataRow['youtube'].toString());
                            }
                          },
                          child: Image.asset(
                              'images/youtube.png', fit: BoxFit.fill,width: 50.0)
                      )
                  ),

                ],
              )
          )
        ],
      ),
    );
  }

  Widget rowContact(Icon icon, String textLabel, int type) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        icon,
        SizedBox(width: 10.0),
        Expanded(
            child: (type == 1) ? Text(
                textLabel,
                style: TextStyle(fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black45)
            ) : Html(
              data: textLabel,
            )
        )
      ],
    );
  }

  Widget circelContact(Color strColor, String strText, Icon icon, type) {
    return Container(
      height: 70.0,
      width: 70.0,
      decoration: BoxDecoration(
        color: strColor,
        shape: BoxShape.circle,
      ),
      child: Center(
          child: (type == 1) ?
          Text(strText, style: TextStyle(
              color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold)) :
          icon
      ),
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


}

