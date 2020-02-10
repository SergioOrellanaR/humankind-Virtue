import 'package:flutter/material.dart';
import 'package:humankind/src/widgets/VirtueCardWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Humankind"),
      ),
      body: Stack(children: <Widget>[
        _backgroundImage(),
        VirtueCard()
      ],),
    );
  }

  _backgroundImage()
  {
    return Container(color: Colors.white,);
  }
}
