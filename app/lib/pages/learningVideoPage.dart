import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:developer';

//import 'package:flutter/cupertino.dart';
//import 'package:flutter/rendering.dart';

//import 'package:flutter/services.dart';
//import 'package:app/functions/VideoList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
import 'package:app/localization/localization.dart';



class LearningVideoPage extends StatefulWidget {
  final String categoryId;
  final String currentLang;

  LearningVideoPage({this.currentLang,this.categoryId});

  @override
  _LearningVideoPageState createState() => _LearningVideoPageState();
}

class LearningVideo extends StatefulWidget {
  @override
  _LearningVideoPageState createState() => _LearningVideoPageState();
}

class _LearningVideoPageState extends State<LearningVideoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  bool isLoading = true;
  List videoLearningList = new List();

  final List<String> _ids = [
    'LxakMi-jzoM',
    '8U4rZBEfmz0',
    'Pfog_f4gric',

  ];

  @override
  void initState() {
    _getJsonVideoList();
    super.initState();
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
    // Pauses video while navigating to next page.
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

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
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
            onPressed: () {
              log('Settings Tapped!');
            },
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
        appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Image.asset('images/elearning.png',height: 50.0),
            SizedBox(width: 10.0),
            Text(lang.tr('WATCHING_VIDEO'),
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                    color: Colors.white)
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Colors.red,
                    Colors.redAccent.withOpacity(0.9),
                  ])
          ),
        ),
      ),

        body: Container(
          padding: EdgeInsets.all(1.0),
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
                      child: ListView.builder (
                          itemCount: videoLearningList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  _buildCategoryItems(videoLearningList[index]);
                          }
                      )
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
  _getJsonVideoList() async{
    final String urlApi = StringData.eLearningVideo+"&cateId="+widget.categoryId+"&currentLang="+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      if(json.decode(rawData.body)['code']=='SUCCESS'){
        setState((){
            videoLearningList = json.decode(rawData.body)['result'] as List;
//            for(var i = 0; i < videoLearningList.length; i++){
//              _ids.add(videoLearningList[i]['video_link'].toString());
//            }
          debugPrint(videoLearningList.toString()+"cccccc");
            isLoading = false;
        });
      }

    }
  }
  Widget _buildCategoryItems(rowData) {
    return new Container(
        margin: EdgeInsets.only(bottom: 2.0),
        decoration: new BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Color(0xffdddddd)),
            bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
            left: BorderSide(width: 1.0, color: Color(0xffdddddd)),
          ),
        ),
        padding: EdgeInsets.only(right: 5.0),
        child: InkWell(
            onTap:(){
              String action = 'PLAY';
              String url = "https://www.youtube.com/watch?v="+rowData['video_link'].toString();
              var id = YoutubePlayer.convertUrlToId(url);
              if (action == 'PLAY') _controller.load(id);
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(Icons.play_circle_filled,color:Colors.redAccent,size: 50.0),
                          ),
                          _rowTitleCategory(rowData['title'],rowData['publish_date']),
                        ]
                    )
                ),
                Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Icon(Icons.arrow_forward_ios,color: Colors.redAccent),
                  ),
                )
              ],
            )
        )
    );
  }
  Widget _rowTitleCategory(String stringData,String stringData1){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
           Text(stringData,
            style: TextStyle(fontFamily: 'Khmer',fontSize: 12.0),
            overflow: TextOverflow.visible),
          Text(
            stringData1, style:TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12.0
            )
          ),
        ]
    );
  }
}