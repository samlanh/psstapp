import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';
import 'package:flutter_html/flutter_html.dart';
import '../url_api.dart';

class CourseDetailsPage extends StatefulWidget {
  final rowData;

  CourseDetailsPage({this.rowData});
  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {

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
                padding: EdgeInsets.all(0.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      alignment: AlignmentDirectional.center,
                      child: widget.rowData['image_feature'].toString()!=''
                        ? Image.network(StringData.imageURL+'/newsevent/'+widget.rowData['image_feature'],fit: BoxFit.fill)
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
                      padding: EdgeInsets.all(5.0),
                      child: Text(widget.rowData['title'].toString(),style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,fontFamily: 'khmer',),),
                    ),

                    SizedBox(height: 20.0),
                    Directionality(textDirection: TextDirection.ltr,
                      child: Html(
                        data: widget.rowData['description'].toString(),
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