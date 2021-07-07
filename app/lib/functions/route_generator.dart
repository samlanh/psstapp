import 'package:flutter/material.dart';
import 'package:app/main.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:app/pages/loginpage.dart';
import 'package:app/pages/paymentPage.dart';
import 'package:app/pages/schedulePage.dart';
import 'package:app/pages/profilePage.dart';
import 'package:app/pages/settingPage.dart';
//import 'package:app/pages/valuationPage.dart';
import 'package:app/pages/newsPage.dart';
import 'package:app/pages/aboutPage.dart';
import 'package:app/pages/calendarPage.dart';
import 'package:app/pages/attendancePage.dart';
import 'package:app/pages/disciplinePage.dart';
import 'package:app/pages/scorePage.dart';
import 'package:app/pages/notification.dart';
import 'package:app/pages/learningPage.dart';
import 'package:app/pages/frontPage.dart';
//import 'package:flutter/services.dart';
import 'package:app/pages/coursePage.dart';
import 'package:app/pages/appMaintenaince.dart';

class RoutGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
   // final args = settings.arguments;
    final Map arguments = settings.arguments as Map;

    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_)=>HomeApp());
        break;

      case 'FRONTPAGE':
        return MaterialPageRoute(builder: (_)=>FrontPage());
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => FrontPage(currentLang:currentLang)), (Route<dynamic> route) => false);

        break;
      case 'PAYMENT':
        return MaterialPageRoute(builder: (_)=>PaymentPage(
            title: arguments['title'],
            currentLang: arguments['currentLang'],
            studentId: arguments['studentId'],
      ));
        break;

      case 'SCHEDULE':
        return MaterialPageRoute(builder: (_)=>SchedulePage(
          title: arguments['title'],
          studentId: arguments['studentId'],
          currentLang: arguments['currentLang'],
        ));
        break;

        case 'ATTENDANCE':
        return MaterialPageRoute(builder: (_)=>AttendancePage(
          studentId: arguments['studentId'],
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'SCORE':
        return MaterialPageRoute(builder: (_)=>ScorePage(
          studentId: arguments['studentId'],
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'DISCIPLINE':
        return MaterialPageRoute(builder: (_)=>DisciplinePagePage(
          studentId: arguments['studentId'],
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'CALENDAR':
        return MaterialPageRoute(builder: (_)=>CalendarPage(
          currentLang: arguments['currentLang'],
        ));
        break;

//      case 'LEARNING':
//        return MaterialPageRoute(builder: (_)=>LearningPage(
//          studentId: arguments['studentId'],
//          currentLang: arguments['currentLang'],
//        ));
//        break;

      case 'NEWS':
        return MaterialPageRoute(builder: (_)=>NewsEventPage(
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'ABOUT':
        return MaterialPageRoute(builder: (_)=>AboutPage(
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'COURSE':
        return MaterialPageRoute(builder: (_)=>CoursePage(
          title: arguments['title'],
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'SETTING':
        return MaterialPageRoute(builder: (_)=>SettingPage(
          studentId: arguments['studentId'],
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'LOGIN':
        return MaterialPageRoute(builder: (_)=>LoginPage(

        ));
        break;

      case 'NOTIFICATION':
        return MaterialPageRoute(builder: (_)=>NotificationPage(
          studentId: arguments['studentId'],
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'PROFILE':
        return MaterialPageRoute(builder: (_)=>ProfilePage(
          studentId: arguments['studentId'],
          currentLang: arguments['currentLang'],
        ));
        break;

      case 'MAINTENANCE':
        return MaterialPageRoute(builder: (_)=>AppMaintenancePage(
        ));
        break;

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic>_errorRoute(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title:Text('Error')
          ),
          body: Center(
            child: Text('Page No Found!'),
          ),
        );
      }
    );
  }
}