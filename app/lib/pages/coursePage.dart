import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/localization/localization.dart';
import 'package:app/pages/courseDetailPage.dart';
import '../url_api.dart';

class CoursePage extends StatefulWidget {
  final String currentLang,title;

  CoursePage({this.title,this.currentLang});
  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {

  List courseList = new List();
  bool isLoading = true;
//  List rowPayment = new List();

  @override
  void initState() {
    _getJsonCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    String strLang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Image.asset('images/payment.png',height: 50.0),
            SizedBox(width: 10.0),
            Text(lang.tr(widget.title.toString()),
              style: TextStyle(
                fontFamily: (strLang=='km')?'Khmer':'Montserrat',
                fontSize: 18.0,
                color: Colors.white)
            )
          ]
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xff054798),
                Color(0xff009ccf)
              ])
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Color(0xff054798),
              Color(0xff009ccf)
            ]
           ),
        ),
        child: Container(
            alignment: AlignmentDirectional.center,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xfff2f6fc),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0))
            ),
            child:isLoading ? new Stack(alignment: AlignmentDirectional.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                ]) :
            Padding(
              padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: courseList.isNotEmpty
                  ? ListView.builder (
                  itemCount:courseList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCourseItem(index,courseList[index]);
                  }
                ): Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      notFoundPage()
                    ],
                  ),
                )
              )
            ),
          )
      )
    );
  }
  _getJsonCourse() async{
    final String urlApi = StringData.course+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
            courseList = json.decode(rawData.body)['result'] as List;
            isLoading = false;
        }
      });
    }
  }

  Widget _buildCourseItem(int index , rowCourse) {
    DemoLocalization lang = DemoLocalization.of(context);
    String strLang = Localizations.localeOf(context).languageCode;

     return new Container(
       margin: EdgeInsets.only(bottom: 10.0),
         decoration: new BoxDecoration(
           color: Colors.white,
           border: new Border.all(width: 1.0,color:Color(0xffe4e6e8)),
           borderRadius: new BorderRadius.circular(4.0),
           boxShadow: <BoxShadow>[
             new BoxShadow (
               color: const Color(0xcce4e6e8),
               offset: new Offset(1.0,2.0),
               blurRadius: 1.0
             )
           ]
         ),
        padding: EdgeInsets.all(5.0),
        child: InkWell(
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CourseDetailsPage(rowData:rowCourse)
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
//                padding: EdgeInsets.all(2.0),
                child: Image.asset('images/hat.png',width: 100.0)
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(lang.tr('COURSE'),style: TextStyle(fontSize: 16.0)),
                          Expanded(
                            child: Align(
                                alignment: FractionalOffset.topRight,
                                child:  Icon(Icons.more_horiz,size: 22.0,color:Colors.black45)
                            ),
                          ),

                        ],
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(rowCourse['title'].toString(),style: TextStyle(
                          fontFamily: (strLang=='km')?'Khmer':'Montserrat',
                          fontSize: 16.0,fontWeight: FontWeight.w600,color:Color(0xff3568aa) ))
                      )
                    ]
                  )
                )
              )
            ]
          )
        )
    );
  }

}