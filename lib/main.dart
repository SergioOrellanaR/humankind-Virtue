import 'package:flutter/material.dart';
import 'package:humankind/utils/utils.dart' as utils;
import 'package:humankind/utils/routes.dart' as routes;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: utils.appName,
        initialRoute: "home",
        routes: routes.routeMap(),
        debugShowCheckedModeBanner: false);
  }
}
