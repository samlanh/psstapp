import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
//import 'package:flutter_html_textview_render/html_text_view.dart';
import 'package:flutter_html/flutter_html.dart';



class AboutPage extends StatefulWidget{
//  final String studentId;
  final String currentLang;
  AboutPage({this.currentLang});
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  PageController _pageController = new PageController();
  int page =0;
  List aboutList = new List();
  List contactList = new List();

  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    _getJsonContact();
  }


  _getJsonContact() async{
    final String urlApi = StringData.contactUs+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
          contactList = json.decode(rawData.body)['result']['contact'] as List;
          aboutList = json.decode(rawData.body)['result']['about'] as List;
          isLoading = false;
        }
      });
    }
  }


//  Widget Button(Function function, IconData icon){
//    return FloatingActionButton(
//      onPressed: function,
//      materialTapTargetSize: MaterialTapTargetSize.padded,
//      backgroundColor: Colors.blue,
//      child: Icon(icon,size: 35.0),
//    );
//
//  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Row(
            children: <Widget>[
//              Image.asset('images/about.png',height: 50.0),
              Icon(Icons.person_pin,size: 30.0),
              SizedBox(width: 5.0,),
              Text("About"),
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
                    ]
                )
            ),
          ),
        ),
        body: new PageView(
          controller: _pageController,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  new BoxShadow (
                    color: Colors.lightBlue.withOpacity(0.2),
                    offset: new Offset(0.0, 2.0),
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child:aboutList.isNotEmpty ?
              isLoading ? new Stack(alignment: AlignmentDirectional.center,
                  children: <Widget>[new CircularProgressIndicator()]) : ListView.builder (
                  itemCount: aboutList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  aboutUs(aboutList[index]);
                  }
              ):Center(child:Text("No Result !")),
            ),

            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  new BoxShadow (
                    color: Colors.lightBlue.withOpacity(0.2),
                    offset: new Offset(0.0, 2.0),
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child:contactList.isNotEmpty ? isLoading ? new Stack(alignment: AlignmentDirectional.center,
                  children: <Widget>[new CircularProgressIndicator()]) : ListView.builder (
                  itemCount: contactList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  contactAddress(contactList[index]);
                  }
              ):Center(child:Text("No Result !")),
            ),

          ],
        ),


            bottomNavigationBar: new BottomNavigationBar(
                items: [
                  new BottomNavigationBarItem(icon: new Icon(Icons.person_pin), title: new Text("About us",
                    style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold))),
                  new BottomNavigationBarItem(icon: new Icon(Icons.location_on), title: new Text("Contact us",
                      style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold))),
                ],
                onTap: navigatePage,
                currentIndex: page,
                type: BottomNavigationBarType.fixed,
//                backgroundColor: Decoration(
//                  BoxDecoration(
//                      gradient: LinearGradient(
//                          begin: Alignment.centerLeft,
//                          end: Alignment.centerRight,
//                          colors: <Color>[
//                            Color(0xff054798),
//                            Color(0xff009ccf),
//                          ])
//                  ),
//                ),

//                fixedColor: const Color(0xff00c9d2),
            )

//            Container(
//                      margin: EdgeInsets.all(10.0),
//                      padding: EdgeInsets.all(10.0),
//                      height: 500.0,
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        boxShadow: <BoxShadow>[
//                          new BoxShadow (
//                            color: Colors.lightBlue.withOpacity(0.2),
//                            offset: new Offset(0.0, 2.0),
//                            blurRadius: 20.0,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Container(
//                      margin: EdgeInsets.all(10.0),
//                      padding: EdgeInsets.all(10.0),
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        boxShadow: <BoxShadow>[
//                          new BoxShadow (
//                            color: Colors.lightBlue.withOpacity(0.2),
//                            offset: new Offset(0.0, 2.0),
//                            blurRadius: 20.0,
//                          ),
//                        ],
//                      ),
//                      child:contactAddress(),
//                    ),
//                    contactDiagram(),
//                  ],
//                ),
//              ),
//
//            ),


//          ],
//        )
//        Container(
//            decoration: BoxDecoration(
//              gradient: LinearGradient(
//                  begin: Alignment.centerLeft,
//                  end: Alignment.centerRight,
//                  colors: <Color>[
//                    Color(0xff054798),
//                    Color(0xff009ccf),
//                  ]
//              ),
//            ),
//            child: Container(
//              height: MediaQuery.of(context).size.height,
//              decoration: BoxDecoration(
//                color: Color(0xffcfe5fa),
//                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0)),
//              ),
//              child: ListView(
//                children: <Widget>[
//                  SizedBox(height: 20.0,),
////                  aboutVission(),
////                  Container(
////                    color: Colors.white,
////                    child:contactAddress(),
////                  ),
////                  contactDiagram(),
//                ],
//              ),
//            )
//        )
    );
  }
