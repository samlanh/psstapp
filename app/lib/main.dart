
import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:splashscreen/splashscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app/functions/GrideFunction.dart';
import 'package:app/pages/loginpage.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:app/pages/paymentPage.dart';
import 'package:app/pages/schedulePage.dart';
import 'package:app/localization/localization_constands.dart';
import 'package:app/pages/profilePage.dart';
import 'package:app/pages/settingPage.dart';
import 'package:app/pages/valuationPage.dart';
import 'package:app/pages/newsPage.dart';
import 'package:app/pages/aboutPage.dart';
import 'package:app/pages/calendarPage.dart';
import 'package:app/pages/attendancePage.dart';
import 'package:app/pages/disciplinePage.dart';
import 'package:app/pages/scorePage.dart';
import 'package:app/pages/notification.dart';
import 'package:app/pages/learningPage.dart';
import 'package:app/pages/frontPage.dart';
//import 'package:app/pages/contactPage.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'url_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:connectivity/connectivity.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget{

  void setLocale(BuildContext context,Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp>{


  Locale _locale;
  SharedPreferences sharedPreferences;
  void setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies(){
    getLocale().then((locale){
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  bool isLogin=false;

  @override
  void initState(){
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString('token') != null) {
      setState(() {
        isLogin=true;
      });
    }
  }

  @override
  Widget build(BuildContext context)  {


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if(_locale==null){
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: _locale,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('km', 'KH')
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
            return locale;
          },
          home: new SplashScreen(
            seconds:1,
            navigateAfterSeconds: isLogin ? new HomeApp(): new FrontPage(currentLang:'1'),//HomeApp(),//LoginPage()//if login home:FrontPage
            title: new Text('PSIS',),
            image: new Image.asset('images/schoollogo.png',width: 120),
            gradientBackground:  LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [
                0.3,
                0.6,
                6
              ],
              colors:[
                Color(0xff3568aa),
                Color(0xff357fad),
                Color(0xff3289a5),
              ],
            ),
            styleTextUnderTheLoader: new TextStyle(),
            photoSize: 100.0,
          )
      );
    }
  }
}



class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  void _changeLanguage(languageCode) async{
    Locale _temp = await setLocale(languageCode);
    MyApp().setLocale(context,_temp);
  }

  SharedPreferences sharedPreferences;
  List grideList = getGride();
  String studentName='';
  String stuCode='';
  String photo='';
  String studentId='';
  String title='';
  String currentLang = '1';
  List sliderList = new List();
  bool isLoading = true;
  List<NetworkImage> imagesList = List<NetworkImage>();

  bool connectResult = true;


  @override
  void initState() {
    checkInternetStatus();
    checkLoginStatus();
    _getSlider();
    super.initState();
  }

  void checkInternetStatus() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          connectResult = true;
        });
      } else {
        setState(() {
          connectResult = false;
        });
      }
    });
  }
//  void ChangeValues(String resultval) {
//    setState(() {
//      connectResult = resultval;
//
//    });
//  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    currentLang = (Localizations.localeOf(context).languageCode == "km")?'1':'2';
    if(sharedPreferences.getString('token') == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => FrontPage(currentLang:currentLang)), (Route<dynamic> route) => false);
