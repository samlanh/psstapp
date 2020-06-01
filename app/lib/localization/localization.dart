import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalization{
  final Locale locale;

  DemoLocalization(this.locale);
  static DemoLocalization of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  Map<String, String> _localizedValues ;

  Future load() async{
    //debugPrint(locale.languageCode+"testtttttttt");
    String jsonStringValue = await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValue);

    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));

  }

  String tr(String key){
    return (_localizedValues[key]==null)? key : _localizedValues[key];
    //return _localizedValues[key];
  }
  // start
  static const LocalizationsDelegate<DemoLocalization> delegate = DemoLocalizationsDelegate();

}

class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalization> {
    const DemoLocalizationsDelegate();

    @override
    bool isSupported(Locale locale){
      return ['en','km'].contains(locale.languageCode);
    }

    @override
    Future<DemoLocalization> load(Locale locale) async {
      DemoLocalization localization = new DemoLocalization(locale);
      await localization.load();
      return localization;
    }

    @override
    bool shouldReload(DemoLocalizationsDelegate old) => false;
}

