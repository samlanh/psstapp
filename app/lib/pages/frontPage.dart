import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import '../url_api.dart';
import 'package:app/main.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:app/functions/GrideFunction.dart';
//import 'package:app/pages/appVideoPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_html/style.dart';

class FrontPage extends StatefulWidget {

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  String currentLang='1' ;
  String currentFont='Khmer';
  List rsProfileList = new List();
  List gridList = getGrid();
  bool isLoading = true;
  bool isLoadingAddress = true;
  List sliderList = new List();
  var contactList = {};
  var aboutList = {};
  SharedPreferences sharedPreferences;
  List<NetworkImage> imagesList = List<NetworkImage>();
  GoogleMapController _mapController;
  BitmapDescriptor pinLocationIcon;
  static double lat=11.59394194510292;
  static double lang=104.88340649753809;
  final CameraPosition _initialPosition = CameraPosition(target: LatLng(lat, lang),zoom: 17);
  final List<Marker> markers = [];

  @override
  void initState() {
    checkLoginStatus();
    registerPlayerId();
    configOneSignal();
    _getSlider();
    _getJsonContact();

    markers.add(Marker(
      position: LatLng(lat, lang),
      markerId: MarkerId('1'),
      consumeTapEvents: false,
      infoWindow: InfoWindow(
        title: '',
        snippet: '',
      ),
    ));
    super.initState();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      currentLang = sharedPreferences.getString('currentLang');
      currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
    });
    if(sharedPreferences.getString('token') != null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeApp()), (Route<dynamic> route) => false);
    }else{
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {

    DemoLocalization lang = DemoLocalization.of(context);
    Locale _temp;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/icon.png',height: 40.0,fit: BoxFit.fill),
            SizedBox(width: 10.0),
            Flexible(
              child: Text(lang.tr("SCHOOL_NAME"),style:TextStyle(fontSize: 16.0,fontFamily: currentFont,color: Colors.white)),
            ),
            SizedBox(width: 10.0),
          ],
        ),
          actions: <Widget>[
            GestureDetector(
              child:(Localizations.localeOf(context).languageCode == "km")?
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
                  _getJsonContact();
                });
              },
            ),
            new IconButton(icon: new Icon(Icons.notifications,color: Colors.redAccent.shade50,), onPressed: (){
              Navigator.pushNamed(context, 'NOTIFICATION',arguments:{'studentId': 0,'currentLang':currentLang});
            }),
          ],
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
            child:  Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 230.0,
                      width: MediaQuery.of(context).size.width,
                      child:  isLoading ? new Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          new CircularProgressIndicator()
                        ]
                      ) : sliderBlog(),
                    ),
                    Container(
                      height: 90.0,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10.0),
                      child: Text(isLoadingAddress == false ? aboutList['lbl_introduction'].toString():'',style: TextStyle(color: Color(0xff054798),fontSize:14.0,fontFamily: currentFont)),
                    ),
                    Container(
                      height: 400.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: isLoadingAddress == false ?
                          NetworkImage(StringData.imageURL+'/newsevent/introduction_image/'+aboutList['imageshow'].toString())
                          : AssetImage("images/appshow.png") ,
                          fit: BoxFit.cover,
                      )
                      ),
                     child: Row(
                       crossAxisAlignment:CrossAxisAlignment.center ,
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         FlatButton.icon(
                           onPressed:(){
                            // Navigator.push(context,MaterialPageRoute(builder: (context) => AppVideoPage(currentLang:currentLang,urlVideo:aboutList['lbl_howtouse'].toString())));
                           },
                           color: Colors.redAccent,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0),
                             side: BorderSide(color: Colors.redAccent)
                           ),
                           icon: Icon(Icons.play_circle_filled,color: Colors.white),
                           label: Text(lang.tr("WATCH_HOW_TO_USE"),style:TextStyle(
                             color:Colors.white,fontSize: 14.0,
                             fontFamily: currentFont
                           ))
                         ),
                       ],
                     ),
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
                          (isLoadingAddress==false)?
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
                    itemCount: gridList.length,
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

  void registerPlayerId() async{
    //ahs: 2724c04c-dfba-428d-90b9-7739847d62b6
    //psis: dfc704ab-e023-4b0b-b030-e300f13b74eb
    OneSignal.shared.init(StringData.OnesigneAppId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });

    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;

    Map data = {
      'token': playerId,
      'device_type': '1',
    };
    var response = await http.post(StringData.addToken,body: data);
    if(response.statusCode == 200){
    }
  }

  void configOneSignal() async{
    OneSignal.shared.init(StringData.OnesigneAppId, iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: true
    });

    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult handler) async {//on open
      var urlType = handler.notification.payload.additionalData['urlType'];
      if(urlType==1){
        //Navigator.pushNamed(context, 'PAYMENT',arguments:{'title':"Payments",'studentId':studentId,'currentLang':currentLang});
      }else if(urlType==2){
        //Navigator.pushNamed(context, 'SCORE',arguments:{'studentId': studentId,'currentLang':currentLang});
      }else if(urlType==3){
        //Navigator.pushNamed(context, 'ATTENDANCE',arguments:{'studentId': studentId,'currentLang':currentLang});
      }else if(urlType==4){
        //Navigator.pushNamed(context, 'DISCIPLINE',arguments:{'studentId': studentId,'currentLang':currentLang});
      }else if(urlType==5){
        //Navigator.pushNamed(context, 'NEWS',arguments:{'currentLang':currentLang});
      }else if(urlType==6){
        //Navigator.pushNamed(context, 'NOTIFICATION',arguments:{'studentId': 0,'currentLang':currentLang});
      }
    });

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) async {//on received
      //print("Notification received1"+notification.payload.body);
      setState(() {
      });
    });
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  _getSlider() async{
    final String urlApi = StringData.slideShow;
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
    if(currentLang.isEmpty){
      currentLang='1';
    }
    final String urlApi = StringData.singleContact+'&currentLang='+currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          aboutList['lbl_introduction']= json.decode(rawData.body)['result']['introduction']['lbl_introduction']['title'].toString();
          aboutList['lbl_introduct_use']= json.decode(rawData.body)['result']['introduction']['lbl_introduction_i']['title'].toString();
          aboutList['lbl_videointro']= json.decode(rawData.body)['result']['introduction']['lbl_videointro']['title'].toString();
          aboutList['lbl_howtouse']= json.decode(rawData.body)['result']['introduction']['lbl_howtouse']['title'].toString();
          aboutList['imageshow'] = json.decode(rawData.body)['result']['introduction']['introduction_image']['title'].toString();

          contactList['title']= json.decode(rawData.body)['result']['contact']['title'].toString();
          contactList['description']= json.decode(rawData.body)['result']['contact']['description'].toString();
          contactList['phone']= json.decode(rawData.body)['result']['contact']['phone'].toString();
          contactList['email']= json.decode(rawData.body)['result']['contact']['email'].toString();
          contactList['website']= json.decode(rawData.body)['result']['contact']['website'].toString();
          contactList['other_social']= json.decode(rawData.body)['result']['contact']['other_social'].toString();
          contactList['facebook']= json.decode(rawData.body)['result']['contact']['facebook'].toString();
          contactList['youtube']= json.decode(rawData.body)['result']['contact']['youtube'].toString();
          contactList['instagram']= json.decode(rawData.body)['result']['contact']['instagram'].toString();
          lat = double.parse(json.decode(rawData.body)['result']['contact']['latitude']);
          lang = double.parse(json.decode(rawData.body)['result']['contact']['longitude']);
          isLoadingAddress = false;
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

  static List<MyGrideView> getGrid(){
    var gridList = new List<MyGrideView>();
    gridList.add(new MyGrideView(("About us"), "Installment Management System", "images/about.png"));
    gridList.add(new MyGrideView(("COURSE"), "Enrollment Management System",  "images/studenthistory.png"));
    gridList.add(new MyGrideView(("News"), "Enrollment Management System",  "images/news.png"));
    gridList.add(new MyGrideView(("Calendar"), "Enrollment Management System",  "images/schedule.png"));
    return gridList;
  }

  void routerAntherPage(index){

    if(index==0){
      Navigator.pushNamed(context, 'ABOUT',arguments:{'currentLang':currentLang});
    }else if(index==1){
      Navigator.pushNamed(context, 'COURSE',arguments:{'title':'COURSE','currentLang':currentLang});
    }else if(index==2){
      Navigator.pushNamed(context, 'NEWS',arguments:{'currentLang':currentLang});
    }
    else if(index==3){
      Navigator.pushNamed(context, 'CALENDAR',arguments:{'currentLang':currentLang});
    }
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
            new Image.asset('${gridList[i].image}',width: 40.0,color: Color(0xff3568aa)),
            new SizedBox(height: 5.0),
            new Expanded(
              child: Text(lang.tr(gridList[i].name),
                style: TextStyle(color:Color(0xff3568aa),//Colors.black54,
                  fontSize: 14.0,
                  fontFamily: currentFont,
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
          Text('Copyright© 2020 AHS.',style:TextStyle(fontSize: 10.0,)),
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
            child: Text(isLoadingAddress == false ? aboutList['lbl_introduct_use'].toString():'',style: TextStyle(color: Color(0xff054798),fontSize:14.0,fontFamily: currentFont)),
          ),
          Text(lang.tr('CLICK_TO_LOGIN'),style: TextStyle(color: Color(0xff054798),fontWeight: FontWeight.w600,fontSize:14.0,fontFamily: currentFont)),
          Container(
            child: Container(
              padding: EdgeInsets.all(5.0),
              width: MediaQuery.of(context).size.width,
              child:  FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, 'LOGIN');
                },
                label: Text(lang.tr('LOGIN'),style: TextStyle(fontFamily: currentFont,fontSize:14.0,fontWeight: FontWeight.bold)),
                icon: Icon(Icons.person_pin),
                backgroundColor: Colors.redAccent
              )
            ),
          )
        ]
      )
    );
  }

  Widget contactAddress(dataRow){
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
            child: Text("-" + contactList['title'].toString(),
              style: TextStyle(fontSize: 14.0, fontFamily: currentFont),
            ),
          ),
          Container(
            height: 200.0,
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              onMapCreated: (controller){
                setState(() {
                  _mapController = controller;
                });
              },
              markers: markers.toSet(),
              )
          ),
          rowContact(Icon(Icons.pin_drop, color: Color(0xff2a62b4)),
              dataRow['description'].toString(), 2,1),
          SizedBox(height: 10.0),
          rowContact(Icon(Icons.call, color: Color(0xff2a62b4)),
              dataRow['phone'].toString(), 1,2),
          SizedBox(height: 10.0),
          rowContact(Icon(Icons.email, color: Color(0xff2a62b4)),
              dataRow['email'].toString(), 1,3),
          SizedBox(height: 10.0),
          rowContact(Icon(Icons.language, color: Color(0xff2a62b4)),
              dataRow['website'].toString(), 1,4),
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
                    child:  Image.asset('images/call.png',fit: BoxFit.fill,
                        width: 50.0),
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
                        'images/messenger.png', fit: BoxFit.fill,width: 50.0),
                    onTap: ()async{
                      if (await canLaunch(dataRow['other_social'].toString())) {
                        await launch(dataRow['other_social'].toString());
                      }
                    },//
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
                      if(await canLaunch(dataRow['instagram'].toString())) {
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

  Widget rowContact(Icon icon, String textLabel, int type, int lunchType) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        icon,
        SizedBox(width: 10.0),
        Expanded(
          child: InkWell(
            child: (type == 1) ? Text(
              textLabel,
              style: TextStyle(fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: Colors.black45)
            ) : Html(
              data: textLabel,
                style: {
                  "p": Style(
                    fontSize: FontSize(14.0),
                    fontFamily: currentFont,
                  ),
                }
            ),
              onTap: () async{
                if(lunchType==2){
                  await launch("tel://"+textLabel);
                }else if(lunchType==3){
                  await launch("mailto:"+textLabel);
                }
                else if(lunchType==4){
                  await launch(textLabel);
                }
              }
          ),
        )
      ],
    );
  }
}