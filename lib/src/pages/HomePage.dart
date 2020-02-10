import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/models/PlayerInformation.dart';
import 'package:humankind/src/widgets/PlayerInformationBar.dart';
import 'package:humankind/src/widgets/VirtueCardWidget.dart';
import 'package:humankind/utils/themeValues.dart' as theme;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final prefs = new UserConfig();
  PlayerInformation playerOne;
  PlayerInformation playerTwo;
  Size _screenSize;
  final _pageViewController = PageController();

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
          backgroundColor: theme.oppositeThemeColor(prefs.isDarkTheme),
          onPressed: () {
            Navigator.pushNamed(context, "settings");
          },
          heroTag: "settingsButton",
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
        Expanded(child: SizedBox(),),
        _playerInformationBar(playerInformation: playerOne)
      ],
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

  PlayerInformationBar _playerInformationBar({PlayerInformation playerInformation}) {   
    return PlayerInformationBar(playerInformation: playerInformation);
  }

  _virtueCard() {
    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.6,
      child: PageView(
        controller: _pageViewController,
        children: <Widget>[
          VirtueCard(player: playerOne, pageViewController: _pageViewController),
          VirtueCard(player: playerTwo, pageViewController: _pageViewController)
        ],
      ),
    );
  }
}
