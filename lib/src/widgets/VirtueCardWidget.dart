import 'package:flutter/material.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/controllers/VirtuesController.dart';
import 'package:humankind/src/models/PlayerInformation.dart';
import 'package:humankind/utils/themeValues.dart' as theme;
import 'package:humankind/utils/utils.dart' as utils;

class VirtueCard extends StatefulWidget {
  final PlayerInformation player;
  final PageController pageViewController;

  VirtueCard({@required this.player, this.pageViewController});

  @override
  _VirtueCardState createState() => _VirtueCardState();
}
//TODO: Agregar borde a la fila.
//TODO: Agregar otras funcionalidades

class _VirtueCardState extends State<VirtueCard> {
  Size _screenSize;
  String _cardImageUrl;
  VirtuesController _virtuesController;
  int _playerValue;
  final prefs = new UserConfig();

  @override
  void initState() {
    super.initState();
    _virtuesController = widget.player.virtuesController;
    _playerValue = widget.player.playerNumber;
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _cardImageUrl = prefs.isDarkTheme ? 'assets/card2.png' : 'assets/card1.png';
    // return Center(child: _virtueTable());
    return _mainScreen();
  }

  Row _mainScreen() {
    return Row(
      children: <Widget>[
        _playerValue == 1 ? Container(width: _screenSize.width*0.13,) : _changePageArrow(),
        _virtueTable(),
        _playerValue == 1 ? _changePageArrow() : Container(width: _screenSize.width*0.13,),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  _virtueTable() {
    return GestureDetector(
      onHorizontalDragUpdate: (_){},
          child: Row(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: _screenSize.height * 0.02,
                    ),
                    _cardTitle(),
                    SizedBox(
                      height: _screenSize.height * 0.03,
                    ),
                    _stackedVirtueAndSpace(_virtuesController.factions[0].toString(),
                        _virtuesController.virtuesValues[0].value),
                    _stackedVirtueAndSpace(_virtuesController.factions[1].toString(),
                        _virtuesController.virtuesValues[1].value),
                    _stackedVirtueAndSpace(_virtuesController.factions[2].toString(),
                        _virtuesController.virtuesValues[2].value),
                    _stackedVirtueAndSpace(_virtuesController.factions[3].toString(),
                        _virtuesController.virtuesValues[3].value),
                    _stackedVirtueAndSpace(_virtuesController.factions[4].toString(),
                        _virtuesController.virtuesValues[4].value),
                    _reRoll(),
                    SizedBox(
                      height: _screenSize.height * 0.02,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                decoration: BoxDecoration(image: _cardImage()),
              )
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Text _cardTitle() {
    return Text(
      widget.player.playerNumber == 1 ? prefs.playerOne : prefs.playerTwo,
      style: TextStyle(
          color: theme.defaultThemeColor(prefs.isDarkTheme),
          fontWeight: FontWeight.bold),
    );
  }

  DecorationImage _cardImage() {
    return DecorationImage(image: AssetImage(_cardImageUrl));
  }

  Stack _stackedVirtues(String factionValue, String virtueValue)
  {
    return Stack(children: <Widget>[
      _virtueLine(factionValue, virtueValue),
      _concealingWidget()
    ],);
  }

  Column _stackedVirtueAndSpace(String factionValue, String virtueValue) {
    return Column(
      children: <Widget>[
        _stackedVirtues(factionValue, virtueValue),
        SizedBox(height: _screenSize.height * 0.02)
      ],
    );
  }

  Row _virtueLine(String factionValue, String virtueValue) {
    return Row(children: <Widget>[
      SizedBox(width: _screenSize.width * 0.08),
      _virtueSpace(_leftContainerDecoration(), factionValue),
      SizedBox(
        width: 0.3,
      ),
      _virtueSpace(_rightContainerDecoration(), virtueValue),
      SizedBox(width: _screenSize.width * 0.08),
    ], mainAxisAlignment: MainAxisAlignment.center);
  }

  Row _concealingWidget() {
    return Row(children: <Widget>[
      SizedBox(width: _screenSize.width * 0.08),
      _virtueSpace(_leftContainerDecoration(), ""),
      SizedBox(
        width: 0.3,
      ),
      _virtueSpace(_rightContainerDecoration(), ""),
      SizedBox(width: _screenSize.width * 0.08),
    ], mainAxisAlignment: MainAxisAlignment.center);
  }

  Container _virtueSpace(BoxDecoration decoration, String value) {
    return Container(
      child: Center(
          child: Text(
        value,
        style: TextStyle(color: Colors.black),
      )),
      decoration: decoration,
      width: _screenSize.width * 0.247,
      height: _screenSize.height * 0.06,
    );
  }

  BoxDecoration _leftContainerDecoration() {
    
    DecorationImage image = DecorationImage(image: AssetImage(utils.leftTab), fit: BoxFit.fill);
    return BoxDecoration(
      //color: Color.fromRGBO(182, 158, 130, 1.0),
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(0.0),
        topLeft: Radius.circular(13.0),
        bottomRight: Radius.circular(0.0),
        bottomLeft: Radius.circular(13.0),
      ),
      image: image
    );
  }

  BoxDecoration _rightContainerDecoration() {
    DecorationImage image = DecorationImage(image: AssetImage(utils.rightTab), fit: BoxFit.fill);

    return BoxDecoration(
      //color: Color.fromRGBO(182, 158, 130, 1.0),
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(13.0),
          topLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(13.0),
          bottomLeft: Radius.circular(0.0)),
      image: image
    );
  }

  _reRoll() {
    return FloatingActionButton(
      child: Icon(Icons.refresh),
      backgroundColor: theme.oppositeThemeColor(prefs.isDarkTheme),
      mini: true,
      heroTag: "card$_playerValue",
      onPressed: () {
        setState(() {
          widget.player.virtuesController.reshuffle();
          _virtuesController = widget.player.virtuesController;
        });
      },
    );
  }

  _changePageArrow() {
    IconData iconData = _playerValue == 1
        ? Icons.keyboard_arrow_right
        : Icons.keyboard_arrow_left;
    return GestureDetector(
      child: Icon(iconData, size: _screenSize.width * 0.13),
      onTap: () {
        if (_playerValue == 1) {
          widget.pageViewController.nextPage(
            duration: Duration(milliseconds: 400),
            curve: Curves.linearToEaseOut,
          );
        } else {
          widget.pageViewController.previousPage(
            duration: Duration(milliseconds: 400),
            curve: Curves.linearToEaseOut,
          );
        }
      },
    );
  }
}
