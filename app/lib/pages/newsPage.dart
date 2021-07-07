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
  List<NetworkImage> imagesList = List<NetworkImage>();
  String currentFont='Khmer';

  @override
  void initState() {
    _getJsonNews();
    super.initState();
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
            Text(lang.tr("News & Event"),style:TextStyle(
              fontFamily: currentFont,
              fontSize: 18.0))
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
          )
        )
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left:0.0,right: 0.0,bottom: 10.0),
                  margin: EdgeInsets.only(bottom: 10.0),
                  child: isLoading ? new Stack(alignment: AlignmentDirectional.center,
                      children: <Widget>[new CircularProgressIndicator()]) : sliderContents()
                )
              ),
              Expanded(
                flex: 8,
                child:isLoading ? new Center(
                  child: new CircularProgressIndicator()) :
                  newsList.isNotEmpty ? ListView.builder (
                  itemCount: newsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  _buildNewsItem(newsList[index]);
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
            ]
          )
      )
    );
  }


  _getJsonNews() async{
    final String urlApi = StringData.news+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        currentFont = (Localizations.localeOf(context).languageCode=='km')?'Khmer':'English';
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          newsList = json.decode(rawData.body)['result']['normal_news'] as List;
          var listFeature =  json.decode(rawData.body)['result']['feature_news'] as List;
          for (var i = 0; i < listFeature.length; i++) {
            if(listFeature[i]['image_feature'].toString()!='' && listFeature[i]['image_feature'].toString()!='null') {
              imagesList.add(NetworkImage(StringData.imageURL + '/newsevent/' +
                  listFeature[i]['image_feature'].toString(),scale: 1.0));
            }
          }
          isLoading = false;
        }
      });
    }
  }


  Widget sliderContents(){
    return SizedBox(
        height: 200.0,
        width: MediaQuery.of(context).size.width,
        child:  Carousel(
          images:imagesList,
          dotSize: 10.0,
          dotSpacing: 10.0,
          dotColor: Color(0xff07548f),
          indicatorBgPadding: 10.0,
          dotBgColor: Colors.transparent,
          borderRadius: false,
        )
    );
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
          padding: EdgeInsets.all(5.0),
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
                  ]
                )
              ),
              height: 105.0,
              width: 130.0,
              child:((rowData['image_feature'].toString()!='')
                ? Image.network(StringData.imageURL+'/newsevent/'+rowData['image_feature'],fit: BoxFit.cover)
                : Image.asset('images/news.png',fit: BoxFit.cover)
              )
            ),
            SizedBox(width: 5.0,height: 5.0),
            Expanded(
              child: Container(
                height: 100.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Flexible(
                      child: Text(rowData['title'].toString(), style: TextStyle(
                          fontFamily: currentFont,fontSize: 12.0),
                          overflow: TextOverflow.fade
                      )
                    ),
                    Directionality( textDirection: TextDirection.ltr,
                      child: Text("",textAlign: TextAlign.justify),
                    ),
                    Row(
//                      alignment: AlignmentDirectional.bottomStart,
                      children: <Widget>[
                        Icon(Icons.calendar_today,size:12.0,color: Colors.black45),
                        SizedBox(width: 10.0),
                        Text(rowData['publish_date'].toString(),style: TextStyle(color: Colors.black45,fontSize:10.0))
                      ],
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