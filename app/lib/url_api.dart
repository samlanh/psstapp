import 'package:flutter/material.dart';
class StringData{
  static String imageURL = 'http://192.168.1.8/psst/trunk/public/images';
  static String mainUrl = 'http://192.168.1.8/psst/trunk/public/api/index';
//  static String mainUrl = 'http://192.168.1.7/psst/trunk/public/api/index';
  static String loginUrl = mainUrl + '?url=auth';
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
  static String changePassword = mainUrl+'?url=changePassword';
  static String contactUs = mainUrl+'?url=contactus';
  static String eLearning = mainUrl+'?url=elearning';
  static String eLearningVideo = mainUrl+'?url=elearningvideo';
  static String downloadTranscript = mainUrl+'?url=transcriptpdf';
  static String slieshow = mainUrl+'?url=slieshow';
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
