import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:flutter_html/flutter_html.dart';
import '../url_api.dart';

class NewsDetailsPage extends StatefulWidget {
  final newsData;

  NewsDetailsPage({this.newsData});
  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {

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
            Text(lang.tr("READ_NEWS")),
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
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.center,
                      height: 150.0,
                      child: widget.newsData['image_feature'].toString()!=''
                        ? Image.network(StringData.imageURL+'/newsevent/'+widget.newsData['image_feature'])
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
                      child: Text(widget.newsData['title'].toString(),style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: 'khmer',),),
                    ),
                    Container(
                      child: Text("Publish Date : "+widget.newsData['publish_date'].toString(),style: TextStyle(fontSize: 10.0,fontFamily: 'khmer',),),
                    ),
                    SizedBox(height: 20.0),
                    Directionality(textDirection: TextDirection.ltr,
                      child: Html(
                        data: widget.newsData['description'].toString(),
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