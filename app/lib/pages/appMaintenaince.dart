import 'package:flutter/material.dart';
import 'package:app/localization/localization.dart';

class AppMaintenancePage extends StatefulWidget {
  final String urlVideo;
  final String currentLang;

  AppMaintenancePage({this.currentLang,this.urlVideo});

  @override
  _AppMaintenancePageState createState() => _AppMaintenancePageState();
}

class LearningVideo extends StatefulWidget {
  @override
  _AppMaintenancePageState createState() => _AppMaintenancePageState();
}

class _AppMaintenancePageState extends State<AppMaintenancePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(

      body:Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset('images/maintenance.png',width: 120),
            ),
            Text("Under Construnction",
              style: TextStyle(
                color: Colors.black45,
                fontSize: 18.0,
                fontFamily:'English',
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10.0),
            Text("We'are doing our best be back in",
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontFamily:'English'
              ),
            ),
            SizedBox(height: 10.0),
            new OutlineButton(
              padding: EdgeInsets.only(left:50.0,right: 50.0,top:5.0,bottom: 5.0),
              splashColor: Colors.grey,
                child: new Text("Go Home",
                  style: TextStyle(
                      fontSize: 16.0,color: Colors.black54,
                  fontFamily: 'English',fontWeight: FontWeight.bold)),
                onPressed:(){
                  //Navigator.pushNamed(context, '/',arguments:{});
                  Navigator.pop(context);
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0))
            ),
          ],
        ),
      )
      )
    ;

  }

}