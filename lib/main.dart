import 'dart:convert';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/models/AvatarModel.dart';
import 'package:humankind/utils/utils.dart' as utils;
import 'package:humankind/utils/routes.dart' as routes;

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserConfig();
  await prefs.initPrefs();
  await utils.loadAvatars();
  runApp(MyApp(prefs: prefs));
} 

class MyApp extends StatelessWidget {
  final UserConfig prefs;

  MyApp({this.prefs});

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: prefs.isDarkTheme ? Brightness.dark : Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.indigo,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme)
      {
        return MaterialApp(
        title: utils.appName,
        initialRoute: "home",
        routes: routes.routeMap(),
        theme: theme,
        debugShowCheckedModeBanner: false);
      },
    );    
  }
}
