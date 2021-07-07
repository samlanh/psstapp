import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/localization/localization.dart';
import '../url_api.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_html/style.dart';

class AboutPage extends StatefulWidget{
  final String currentLang;
  AboutPage({this.currentLang});
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  PageController _pageController = new PageController();
  int page =0;
  List aboutList = new List();
  List contactList = new List();
  bool isLoading = true;
  String currentFont='Khmer';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _idController;
  TextEditingController _seekToController;

  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  List videoLearningList = new List();

  final List<String> _ids = [
    'LxakMi-jzoM',
    '8U4rZBEfmz0',
    'Pfog_f4gric',
  ];

  GoogleMapController _mapController;
  BitmapDescriptor pinLocationIcon;

  final CameraPosition _initialPosition = CameraPosition(target: LatLng(11.59394194510292, 104.88340649753809),zoom: 17);

  final List<Marker> markers = [];


  @override
  void initState(){
    _getJsonContact();


    setCustomMapPin();
    markers.add(Marker(
      position: LatLng(11.59394194510292, 104.88340649753809),
      markerId: MarkerId('1'),
      consumeTapEvents: false,
      infoWindow: InfoWindow(
        title: '',
        snippet: '',
      ),
      icon: pinLocationIcon,
    ));

    super.initState();
  }
  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }



  _getJsonContact() async{
    final String urlApi = StringData.contactUs+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          contactList = json.decode(rawData.body)['result']['contact'] as List;
          aboutList = json.decode(rawData.body)['result']['about'] as List;
          isLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Row(
          children: <Widget>[
            Icon(Icons.person_pin,size: 30.0),
            SizedBox(width: 5.0,),
            Text(lang.tr("About us"),
            style: TextStyle(fontFamily:currentFont,fontSize: 16.0)),
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
              ]
            )
          ),
        ),
      ),
      body: new PageView(
        controller: _pageController,
        children: <Widget>[

          Container(
            padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
            child: isLoading ? new Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  new CircularProgressIndicator()
                ]
            ) :  CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  floating: true,
                  pinned: true,
                  snap: true,
                  expandedHeight: 120.0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        left: 1.0,
                        top: 1.0,
                        child:Image.asset('images/schoollogo.png',width: 120)),
                    ],
                  ),
                ),
                SliverList(delegate: SliverChildListDelegate(
                    List.generate(aboutList.length, (index) {
                      return aboutUs(aboutList[index]);
                    })
                ))
              ],
            )
          ),
          Container(
//            margin: EdgeInsets.all(10.0),
//            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                new BoxShadow (
                  color: Colors.lightBlue.withOpacity(0.2),
                  offset: new Offset(0.0, 2.0),
                  blurRadius: 20.0,
                ),
              ],
            ),
            child:contactList.isNotEmpty ? isLoading ? new Stack(alignment: AlignmentDirectional.center,
                children: <Widget>[new CircularProgressIndicator()]) : ListView.builder (
                itemCount: contactList.length,
                itemBuilder: (BuildContext context, int index) {
                  return  contactAddress(contactList[index]);
                }
            ):Center(child:Text("No Result !")),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              boxShadow: <BoxShadow>[
                new BoxShadow (
                  color: Colors.lightBlue.withOpacity(0.2),
                  offset: new Offset(0.0, 2.0),
                  blurRadius: 20.0,
                ),
              ],
            ),
            //child: videoPageview(),
          )
        ],
        ),
        bottomNavigationBar: new BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(icon: new Icon(Icons.person_pin), title: new Text(lang.tr("About us"),
              style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold,fontFamily: 'Khmer'))),
            new BottomNavigationBarItem(icon: new Icon(Icons.location_on), title: new Text(lang.tr("Contact us"),
                style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold,fontFamily: 'Khmer'))),
            new BottomNavigationBarItem(icon: new Icon(Icons.play_circle_outline), title: new Text(lang.tr("Videos"),
                style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold,fontFamily: 'Khmer'))),
          ],
          onTap: navigatePage,
          currentIndex: page,
          type: BottomNavigationBarType.fixed,
        )

    );
  }

  void navigatePage(int page){
    _pageController.animateToPage(page,
        duration: new Duration(milliseconds: 500),
        curve: Curves.easeOutSine
    );
    setState(() {
      this.page = page;
    });
  }

  Widget listItem(Color color, String title) => Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black26,
            width: 1.0,
          ),
        ),
      ),
      child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black87,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,),
          ),
      ),
  );

  Widget aboutUs(dataRow){
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
              ),
            ),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text(dataRow['title'].toString(),
              style: TextStyle(fontSize: 16.0,fontFamily: 'Khmer',fontWeight: FontWeight.bold),
            ),
          ),
          rowAbout(Icon(Icons.person_pin,color: Color(0xff2a62b4)),
              dataRow['description'].toString(),2),
          SizedBox(height:10.0),
        ],
      ),
    );
  }

  Widget contactAddress(dataRow){
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200.0,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(double.parse(dataRow['latitude']),  double.parse(dataRow['longitude'])),zoom: 17),
              mapType: MapType.normal,
              onMapCreated: (controller){
                setState(() {
                  _mapController = controller;
                });
              },
              markers: markers.toSet(),
            )
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
              ),
            ),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text("- "+dataRow['title'].toString(),
              style: TextStyle(fontSize: 16.0,fontFamily: 'Khmer'),
            ),
          ),
          rowContact(Icon(Icons.pin_drop,color: Color(0xff2a62b4)),dataRow['description'].toString(),2,1),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.call,color: Color(0xff2a62b4)),dataRow['phone'].toString(),1,2),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.email,color: Color(0xff2a62b4)),dataRow['email'].toString(),1,3),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.language,color: Color(0xff2a62b4)),dataRow['website'].toString(),1,4),
          SizedBox(height:25.0),
          Text("Find us",style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.black45)),
          SizedBox(height:10.0),
          Container(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: circelContact(Color(0xff11cf31),"",Icon(Icons.call,color: Colors.white,size: 40.0),2),
                    onTap: () async{
                      if (await canLaunch("tel://"+dataRow['phone'].toString())) {//"tel://+85570418002"
                        await launch("tel://"+dataRow['phone'].toString());
                      }
                    }
                  )
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Image.asset(
                        'images/messenger.png', fit: BoxFit.fill),
                    onTap: () async{
                      if (await canLaunch(dataRow['other_social'].toString())) {
                        await launch(dataRow['other_social'].toString());
                      }
                    },
                  )
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Image.asset(
                        'images/facebook.png', fit: BoxFit.fill),
                    onTap: () async{
                      if (await canLaunch(dataRow['facebook'].toString())) {
                        await launch(dataRow['facebook'].toString());
                      }
                    },
                  )
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async{
                      if (await canLaunch(dataRow['instagram'].toString())) {
                        await launch(dataRow['instagram'].toString());
                      }
                    },
                    child: Image.asset('images/telegram.png',fit: BoxFit.cover,)
                  )
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async{
                      if (await canLaunch(dataRow['youtube'].toString())) {
                        await launch(dataRow['youtube'].toString());
                      }
                    },
                    child: Image.asset('images/youtube.png',fit: BoxFit.cover,)
                    //circelContact(Color(0xffff3d01),"",Icon(Icons.youtube_searched_for,color: Colors.white,size: 40.0),2),
                  )
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget rowAbout(Icon icon,String textLabel,int type){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: (type==1)? Text(
                textLabel,
                style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700,color: Colors.black45)
            ):Html(
                data: textLabel,
                style: {
                  "p": Style(
                      fontSize: FontSize(14.0),
                      padding: EdgeInsets.all(0.0),
                      fontFamily: 'Khmer',
                      margin: EdgeInsets.all(0.0)),
                  "h1": Style(
                      fontSize: FontSize(14.0),
                      padding: EdgeInsets.all(0.0),
                      fontFamily: 'Khmer',
                      margin: EdgeInsets.all(0.0)),
                }
            )

        )
      ],
    );
  }

  Widget rowContact(Icon icon,String textLabel,int type,int lunchType){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
                        padding: EdgeInsets.all(0.0),
                        fontFamily: 'Khmer',
                        textAlign: TextAlign.justify,
                        margin: EdgeInsets.all(0.0)),
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
 
  Widget circelContact(Color strColor,String strText,Icon icon,type){
    return Container(
      height: 70.0,
      width: 70.0,
      decoration: BoxDecoration(
        color:strColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: (type==1)?
        Text(strText,style: TextStyle(color:Colors.white,fontSize: 40.0,fontWeight: FontWeight.bold)):
        icon
      ),
    );
  }


  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title ',
        style: const TextStyle(
          color: Colors.black45,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }


}
