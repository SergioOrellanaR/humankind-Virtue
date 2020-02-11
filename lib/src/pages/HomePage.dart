import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/models/PlayerInformation.dart';
import 'package:humankind/src/widgets/PlayerInformationBar.dart';
import 'package:humankind/src/widgets/VirtueCardWidget.dart';
import 'package:humankind/utils/utils.dart' as utils;

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
          children: <Widget>[_background(), _body()],
        ),
        floatingActionButton: _actionButtons(context)
      ),
    );
  }

  Row _actionButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: _screenSize.width * 0.08,
        ),
        FloatingActionButton(
          child: Icon(Icons.settings, color: utils.oppositeThemeColor(prefs.isDarkTheme, Factions.values[prefs.faction]),),
          backgroundColor: utils.mainThemeColor(prefs.isDarkTheme, Factions.values[prefs.faction]),
          onPressed: () {
            Navigator.pushNamed(context, "settings");
          },
          heroTag: "settingsButton",
        ),
        SizedBox(
          width: _screenSize.width * 0.1,
        ),
        _restartButton(),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
    );
  }

  _body() {
    return Column(
      children: <Widget>[
        Expanded(child: _playerInformationBar(playerInformation: playerTwo)),
        _virtueCard(),
        Expanded(child: _playerInformationBar(playerInformation: playerOne))
      ],
    );
  }

  Future<void> _lockOrientationToPortrait() {
    return SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _background() {
    if (prefs.faction != Factions.ninguno.index) {
      return Stack(children: <Widget>[
        _centerBackgroundImage(),
        _factionCornerImage()
      ],);
    } else {
      return Container();
    }
  }

  PlayerInformationBar _playerInformationBar(
      {PlayerInformation playerInformation}) {
    return PlayerInformationBar(playerInformation: playerInformation);
  }

  _virtueCard() {
    return Container(
      width: double.infinity,
      height: _screenSize.height * 0.6,
      child: PageView(
        controller: _pageViewController,
        children: <Widget>[
          VirtueCard(
              player: playerOne, pageViewController: _pageViewController),
          VirtueCard(player: playerTwo, pageViewController: _pageViewController)
        ],
      ),
    );
  }

  Widget _restartButton() {
    return RaisedButton(
        child: Padding(
          //EdgeInsets.symetric para distintos valores UwU
          padding: EdgeInsets.all(12.0),
          child: Text(
            "Reiniciar juego",
            style: TextStyle(
                fontSize: 18.0,
                color: utils.oppositeThemeColor(prefs.isDarkTheme, Factions.values[prefs.faction]),
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () {
          // Navigator.pushReplacementNamed(context, "home");
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => HomePage(),
              transitionsBuilder: (context, anim1, anim2, child) =>
                  FadeTransition(opacity: anim1, child: child),
              transitionDuration: Duration(seconds: 1),
            ),
          );
        },
        color: utils.mainThemeColor(prefs.isDarkTheme, Factions.values[prefs.faction]),
        shape: StadiumBorder());
  }

  Center _centerBackgroundImage() {
    return Center(
      child: Container(
        height: _screenSize.height * 0.2,
        width: _screenSize.height * 0.2,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: utils.factionImage(Factions.values[prefs.faction]),
                fit: BoxFit.fill)),
      ),
    );
  }

  _factionCornerImage() 
  {
    return Positioned(
      top: 4.0,
      right: 4.0,
          child: Container(
        width: _screenSize.height * 0.1,
        height: _screenSize.height * 0.1,
        decoration: BoxDecoration(
          image: DecorationImage(
                  image: utils.factionImage(Factions.values[prefs.faction]),
                  fit: BoxFit.fill)
        ),
      ),
    );
  }
}
