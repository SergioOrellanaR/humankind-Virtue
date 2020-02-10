import 'package:flutter/material.dart';
import 'package:humankind/src/pages/HomePage.dart';
import 'package:humankind/src/pages/SettingsPage.dart';

Map<String, WidgetBuilder> routeMap() {
  return <String, WidgetBuilder>{
    "home": (BuildContext context) => HomePage(),
    "settings": (BuildContext context) => SettingsPage()
  };
}
