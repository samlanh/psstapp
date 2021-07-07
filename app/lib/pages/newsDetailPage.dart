import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../url_api.dart';

class NewsDetailsPage extends StatefulWidget {
  final newsData;

  NewsDetailsPage({this.newsData});
  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  String currentFont='Khmer';


//  _initLang(){
//    setState(() {
//      currentFont =  (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
//    });
//  }
  @override
  Widget build(BuildContext context) {

    DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Image.asset('images/news.png',height: 50.0),
            SizedBox(width: 5.0,),
            Text(lang.tr("READ_NEWS"),style:TextStyle(
              fontFamily: currentFont,
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
      body:  ListView(
        children: <Widget>[
          Container(
             width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.redAccent,
                    child: widget.newsData['image_feature'].toString()!=''
                      ? Image.network(StringData.imageURL+'/newsevent/'+widget.newsData['image_feature'],
                        fit: BoxFit.fill,
                        scale: 1)
                      : Container(
                      width: MediaQuery.of(context).size.width,
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
                      child: Image.asset('images/news.png'),
                    )
                  ),
                  Container(
                    child: Text(widget.newsData['title'].toString(),style: TextStyle(fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: currentFont))
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today,size: 12.0,color: Colors.black26),
                      SizedBox(width: 10.0),
                      Text(widget.newsData['publish_date'].toString(),style: TextStyle(fontSize: 10.0,
                        fontFamily: currentFont)),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Directionality(textDirection: TextDirection.ltr,
                    child: Html(
                      data: widget.newsData['description'].toString(),
                        style: {
                          "p": Style(
                            fontSize: FontSize(14.0),
                            padding: EdgeInsets.all(0.0),
                            fontFamily: currentFont,
                            margin: EdgeInsets.all(0.0)),
                          "h1": Style(
                            fontSize: FontSize(14.0),
                            padding: EdgeInsets.all(0.0),
                            fontFamily: 'Khmer',
                            margin: EdgeInsets.all(0.0)),
                        }
                    )
                  )
                ]
              )
            )
          )
        ]
        )
    );
  }
}