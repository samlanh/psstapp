import 'package:flutter/material.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:app/localization/localization.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';

class NewsEventPage extends StatefulWidget {
  final String currentLang ;
  NewsEventPage({this.currentLang});

  @override
  _NewsEventPageState createState() => _NewsEventPageState();
}

class _NewsEventPageState extends State<NewsEventPage> {

  bool isLoading = true;
  List newsList = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJsonNews();
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
              Image.asset('images/news.png',height: 50.0),
              SizedBox(width: 5.0,),
              Text("News and Events"),
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
          padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(top: 30.0,left:0.0,right: 10.0,bottom: 10.0),
                      margin: EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                Color(0xff054798),
                                Color(0xff009ccf),
                              ])
                      ),
                      child: Carousel(
                        images:[
//                            ListView.builder (
//                              itemCount: newsList.length,
//                              itemBuilder: (BuildContext context, int index) {
//                                  return Container(
//                                      child:Row(
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        mainAxisAlignment: MainAxisAlignment.start,
//                                        children: <Widget>[
//                                          Expanded(
//                                              flex:1,
//                                              child: Padding(padding:EdgeInsets.all(10.0),
//                                                  child: new Image.asset('images/score.png',fit: BoxFit.contain))
//                                          ),
//                                          Expanded(
//                                            flex:2,
//                                            child: new Text(index.toString()+newsList[index]['title'],
//                                                style: TextStyle(color: Colors.white.withOpacity(0.9)),textAlign: TextAlign.start),
//                                          )
//                                        ],
//                                      )
//                                  );
//                                }
//                            ),
                          new Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                    flex:1,
                                    child: Padding(padding:EdgeInsets.all(10.0),
                                        child: new Image.asset('images/schoollogo.png',fit: BoxFit.contain))
                                ),
                                Expanded(
                                  flex:2,
                                  child: new Text("When you arrive at ELT, you will start your first day with a school orientation.",
                                      style: TextStyle(color: Colors.white.withOpacity(0.9)),textAlign: TextAlign.start),
                                )
                              ],
                            ),
                          ),
                        ],
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.lightGreenAccent,
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.transparent,
                        borderRadius: false,
                      ),
                    )
                ),
                Expanded(
                  flex: 8,
                  child:isLoading ? new Center(
                      child: new CircularProgressIndicator()) :   ListView.builder (
                      itemCount: newsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return  _buildPaymentItem(newsList[index]);
                      }
                  ),
                )
              ],
            )
        )
    );
  }
  _getJsonNews() async{
    final String urlApi = StringData.news+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          newsList = json.decode(rawData.body)['result'] as List;
          isLoading = false;
        }else{
          //if not data
        }
      });
    }
  }
  Widget _buildPaymentItem(rowData) {
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
//        decoration: new BoxDecoration(
//          color: Colors.white,
//          boxShadow: <BoxShadow>[
//            new BoxShadow (
//              color: Color(0xff009ccf),
//              offset: new Offset(0.0, 2.0),
//              blurRadius: 2.0,
//            ),
//          ],
//        ),
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
              child:Image.asset('images/news.png') //_rowTitleSchedule(Icon(Icons.library_books,color: Colors.white,size: 40.0,),rowData['publishDate'].toString()),
            ) ,
            SizedBox(width: 5.0,height: 5.0),
            Expanded(
              child: Container(
                height: 100.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(rowData['title'].toString(),style: TextStyle(fontFamily: 'Khmer'),),
//                      Flexible(
//                        child: RichText(
//                          overflow: TextOverflow.ellipsis,
//                          strutStyle: StrutStyle(fontSize: 12.0),
//                          text: TextSpan(
//                              style: TextStyle(color: Colors.black),
//                              text: rowData['description'].toString()),
//                        ),
//                      ),

                      Directionality( textDirection: TextDirection.ltr,
                        child: Text(rowData['description'].toString(),textAlign: TextAlign.justify),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: <Widget>[
                          Text(rowData['publishDate'].toString(),style: TextStyle(color: Colors.black45,fontSize:10.0))
                        ],
                      )
                    ]
                ),
              )
            ),
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

}