//  void mapCreated(controller) {
//    setState(() {
//      _controller = controller;
//    });
//  }
//
//  movetoBoston() {
//    _controller.animateCamera(CameraUpdate.newCameraPosition(
//      CameraPosition(target: LatLng(42.3601, -71.0589), zoom: 14.0, bearing: 45.0, tilt: 45.0),
//    ));
//  }
//
//  movetoNewYork() {
//    _controller.animateCamera(CameraUpdate.newCameraPosition(
//      CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
//    ));
//  }
  void navigatePage(int page){
    _pageController.animateToPage(page,
        duration: new Duration(milliseconds: 500),
        curve: Curves.easeOutSine
    );
    setState(() {
      this.page = page;
    });
  }
  Widget aboutVission(Icon icon, String title){
    return Container(
      child: Container(
//        flex:  1,
        child: Container(
//          decoration: BoxDecoration(
//              border: Border.all(color: Color(0xff89b6dd),width: 2.0),
//              borderRadius: BorderRadius.circular(5.0),
//              color:Colors.white
//          ),
//          margin: EdgeInsets.all(5.0),
//          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              rowContact(icon,title,1),
              Directionality( textDirection: TextDirection.ltr,
                  child:  Text("Formally known as American Academy of Language and Art (AALA), ELT was founded by US "
                      "entrepreneurs who strongly believed that education was a foundation in rebuilding "
                      "has granted the rights for EESS to issue diplomas after meeting the credit requirements.",
                      style:TextStyle(),textAlign: TextAlign.justify
                  )
              ),
            ],
          )

        )

      ),
    );
  }

  Widget aboutUs(dataRow){
    return Container(
//      padding: EdgeInsets.only(left: 5.0),
//      margin: EdgeInsets.only(left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
              ),
            ),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text("- "+dataRow['title'].toString(),
              style: TextStyle(fontSize: 16.0,fontFamily: 'Khmer'),
            ),
          ),
          rowAbout(Icon(Icons.person_pin,color: Color(0xff2a62b4)),
              dataRow['description'].toString(),2),
          SizedBox(height:10.0),
        ],
      ),
    );
  }

  Widget contactAddress(dataRow){
    return Container(
      padding: EdgeInsets.only(left: 5.0),
      margin: EdgeInsets.only(left: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
              ),
            ),
            margin: EdgeInsets.only(bottom: 10.0),
            child: Text("- "+dataRow['title'].toString(),
              style: TextStyle(fontSize: 16.0,fontFamily: 'Khmer'),
            ),
          ),
          rowContact(Icon(Icons.pin_drop,color: Color(0xff2a62b4)),dataRow['description'].toString(),2),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.call,color: Color(0xff2a62b4)),dataRow['phone'].toString(),1),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.email,color: Color(0xff2a62b4)),dataRow['email'].toString(),1),
          SizedBox(height:10.0),
          rowContact(Icon(Icons.language,color: Color(0xff2a62b4)),dataRow['website'].toString(),1),
          SizedBox(height:25.0),
          Text("Find us",style:TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,color: Colors.black45)),
          SizedBox(height:10.0),
          Container(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: circelContact(Color(0xff3c5a99),"f",Icon(Icons.contact_mail),1),
                      onTap: () async{
                        if (await canLaunch(dataRow['facebook'].toString())) {
                          await launch(dataRow['facebook'].toString());
                        }
                      },
                    )
                ),
                SizedBox(width: 10.0),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () async{
                          if (await canLaunch(dataRow['youtube'].toString())) {
                            await launch(dataRow['youtube'].toString());
                          }
                        },
                        child: Image.asset('images/youtube.png',fit: BoxFit.cover,)
                      //circelContact(Color(0xffff3d01),"",Icon(Icons.youtube_searched_for,color: Colors.white,size: 40.0),2),
                    )
                ),
                SizedBox(width: 10.0),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () async{
                          if (await canLaunch(dataRow['instagram'].toString())) {
                            await launch(dataRow['instagram'].toString());
                          }
                        },
                        child: Image.asset('images/instagram.png',fit: BoxFit.cover,)
                    )
                ),
                SizedBox(width: 10.0),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      child: circelContact(Color(0xff11cf31),"",Icon(Icons.call,color: Colors.white,size: 40.0),2),
                      onTap: () async{
                        if (await canLaunch("tel://"+dataRow['phone'].toString())) {//"tel://+85570418002"
                          await launch("tel://"+dataRow['phone'].toString());
                        }
                      },
                    )
                ),
              ],
            )
          )
        ],
      ),
    );
  }
  Widget rowAbout(Icon icon,String textLabel,int type){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 10.0),
        Expanded(
            child: (type==1)? Text(
                textLabel,
                style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700,color: Colors.black45)
            ):Html(
              data: textLabel,
            )
        )
      ],
    );
  }
  Widget rowContact(Icon icon,String textLabel,int type){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        SizedBox(width: 10.0),
        Expanded(
            child: (type==1)? Text(
            textLabel,
            style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w700,color: Colors.black45)
          ):Html(
            data: textLabel,
          )
        )
      ],
    );
  }
 
  Widget circelContact(Color strColor,String strText,Icon icon,type){
    return Container(
      height: 70.0,
      width: 70.0,
      decoration: BoxDecoration(
        color:strColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: (type==1)?
        Text(strText,style: TextStyle(color:Colors.white,fontSize: 40.0,fontWeight: FontWeight.bold)):
        icon
      ),
    );
  }
  Widget _buildPaymentItem(String imgPath, String foodName, String price) {
    return new Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            new BoxShadow (
              color: Color(0xff009ccf),
              offset: new Offset(0.0, 2.0),
              blurRadius: 2.0,
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
              child:
              _rowTitleSchedule(Icon(Icons.library_books,color: Colors.white,size: 40.0,),'Very Good'),
            ) ,
            SizedBox(width: 5.0,height: 5.0),
            Expanded(
              child: Container(
//                decoration: BoxDecoration(
//                    border: Border(bottom:BorderSide(width: 2.0,color: Color(0xff009ccf)
//                    ) )),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text('ភាពឧស្សាហ៍ក្នុងការសិក្សា',style: TextStyle(fontFamily: 'Khmer',color: Color(0xff010101))),
                      Text('Dilligence'),
                    ]
                ),
              )
            )
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