//      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
      studentName = sharedPreferences.getString('stuNameKH');
      stuCode = sharedPreferences.getString('stuCode');
      studentId = sharedPreferences.getString('studentId');
      photo = sharedPreferences.getString('photo');
     //sharedPreferences.getString('currentLang');
    }
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

  Widget sliderContainer(){
    return SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        child:  Carousel(
        images:imagesList,
          dotSize: 10.0,
          dotSpacing: 10.0,
          dotColor: Color(0xff07548f),
          indicatorBgPadding: 10.0,
          dotBgColor: Colors.transparent,
          borderRadius: false,
        )
      );
  }
  @override
  Widget build(BuildContext context) {
    DemoLocalization myLocale = DemoLocalization.of(context);
    return  Scaffold(
      appBar : new AppBar(
        backgroundColor: Color(0xff07548f),
        elevation: 0.0,
        title: new Text(myLocale.tr('school_name')),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(child:(Localizations.localeOf(context).languageCode == "km")?
          Image.asset('images/en.png',width: 32.0):Image.asset('images/kh.png',width: 32.0)
            ,onTap: (){
              this.setState((){
              String languageCode='en';
                if(Localizations.localeOf(context).languageCode == "km") {
                  languageCode = 'en';
                  currentLang = '2';
                }else{
                  currentLang = '1';
                  languageCode = 'km';
                }
                _changeLanguage(languageCode);
              });
            },
          ),
          new IconButton(icon: new Icon(Icons.notifications,color: Colors.redAccent.shade50,), onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => NotificationPage(studentId: studentId,currentLang:currentLang)));
          }),
        ],
      ),
      drawer: leftMenu(context),
      body: new Container(
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
          child: Column(
            children: <Widget>[
                Container(
                  decoration: BoxDecoration(
//                    color:Colors.red, //Color(0xff1290a2),
                    boxShadow: <BoxShadow>[
                      new BoxShadow (
                        color:Colors.black12,
                        offset: new Offset(0,2.0),
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: isLoading ? new Stack(alignment: AlignmentDirectional.center,
                      children: <Widget>[new CircularProgressIndicator()]) : sliderContainer()//sliderContence()
                ),
                Expanded(
                  flex:4,
                  child:
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                              image: new ExactAssetImage('images/bordermenu.png'),
                              fit: BoxFit.scaleDown,
                              alignment: FractionalOffset.topCenter
                          ),
//                          color: Colors.red
                        ),

                        margin: EdgeInsets.only(top: 8.0),
                        child: new GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: grideList.length,
                          itemBuilder: (BuildContext context ,int index){
                            return InkWell(
                              child: myGridMenu(context, index),
                              onTap: (){
                                if(connectResult==true) {
                                  routerAntherPage(index);
                                }else{
                                   return _showDialog();
                                }
                              },
                            );
                          },
                        ),
                      )
                    ],
                  )
              ),
            ],
          )
      ),
    );

  }
  void _showDialog() {
    DemoLocalization lang = DemoLocalization.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(lang.tr("CHECK_INTERNET_CONNECTION"),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  void routerAntherPage(index){

      var router = new MaterialPageRoute(builder: (context){
        if(index==0){
          return CoursePage(title:grideList[index].name,studentId: studentId,currentLang:currentLang);
        }else if(index==1){
          return new SchedulePage(title:grideList[index].name,studentId: studentId,currentLang:currentLang);
        }else if(index==2){
          return new AttendancePage(studentId: studentId,currentLang:currentLang);
        }else if(index==3){
          return new ScorePage(studentId: studentId,currentLang:currentLang);
        }else if(index==4){
          return new DisciplinePagePage(studentId: studentId,currentLang:currentLang);
        }else if(index==5){
          return new CalendarPage(currentLang:currentLang);
        }else if(index==6){
          return new LearningPage(studentId: studentId,currentLang:currentLang);
        }else if(index==7){
          return new NewsEventPage(currentLang:currentLang);
        }else if(index==8){
          return new AboutPage(currentLang:currentLang);
        }
      });
      Navigator.of(context).push(router);
  }
  Drawer leftMenu(BuildContext context){

    DemoLocalization lang = DemoLocalization.of(context);
    return new Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex:5,
              child:Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top:30.0,left: 10,right: 10.0,bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(width: 4.0,color: Colors.white)),
                  color: Color(0xff156e97),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 80,
                      height: 80,
                      child: Hero(
                          tag: "hero",
                          child: CircleAvatar(
                            backgroundImage: photo!='' ?
                              NetworkImage(StringData.imageURL+'/photo/'+photo)
                              :AssetImage('images/studentprofile.png')
                          )),
                    ) ,
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.0,top: 0.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(lang.tr("Welcome"),style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w400,color:Colors.white)),
                            SizedBox(height: 5.0),
                            Text(studentName,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w400,color:Colors.white60)),
                            SizedBox(height: 2.0),
                            Text("Student ID:"+stuCode,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w400,color:Colors.white70))
                          ],
                        ),
                      ),
                      onTap:(){
                        var router = new MaterialPageRoute(builder: (BuildContext context){
                          return ProfilePage(studentId: studentId,currentLang:currentLang);
                        });
                        Navigator.of(context).push(router);
                      },
                    ),
                    InkWell(
                      child: Icon(Icons.settings,size:25.0,color:Colors.white70),
                      onTap: (){
                        var router = new MaterialPageRoute(builder: (BuildContext context){
                          return ProfilePage(studentId: studentId,currentLang:currentLang);
                        });
                        Navigator.of(context).push(router);
                      },
                    )

                  ],
                ),
              )
          ),
          Expanded(
              flex: 19,
              child: Container(
                color: Color(0xff156e97),
                child: ListView(
                  children: <Widget>[
                    _createDrawerItem(imageMenu:"images/payment.png",text:lang.tr('Payments'), index:0),
                    _createDrawerItem(imageMenu:"images/schedule.png",text:lang.tr('Schedule'),index:1),
                    _createDrawerItem(imageMenu:"images/attendance.png",text:lang.tr("Attendance"),index:2),
                    _createDrawerItem(imageMenu:"images/score.png",text:lang.tr("Score"),index:3),
                    _createDrawerItem(imageMenu:"images/news.png",text:lang.tr("Discipline"),index:4),
                    _createDrawerItem(imageMenu:"images/evaluation.png",text:lang.tr("Evaluation"),index:5),
                    _createDrawerItem(imageMenu:"images/news.png",text:lang.tr("News & Event"),index:6),
                    _createDrawerItem(imageMenu:"images/about.png",text:lang.tr("About us"),index:7),
                    _createDrawerItem(imageMenu:"images/about.png",text:"Setting",index:8),
                    InkWell(
                      child:Align(
                        alignment: FractionalOffset.center,
                        child:  Text(lang.tr("Log out"),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                      ),
                      onTap:(){
                        singOutUser();
                      },
                    )
                  ],
                ),
              )
          ),
          Expanded(
              flex: 1,
              child:Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(top:BorderSide(width: 1.0,color: Colors.white,)),
                  color: Color(0xff156e97),
                ),
                child:Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Version 1.0.0 By ",style: TextStyle(fontSize: 11.0,color: Colors.white),textAlign: TextAlign.right,),
                    InkWell(
                      child:  Text("  Cam App Technology",style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.right),
                      onTap: () async {
                        if (await canLaunch("http://www.cam-app.com")) {
                          await launch("http://www.cam-app.com");
                        }
                      },
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
  singOutUser(){
    sharedPreferences.clear();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => FrontPage(currentLang:currentLang)), (Route<dynamic> route) => false);
  }
  static List<MyGrideView> getGride(){
    var gridList = new List<MyGrideView>();
    gridList.add(new MyGrideView(("Payments"), "Enrollment Management System", 'images/payment.png'));
    gridList.add(new MyGrideView(("Schedule"), "Enrollment Management System", "images/schedule.png"));
    gridList.add(new MyGrideView(("Attendance"), "Installment Management System", "images/attendance.png"));
    gridList.add(new MyGrideView(("Score"), "Enrollment Management System",  "images/score.png"));
    gridList.add(new MyGrideView(("Discipline"), "Enrollment Management System",  "images/studenthistory.png"));
    gridList.add(new MyGrideView(("Calendar"), "Enrollment Management System",  "images/calendar.png"));
    gridList.add(new MyGrideView(("Study History"), "Installment Management System", "images/elearning.png"));
    gridList.add(new MyGrideView(("News & Event"), "Enrollment Management System",  "images/news.png"));
    gridList.add(new MyGrideView(("About us"), "Installment Management System", "images/about.png"));
    return gridList;
  }
  Widget _createDrawerItem(
      {String imageMenu, String text,int index, GestureTapCallback onTap}){
    return Container(
      padding: EdgeInsets.only(bottom: 20.0,left: 15.0),
      child:GestureDetector(
        child: Row(
          children: <Widget>[
            new Image.asset(imageMenu,width:25.0),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(text,style: TextStyle(fontFamily: 'Khmer',color: Colors.white.withOpacity(0.9)),),
            )
          ],
        ),
        onTap: (){
          if(connectResult==true) {
            var router = new MaterialPageRoute(builder: (context){
              if(index==0){
                return CoursePage(title:grideList[index].name,studentId: studentId,currentLang:currentLang);
              }else if(index==1){
                return new SchedulePage(title:grideList[index].name,studentId: studentId,currentLang:currentLang);
              // ignore: missing_return
              }else if(index==2){
                return new AttendancePage(studentId: studentId,currentLang:currentLang);
              }else if(index==3){
                return new ScorePage(studentId: studentId,currentLang:currentLang);
              }else if(index==4){
                return new DisciplinePagePage(studentId: studentId,currentLang:currentLang);
              }else if(index==5){
                return new FrontPage(currentLang:currentLang);
              }else if(index==6){
                // ignore: missing_return
                return new NewsEventPage(currentLang:currentLang);
              }else if(index==7){
                return new AboutPage(currentLang:currentLang);
              }else if(index==8){
                return new SettingPage(studentId: studentId,currentLang:currentLang);

              }
            });
            Navigator.of(context).push(router);
          }else{
            return _showDialog();
          }
        },
      ),
    );
  }

  Container myGridMenu(BuildContext context,int i){
    DemoLocalization lang = DemoLocalization.of(context);
    return Container(
        alignment: FractionalOffset.center,
        margin: EdgeInsets.all(1.0),
        child:Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.only(top: 20.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(4.0),
          ),
          child:  new Column(
            children: <Widget>[
              new Image.asset('${grideList[i].image}',width: 40.0),
              new SizedBox(height: 5.0),
              new Expanded(
                  child: new Text(lang.tr(grideList[i].name),
                      style: TextStyle(color:Colors.white,//Colors.black54,
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
}