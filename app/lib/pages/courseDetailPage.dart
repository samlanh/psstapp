import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../url_api.dart';
import 'package:flutter_html/style.dart';

class CourseDetailsPage extends StatefulWidget {
  final rowData;
  final String title;
  CourseDetailsPage({this.title, this.rowData});
  @override
  _CourseDetailsPageState createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title:Text(widget.title,style: TextStyle(fontFamily:'Khmer')),
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
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
                Html(
                  data: widget.rowData['description'].toString(),
                    style: {
                      "h1": Style(
                        fontSize:FontSize(12.0),
                        fontFamily: 'Khmer',
                        margin: EdgeInsets.all(5.0)
                      ),
                      "h2": Style(
                        fontSize:FontSize(12.0),
                        fontFamily: 'Khmer',
                        fontWeight:FontWeight.normal,
                        margin: EdgeInsets.all(0.1)
                      ),
                      "th": Style(
                        padding: EdgeInsets.all(1),
                        fontFamily: 'Khmer',
                        fontSize:FontSize(12.0),
                      ),
                      "tr": Style(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.withOpacity(0.8)),
                        ),
                      ),
                      "td": Style(
                          padding: EdgeInsets.only(top:10,bottom: 10,left: 1,right: 1),
                          fontSize:FontSize(10.0),
                          fontFamily: 'Khmer',
                          verticalAlign: VerticalAlign.BASELINE,
                      ),
                    }
                )
              ]
            )
          )
        )
        )
    );
  }
}