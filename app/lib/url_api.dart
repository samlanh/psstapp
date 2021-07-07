import 'package:flutter/material.dart';
class StringData{
 // psis: dfc704ab-e023-4b0b-b030-e300f13b74eb
  static String OnesigneAppId='2724c04c-dfba-428d-90b9-7739847d62b6';
  //static String imageURL = 'http://192.168.1.6/psst/trunk/public/images';
  //static String mainUrl = 'http://192.168.1.6/psst/trunk/public/api/index';
  static String imageURL = 'http://161.117.89.247/ahs.25.12.20/public/images';
  static String mainUrl = 'http://161.117.89.247/ahs.25.12.20/public/api/index';
  static String loginUrl = mainUrl + '?url=auth';
  static String changePassword = mainUrl+'?url=changePassword';
  static String addToken = mainUrl+'?url=addtoken';

  static String paymentUrl = mainUrl + '?url=payment';
  static String paymentDetailUrl = mainUrl + '?url=paymentDetail';
  static String studentProfile = mainUrl+'?url=profile'  ;
  static String schedule = mainUrl+'?url=schedule';
  static String attendance = mainUrl+'?url=attendance';
  static String attendanceDetail = mainUrl+'?url=attendanceDetail';
  static String discipline = mainUrl+'?url=discipline';
  static String disciplineDetail = mainUrl+'?url=disciplineDetail';
  static String score = mainUrl+'?url=score';
  static String scoreDetail = mainUrl+'?url=scoredetail';
  static String news = mainUrl+'?url=news';
  static String notification = mainUrl+'?url=notification';

  static String contactUs = mainUrl+'?url=contactus';
  static String singleContact = mainUrl+'?url=singlecontact';
  static String eLearning = mainUrl+'?url=elearning';
  static String eLearningVideo = mainUrl+'?url=elearningvideo';
  static String downloadTranscript = mainUrl+'/transcriptpdf';
  static String slideShow = mainUrl+'?url=slieshow';
  static String course = mainUrl+'?url=course';
  static String getDateHoliday = mainUrl+'?url=getholiday';
  static String calendar = mainUrl+'?url=calendar';
  static String introductionHome = mainUrl+'?url=introductionhome';
}
Widget notFoundPage(){
  return Center(
    child: Container(
      child: Column(
        children: <Widget>[
          Icon(Icons.open_in_browser,size: 50.0),
          Text("Sorry!No result found.",style: TextStyle(fontSize: 18.0,color: Colors.black54)),
          SizedBox(height: 10.0),
          Text("We're sorry what you were looking for.",style:TextStyle(fontSize: 14.0,color: Colors.black26)),
          Text("Please try again later.",style:TextStyle(fontSize: 14.0,color: Colors.black26))
        ],
      ),
    ),
  );
}

void noInternetConnection(){
//  DemoLocalization lang = DemoLocalization.of(context);
  showDialog(
//    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(0.0),
        title: new Text(("No Internet Connection"),textAlign: TextAlign.center,style: TextStyle(fontSize: 14.0),),
        content: Container(
          margin: EdgeInsets.all(5.0),
          height:MediaQuery.of(context).size.height*0.5,
          width: MediaQuery.of(context).size.width*1,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 2.0, color:Colors.black26),
            ),
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


//void _showDialog(context) {
//  showDialog(
//    context: context,
//    barrierDismissible: false,
//    builder: (context) {
//      return Dialog(
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.circular(4),
//        ),
//        elevation: 0,
//        child: Padding(
//          padding: EdgeInsets.symmetric(
//            horizontal: 20,
//            vertical: 10,
//          ),
//          child: IntrinsicWidth(
//            child: IntrinsicHeight(
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  SizedBox(
//                    height: 10,
//                  ),
//                  Text(
//                    "Custom Alert Dialog",
//                    style: TextStyle(
//                      fontWeight: FontWeight.w700,
//                      fontSize: 18,
//                    ),
//                  ),
//                  SizedBox(
//                    height: 20,
//                  ),
//
//                  SizedBox(
//                    height: 20,
//                  ),
//                  Align(
//                    alignment: Alignment.bottomRight,
//                    child: FlatButton(
//                      onPressed: () {
//                        Navigator.pop(context);
//                      },
//                      child: Text("OK"),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      );
//    },
//  );
//}