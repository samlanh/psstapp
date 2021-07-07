import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class NotificationPage extends StatefulWidget {
  final studentId,currentLang;
  NotificationPage({this.studentId,this.currentLang});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  List notificationList = new List();
  String currentFont='Khmer';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJsonNotification();
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
            Icon(Icons.notifications_active,color: Colors.white,size: 30.0,),
            SizedBox(width: 5.0,),
            Text(lang.tr("Notifications"),style: TextStyle(fontFamily: currentFont,
            fontSize: 18.0)),
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
              ])
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            stops: [
              0.3,6
            ],
            colors:[
              Color(0xff07548f),Color(0xff1290a2),
            ],
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
          ),
          child: Padding(
              padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: isLoading ? Center(child: new CircularProgressIndicator() ):  new ListView.builder (
                      itemCount: notificationList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  _buildNotificationItem(notificationList[index]);
                      }
                  )
              )
          ),
        )
      )
    );
  }
  _getJsonNotification() async{
    //final String urlApi = StringData.notification+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    final String urlApi = StringData.notification+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState((){
        currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
        if(json.decode(rawData.body)['code']=='SUCCESS'){
            notificationList = json.decode(rawData.body)['result'] as List;
          isLoading = false;
        }
      });
    }
  }
  Widget _buildNotificationItem(rowData) {
    return new Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(width: 1.0,color:Color(0xffe4e6e8)),
          borderRadius: new BorderRadius.circular(4.0),
          boxShadow: <BoxShadow>[
            new BoxShadow (
              color: const Color(0xcce4e6e8),
              offset: new Offset(1.0,1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(rowData['title'].toString(),overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: currentFont,
                          color: Colors.black87,
                          fontWeight:FontWeight.w600,
                        )),
                       Html(
                      data: rowData['description'].toString(),
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
                      ),
                      Text(rowData['ShowDate'].toString(),style: TextStyle(
                          color: Colors.black54,fontSize:11.0)),
                    ]
                ),
              )
            )
          ],
        )
    );
  }
}
