import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/models/PlayerInformation.dart';
import 'package:humankind/src/widgets/PlayerInformationBar.dart';
import 'package:humankind/src/widgets/VirtueCardWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final prefs = new UserConfig();
  PlayerInformation playerOne;
  PlayerInformation playerTwo;
  Size _screenSize;

  @override
  void initState() {
    super.initState();
    playerOne = PlayerInformation.playerOne(userConfig: prefs);
    playerTwo = PlayerInformation.playerTwo();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _lockOrientationToPortrait();
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[_backgroundImage(), _body()],
        ),
        floatingActionButton: _settings(context),
      ),
    );
  }

  Row _settings(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: _screenSize.width * 0.08,),
        FloatingActionButton(
          child: Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, "settings");
          },
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  _body() {
    return Column(
      children: <Widget>[
        _playerInformationBar(playerInformation: playerTwo),
        _virtueCard(),
        _playerInformationBar(playerInformation: playerOne)
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  Future<void> _lockOrientationToPortrait() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _backgroundImage() {
    return Container();
  }

  _playerInformationBar({PlayerInformation playerInformation}) {   
    return PlayerInformationBar(playerInformation: playerInformation);
  }

  _virtueCard() {
    return VirtueCard(1);
  }
}
