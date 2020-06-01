import 'package:flutter/material.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<Marker> allMarkers = [];

  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(40.7128, -74.0060)));
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  movetoBoston() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(42.3601, -71.0589), zoom: 14.0, bearing: 45.0, tilt: 45.0),
    ));
  }

  movetoNewYork() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(40.7128, -74.0060), zoom: 12.0),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Row(
            children: <Widget>[
              Image.asset('images/about.png',height: 50.0),
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
        body:ListView(
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
                  ),
                ),
              child:  Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,//Color(0xffcfe5fa),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0),topRight: Radius.circular(40.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Stack(
                        children: [Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: GoogleMap(
                            initialCameraPosition:
                            CameraPosition(target: LatLng(11.5939334, 104.8812175), zoom: 12.0),
                            markers: Set.from(allMarkers),
                            onMapCreated: mapCreated,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            onTap: movetoBoston,
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.green
                              ),
                              child: Icon(Icons.forward, color: Colors.white),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: movetoNewYork,
                            child: Container(
                              height: 40.0,
                              width: 40.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.red
                              ),
                              child: Icon(Icons.backspace, color: Colors.white),
                            ),
                          ),
                        )
                        ]
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      color: Colors.white,
                      child:contactAddress(),
                    ),
                    contactDiagram(),
                  ],
                ),
              ),

            ),


          ],
        )
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
              rowContact(icon,title),
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
  Widget contactAddress(){
    return Row(
      children: <Widget>[

        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 5.0),
            margin: EdgeInsets.only(left: 5.0),

            child: Column(
              children: <Widget>[
                rowContact(Icon(Icons.pin_drop,color: Color(0xff2a62b4)),"#5-6, St.136, Phsar Thmei III, Duan Penh, Phnom Penh, Cambodia"),


                SizedBox(height:10.0),
                rowContact(Icon(Icons.call,color: Color(0xff2a62b4)),"+855 70 41 8002/+855 84 911 912"),
                SizedBox(height:10.0),
                rowContact(Icon(Icons.email,color: Color(0xff2a62b4)),"info@eess.edu.kh"),
                SizedBox(height:10.0),
                rowContact(Icon(Icons.web,color: Color(0xff2a62b4)),"www.elt.edu.kh"),
              ],
            ),
          ),
        )
      ],
    );
  }
  Widget rowContact(Icon icon,String textLabel){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        icon,
        SizedBox(width: 10.0),
        Expanded(child: Text(textLabel,style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w700,color: Color(0xff2a62b4))),)
      ],
    );
  }
  Widget contactDiagram(){
    return Container(
//      height: 100.0,
       child: Column(
         children: <Widget>[
           Container(
             margin: EdgeInsets.only(bottom: 5.0),
             child: Text("Contact Us",style: TextStyle(fontSize: 18.0,color: Color(0xff054798),fontWeight: FontWeight.bold)),
           ),
          Container(
            height: 40,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child:Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(width: 2.0, color:Color(0xff969696)),
                                left: BorderSide(width: 2.0, color: Color(0xff969696)),
                              ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 2.0,color: Color(0xff969696))),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Container(
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(width: 2.0,color: Color(0xff969696))),
                          ),
                        ),),
                        Expanded(child: Container(),)
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child:Row(
                      children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(width: 2.0, color:Color(0xff969696)),
                                    right: BorderSide(width: 2.0, color: Color(0xff969696)),
                                  ),
                                ),
                              ),
                              ),
                            Expanded(
                              child: Container(

                              ),
                            ),
                      ],
                  ),
                )
              ],
            ),
          ),
           SizedBox(height: 5.0),
           Row(
             children: <Widget>[
               Expanded(
                 flex: 1,
                 child: GestureDetector(
                   child: circelContact(Color(0xff3c5a99),"f",Icon(Icons.contact_mail),1),
                   onTap: () async{
                     if (await canLaunch("http://www.facebook.com")) {
                       await launch("http://www.facebook.com");
                     }
                   },
                 )
               ),
               Expanded(
                   flex: 1,
                   child: circelContact(Color(0xffff3d01),"",Icon(Icons.contact_mail,color: Colors.white,size: 40.0),2)
               ),
               Expanded(
                   flex: 1,
                   child: GestureDetector(
                     child: circelContact(Color(0xff11cf31),"",Icon(Icons.call,color: Colors.white,size: 40.0),2),
                     onTap: () async{
                       if (await canLaunch("tel://+85570418002")) {
                         await launch("tel://+85570418002");
                       }
                     },
                   )
               ),
             ],
           )
         ],
       ),
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
