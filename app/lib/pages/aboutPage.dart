import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/localization/localization.dart';
import '../url_api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:developer';

//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_html_textview_render/html_text_view.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  List videoLearningList = new List();

  final List<String> _ids = [
    'LxakMi-jzoM',
    '8U4rZBEfmz0',
    'Pfog_f4gric',
  ];

  @override
  void initState(){
    _getJsonContact();
    _controller = YoutubePlayerController(
      initialVideoId: _ids.first,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  _getJsonContact() async{
    final String urlApi = StringData.contactUs+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
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
            Text(lang.tr("About us")),
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
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
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
            child:Column(
              children: <Widget>[
                Container(
                  child:Image.asset('images/schoollogo.png',width: 120)
                ),
                Expanded(
                  child: aboutList.isNotEmpty ?
                  isLoading ? new Stack(alignment: AlignmentDirectional.center,
                      children: <Widget>[new CircularProgressIndicator()]) : ListView.builder (
                      itemCount: aboutList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  aboutUs(aboutList[index]);
                      }
                  ):Center(child:Text("No Result !")
                  ),
                )
              ],
            )
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(10.0),
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
            child: videoPageview(),
          )
        ],
        ),
        bottomNavigationBar: new BottomNavigationBar(

          items: [
            new BottomNavigationBarItem(icon: new Icon(Icons.person_pin), title: new Text(lang.tr("About us"),
              style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold))),
            new BottomNavigationBarItem(icon: new Icon(Icons.location_on), title: new Text(lang.tr("Contact us"),
                style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold))),
            new BottomNavigationBarItem(icon: new Icon(Icons.play_circle_outline), title: new Text(lang.tr("Videos"),
                style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold))),
          ],
          onTap: navigatePage,
          currentIndex: page,
          type: BottomNavigationBarType.fixed,
        )

//            Container(
//                      margin: EdgeInsets.all(10.0),
//                      padding: EdgeInsets.all(10.0),
//                      height: 500.0,
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        boxShadow: <BoxShadow>[
//                          new BoxShadow (
//                            color: Colors.lightBlue.withOpacity(0.2),
//                            offset: new Offset(0.0, 2.0),
//                            blurRadius: 20.0,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.all(10.0),
//                      padding: EdgeInsets.all(10.0),
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        boxShadow: <BoxShadow>[
//                          new BoxShadow (
//                            color: Colors.lightBlue.withOpacity(0.2),
//                            offset: new Offset(0.0, 2.0),
//                            blurRadius: 20.0,
//                          ),
//                        ],
//                      ),
//                      child:contactAddress(),
//                    ),
//                    contactDiagram(),
//                  ],
//                ),
//              ),
//            ),
//          ],
//        )
//        Container(
//            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                  begin: Alignment.centerLeft,
//                  end: Alignment.centerRight,
//                  colors: <Color>[
//                    Color(0xff054798),
//                    Color(0xff009ccf),
//                  ]
//              ),
//            ),
//            child: Container(
//              height: MediaQuery.of(context).size.height,
//              decoration: BoxDecoration(
//                color: Color(0xffcfe5fa),
//                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0)),
//              ),
//              child: ListView(
//                children: <Widget>[
//                  SizedBox(height: 20.0,),
////                  aboutVission(),
////                  Container(
////                    color: Colors.white,
////                    child:contactAddress(),
////                  ),
////                  contactDiagram(),
//                ],
//              ),
//            )
//        )
    );
  }
