import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
//import 'package:app/url_api.dart';
//import 'package:app/localization/localization.dart';
//import 'package:http/http.dart' as http;
//import 'dart:convert';
 class BlogWidget
{

       Container contactAddress(dataRow) {
        return Container(
          padding: EdgeInsets.only(left: 5.0),
          margin: EdgeInsets.only(left: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //          width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: Color(0xff07548f)),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text("- " + dataRow['title'].toString(),
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Khmer'),
                ),
              ),
              rowContact(Icon(Icons.pin_drop, color: Color(0xff2a62b4)),
                  dataRow['description'].toString(), 2),
              SizedBox(height: 10.0),
              rowContact(Icon(Icons.call, color: Color(0xff2a62b4)),
                  dataRow['phone'].toString(), 1),
              SizedBox(height: 10.0),
              rowContact(Icon(Icons.email, color: Color(0xff2a62b4)),
                  dataRow['email'].toString(), 1),
              SizedBox(height: 10.0),
              rowContact(Icon(Icons.language, color: Color(0xff2a62b4)),
                  dataRow['website'].toString(), 1),
              SizedBox(height: 25.0),
              Text("Find us", style: TextStyle(fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45)),
              SizedBox(height: 10.0),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            child: circelContact(
                                Color(0xff3c5a99), "f", Icon(Icons.contact_mail), 1),
                            onTap: () async {
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
                              onTap: () async {
                                if (await canLaunch(dataRow['youtube'].toString())) {
                                  await launch(dataRow['youtube'].toString());
                                }
                              },
                              child: Image.asset(
                                'images/youtube.png', fit: BoxFit.cover,)
                            //circelContact(Color(0xffff3d01),"",Icon(Icons.youtube_searched_for,color: Colors.white,size: 40.0),2),
                          )
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: () async {
                                if (await canLaunch(
                                    dataRow['instagram'].toString())) {
                                  await launch(dataRow['instagram'].toString());
                                }
                              },
                              child: Image.asset(
                                'images/telegram.png', fit: BoxFit.cover,)
                          )
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                              child: circelContact(Color(0xff11cf31), "",
                                  Icon(Icons.call, color: Colors.white, size: 40.0),
                                  2),
                              onTap: () async {
                                if (await canLaunch("tel://" + dataRow['phone']
                                    .toString())) { //"tel://+85570418002"
                                  await launch(
                                      "tel://" + dataRow['phone'].toString());
                                }
                              }
                          )
                      ),
                    ],
                  )
              )
            ],
          ),
        );
      }

      Widget rowContact(Icon icon, String textLabel, int type) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(width: 10.0),
            Expanded(
                child: (type == 1) ? Text(
                    textLabel,
                    style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45)
                ) : Html(
                  data: textLabel,
                )
            )
          ],
        );
      }

      Widget circelContact(Color strColor, String strText, Icon icon, type) {
        return Container(
          height: 70.0,
          width: 70.0,
          decoration: BoxDecoration(
            color: strColor,
            shape: BoxShape.circle,
          ),
          child: Center(
              child: (type == 1) ?
              Text(strText, style: TextStyle(
                  color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold)) :
              icon
          ),
        );
      }
}
