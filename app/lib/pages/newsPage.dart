import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
import 'newsDetailPage.dart';

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
                                  child: new Text("When you arrive at PSIS First, you will start your first day with a school orientation.",
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
                        return  _buildNewsItem(newsList[index]);
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
  Widget _buildNewsItem(rowData) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NewsDetailsPage(newsData:rowData)
        ));
      },
      child: Container(
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
                  child:(
                      (rowData['image_feature'].toString()!='')
                          ? Image.network(StringData.imageURL+'/newsevent/'+rowData['image_feature'])
                          : Image.asset('images/news.png')
                  )) ,
              SizedBox(width: 5.0,height: 5.0),
              Expanded(
                  child: Container(
                    height: 100.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Flexible(
                            child: Text(rowData['title'].toString(), style: TextStyle(fontFamily: 'Khmer',fontSize: 12.0),
                                overflow: TextOverflow.fade),
                          ),
//                      Text(rowData['title'].toString(),overflow: TextOverflow.ellipsis.,style: TextStyle(fontFamily: 'Khmer',fontSize: 12.0,
                          Directionality( textDirection: TextDirection.ltr,
                            child: Text("",textAlign: TextAlign.justify),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: <Widget>[
                              Text("Publish Date : "+rowData['publish_date'].toString(),style: TextStyle(color: Colors.black45,fontSize:10.0))
                            ],
                          )
                        ]
                    ),
                  )
              ),
            ],
          )
      ),
    );
  }
}