//  void mapCreated(controller) {
//    setState(() {
//      _controller = controller;
//    });
//  }
//
//  movetoBoston() {
//    _controller.animateCamera(CameraUpdate.newCameraPosition(
//      CameraPosition(target: LatLng(42.3601, -71.0589), zoom: 14.0, bearing: 45.0, tilt: 45.0),
//    ));
//  }
//
//  movetoNewYork() {
//    _controller.animateCamera(CameraUpdate.newCameraPosition(
//      CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
//    ));
//  }
  void navigatePage(int page){
    _pageController.animateToPage(page,
        duration: new Duration(milliseconds: 500),
        curve: Curves.easeOutSine
    );
    setState(() {
      this.page = page;
    });
  }
  Widget aboutVission(Icon icon, String title){
    return Container(
      child: Container(
//        flex:  1,
        child: Container(
//          decoration: BoxDecoration(
//              border: Border.all(color: Color(0xff89b6dd),width: 2.0),
//              borderRadius: BorderRadius.circular(5.0),
//              color:Colors.white
//          ),
//          margin: EdgeInsets.all(5.0),
//          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              rowContact(icon,title,1),
              Directionality( textDirection: TextDirection.ltr,
                  child:  Text("Formally known as American Academy of Language and Art (AALA), ELT was founded by US "
                      "entrepreneurs who strongly believed that education was a foundation in rebuilding "
                      "has granted the rights for EESS to issue diplomas after meeting the credit requirements.",
                      style:TextStyle(),textAlign: TextAlign.justify
                  )
              ),
            ],
          )

        )

      ),
    );
  }

  Widget aboutUs(dataRow){
    return Container(
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
            child: Text("- "+dataRow['title'].toString(),
              style: TextStyle(fontSize: 16.0,fontFamily: 'Khmer'),
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
      padding: EdgeInsets.only(left: 5.0),
      margin: EdgeInsets.only(left: 5.0),
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
            child: Text("- "+dataRow['title'].toString(),
              style: TextStyle(fontSize: 16.0,fontFamily: 'Khmer'),
            ),
          ),
          rowContact(Icon(Icons.pin_drop,color: Color(0xff2a62b4)),dataRow['description'].toString(),2),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.call,color: Color(0xff2a62b4)),dataRow['phone'].toString(),1),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.email,color: Color(0xff2a62b4)),dataRow['email'].toString(),1),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.language,color: Color(0xff2a62b4)),dataRow['website'].toString(),1),
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
                      child: circelContact(Color(0xff3c5a99),"f",Icon(Icons.contact_mail),1),
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
                          if (await canLaunch(dataRow['youtube'].toString())) {
                            await launch(dataRow['youtube'].toString());
                          }
                        },
                        child: Image.asset('images/youtube.png',fit: BoxFit.cover,)
                      //circelContact(Color(0xffff3d01),"",Icon(Icons.youtube_searched_for,color: Colors.white,size: 40.0),2),
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
                      child: circelContact(Color(0xff11cf31),"",Icon(Icons.call,color: Colors.white,size: 40.0),2),
                      onTap: () async{
                        if (await canLaunch("tel://"+dataRow['phone'].toString())) {//"tel://+85570418002"
                          await launch("tel://"+dataRow['phone'].toString());
                        }
                      }
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
        SizedBox(width: 10.0),
        Expanded(
            child: (type==1)? Text(
                textLabel,
                style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700,color: Colors.black45)
            ):Html(
              data: textLabel,
            )
        )
      ],
    );
  }
  Widget rowContact(Icon icon,String textLabel,int type){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        SizedBox(width: 10.0),
        Expanded(
            child: (type==1)? Text(
            textLabel,
            style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700,color: Colors.black45)
          ):Html(
            data: textLabel,
          )
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
  Widget _buildPaymentItem(String imgPath, String foodName, String price) {
    return new Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            new BoxShadow (
              color: Color(0xff009ccf),
              offset: new Offset(0.0, 2.0),
              blurRadius: 2.0,
            ),
          ],
        ),
        padding: EdgeInsets.only( right: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Color(0xff054798),
                        Color(0xff009ccf),
                      ])
              ),
              height: 89.0,
              child:
              _rowTitleSchedule(Icon(Icons.library_books,color: Colors.white,size: 40.0,),'Very Good'),
            ) ,
            SizedBox(width: 5.0,height: 5.0),
            Expanded(
              child: Container(
//                decoration: BoxDecoration(
//                    border: Border(bottom:BorderSide(width: 2.0,color: Color(0xff009ccf)
//                    ) )),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text('ភាពឧស្សាហ៍ក្នុងការសិក្សា',style: TextStyle(fontFamily: 'Khmer',color: Color(0xff010101))),
                      Text('Dilligence'),
                    ]
                ),
              )
            )
          ],
        )

    );
  }
  Widget _rowTitleSchedule(Icon iconType,String subjectName) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
          children: [
            iconType,
            Text(subjectName, style:
            TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.white
            )
            ),
          ]
      ),
    );
  }
  Widget _rowScheduleList(Icon iconType,String textData, String priceData){
    return new Container(
      child: Row(
          children: [
            iconType,
            Expanded(
              child: Text(textData,style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7)
              )
              ),
            ),
            Expanded(
              child:  Align(
                alignment: Alignment.topRight,
                child: Text(priceData,style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.7),
                    fontStyle: FontStyle.italic
                )
                ),
              ),
            )
          ]
      ),
    );
  }
  Widget videoPageview(){
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          _controller
              .load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
          _showSnackBar('Next Video Started!');
        },
      ),
      builder: (context, player) => Scaffold(
        key: _scaffoldKey,
        body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      player,
                      Container(
                        color: Colors.black.withOpacity(0.9),
                        padding: const EdgeInsets.all(1.0),
                        margin: EdgeInsets.all(0.0),
                        child: Column(
                          children: [
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: [
//                            IconButton(
//                              icon: const Icon(Icons.skip_previous,color: Colors.white),
//                              onPressed: _isPlayerReady
//                                  ? () => _controller.load(_ids[
//                              (_ids.indexOf(_controller.metadata.videoId) -
//                                  1) %
//                                  _ids.length])
//                                  : null,
//                            ),
//                            IconButton(
//                              icon: Icon(
//                                  _controller.value.isPlaying
//                                      ? Icons.pause
//                                      : Icons.play_arrow,color: Colors.white
//                              ),
//                              onPressed: _isPlayerReady
//                                  ? () {
//                                _controller.value.isPlaying
//                                    ? _controller.pause()
//                                    : _controller.play();
//                                setState(() {});
//                              }: null,
//                            ),
//                            IconButton(
//                              icon: const Icon(Icons.skip_next,color: Colors.white),
//                              onPressed: _isPlayerReady
//                                  ? () => _controller.load(_ids[
//                              (_ids.indexOf(_controller.metadata.videoId) +
//                                  1) %
//                                  _ids.length])
//                                  : null,
//                            ),
//                          ],
//                        ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(_muted ? Icons.volume_off : Icons.volume_up,color: Colors.white),
                                  onPressed: _isPlayerReady
                                      ? () {
                                    _muted
                                        ? _controller.unMute()
                                        : _controller.mute();
                                    setState(() {
                                      _muted = !_muted;
                                    });
                                  } : null,
                                ),
                                Expanded(
                                  child: Slider(
                                    inactiveColor: Colors.transparent,
                                    value: _volume,
                                    min: 0.0,
                                    max: 100.0,
                                    divisions: 10,
                                    label: '${(_volume).round()}',
                                    onChanged: _isPlayerReady
                                        ? (value) {
                                      setState(() {
                                        _volume = value;
                                      });
                                      _controller.setVolume(_volume.round());
                                    }
                                        : null,
                                  ),
                                ),
                                FullScreenButton(
                                  controller: _controller,
                                  color:  Colors.white,
                                ),
                              ],
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: _getStateColor(_playerState),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        margin: EdgeInsets.only(bottom: 2.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(width: 2.0, color:Colors.black12),
                          ),
                        ),
//                    child: _text('Title', _videoMetaData.title),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: _text("", _videoMetaData.title),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      child: Container(
                        child: Container(
                            height: 200.0,
//                            child: ListView.builder (
//                                itemCount: videoLearningList.length,
//                                itemBuilder: (BuildContext context, int index) {
//                                  return  _buildCategoryItems(videoLearningList[index]);
//                                }
//                            )
                        ) ,
                      )
                  ),
                )

//            _loadCueButton('PLAY','uCU5O4aDqME&t'),//Played
              ],
            )
        ),
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

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700];
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900];
      default:
        return Colors.blue;
    }
  }
  Widget get _space => const SizedBox(height: 10);
  Widget _loadCueButton(String action,String url) {
    return Expanded(
      child: MaterialButton(
        color: Colors.blueAccent,
        onPressed: _isPlayerReady
            ? () {
          url = "https://www.youtube.com/watch?v="+url;
          var id = YoutubePlayer.convertUrlToId(url);
          if (action == 'PLAY') _controller.load(id);
          FocusScope.of(context).requestFocus(FocusNode());
        }
        : null,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

}
