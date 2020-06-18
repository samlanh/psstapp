import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';



const STRING_LANG_CODE='langaugescode';
Future<Locale> setLocale(String languageCode) async{
  SharedPreferences _pref = await SharedPreferences.getInstance();
  _pref.setString(STRING_LANG_CODE, languageCode);
  return _locale(languageCode);
}
Locale _locale(String languageCode){
  Locale _temp;
  if(languageCode=='en'){
    _temp = Locale('en','US');
  }else{
    _temp = Locale('km','KH');
  }
  return _temp;
}
Future<Locale> getLocale() async{
  SharedPreferences _pref = await SharedPreferences.getInstance();
  String languageCode = _pref.getString(STRING_LANG_CODE) ?? 'km';
  return _locale(languageCode);
}