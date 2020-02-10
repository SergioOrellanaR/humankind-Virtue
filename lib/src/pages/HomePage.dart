import 'package:flutter/material.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/widgets/VirtueCardWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final prefs = new UserConfig();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        VirtueCard()
      ],),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.settings), onPressed: (){Navigator.pushNamed(context, "settings");},),
    );
  }
}
