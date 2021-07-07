import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreenpage extends StatefulWidget {
  @override
  _SplashScreenpageState createState() => _SplashScreenpageState();
}

class _SplashScreenpageState extends State<SplashScreenpage> {
  setTime(int number){
    var duration = new Duration(seconds: number);
    return new Timer(duration,navigateToHome);
  }

  void navigateToHome(){
    Navigator.of(context).pushReplacementNamed('/plashscreen');
  }

  @override
  void initState() {
    super.initState();
    setTime(1000);
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          stops: [
            0.3,
            0.6,
            0.9
          ],
          colors:[
            Color(0xff3568aa),
            Color(0xff357fad),
            Color(0xff3289a5),

          ],
        )
      ),
      child: Padding(
          padding:EdgeInsets.only(top: 80.0),
              child: Column(
              children: <Widget>[
                new Image.asset('images/schoollogo.png',width:120.0,),
                new Text("SCHOOL_NAME_KH",
                    style: new TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: 'Khmermoul',

                    ),
                )
              ],
              )
      )
    );
  }
}