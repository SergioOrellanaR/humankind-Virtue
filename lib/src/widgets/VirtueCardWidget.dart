import 'package:flutter/material.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/controllers/VirtuesController.dart';
import 'package:humankind/src/models/AbstractVirtue.dart';
import 'package:humankind/src/models/FactionModel.dart';
import 'package:humankind/src/models/PlayerInformation.dart';
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
        _playerValue == 1
            ? Container(
                width: _screenSize.width * 0.13,
              )
            : _changePageArrow(),
        _virtueTable(),
        _playerValue == 1
            ? _changePageArrow()
            : Container(
                width: _screenSize.width * 0.13,
              ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  _virtueTable() {
    return GestureDetector(
      onHorizontalDragUpdate: (_) {},
      child: Row(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              Container(
                child: _tableInformation(),
                decoration: BoxDecoration(image: _cardImage()),
              )
            ],
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  Column _tableInformation() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: _screenSize.height * 0.02,
        ),
        _cardTitle(),
        SizedBox(
          height: _screenSize.height * 0.03,
        ),
        _stackedVirtueAndSpace(_virtuesController.factions[0],
            _virtuesController.virtuesValues[0]),
        _stackedVirtueAndSpace(_virtuesController.factions[1],
            _virtuesController.virtuesValues[1]),
        _stackedVirtueAndSpace(_virtuesController.factions[2],
            _virtuesController.virtuesValues[2]),
        _stackedVirtueAndSpace(_virtuesController.factions[3],
            _virtuesController.virtuesValues[3]),
        _stackedVirtueAndSpace(_virtuesController.factions[4],
            _virtuesController.virtuesValues[4]),
        _reRoll(),
        SizedBox(
          height: _screenSize.height * 0.02,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Text _cardTitle() {
    return Text(
      widget.player.playerNumber == 1 ? prefs.playerOne : prefs.playerTwo,
      style: TextStyle(
          color: utils.defaultThemeColor(prefs.isDarkTheme),
          fontWeight: FontWeight.bold),
    );
  }

  DecorationImage _cardImage() {
    return DecorationImage(image: AssetImage(_cardImageUrl));
  }

  Column _stackedVirtueAndSpace(Faction faction, Virtue virtue) {
    return Column(
      children: <Widget>[
        _stackedVirtues(faction, virtue),
        SizedBox(height: _screenSize.height * 0.02)
      ],
    );
  }

  Stack _stackedVirtues(Faction faction, Virtue virtue) {
    return Stack(
      children: <Widget>[
        _virtueLine(faction, virtue),
        _concealingWidget(faction, virtue)
      ],
    );
  }

  Row _virtueLine(Faction faction, Virtue virtue) {
    return Row(children: <Widget>[
      SizedBox(width: _screenSize.width * 0.08),
      _virtueSpace(_leftContainerDecoration(), faction.toString()),
      SizedBox(
        width: 0.3,
      ),
      _virtueSpace(_rightContainerDecoration(), virtue.value),
      SizedBox(width: _screenSize.width * 0.08),
    ], mainAxisAlignment: MainAxisAlignment.center);
  }

  Row _concealingWidget(Faction faction, Virtue virtue) {
    Container hiddenContainer = Container(
        width: _screenSize.width * 0.247, height: _screenSize.height * 0.06);
    Widget factionValue = hiddenContainer;
    Widget virtueValue = hiddenContainer;

    if (!faction.isVisible) {
      factionValue = _virtueSpace(
          _leftContainerDecoration(imageUrl: utils.leftTab), "",
          virtue: faction);
    }

    if (!virtue.isVisible) {
      virtueValue = _virtueSpace(
          _rightContainerDecoration(imageUrl: utils.rightTab), "",
          virtue: virtue);
    }

    return Row(children: <Widget>[
      SizedBox(width: _screenSize.width * 0.08),
      factionValue,
      SizedBox(
        width: 0.3,
      ),
      virtueValue,
      SizedBox(width: _screenSize.width * 0.08),
    ], mainAxisAlignment: MainAxisAlignment.center);
  }

  GestureDetector _virtueSpace(BoxDecoration decoration, String value,
      {AbstractVirtue virtue}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (virtue != null) {
            virtue.isVisible = true;
          }
        });
      },
      child: Container(
          child: Center(
              child: Text(
            value,
            style: TextStyle(color: Colors.black),
          )),
          decoration: decoration,
          width: _screenSize.width * 0.247,
          height: _screenSize.height * 0.06),
    );
  }

  BoxDecoration _leftContainerDecoration({String imageUrl}) {
    DecorationImage image;

    if (imageUrl != null) {
      image = DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.fill);
    }

    return BoxDecoration(
        //color: Color.fromRGBO(182, 158, 130, 1.0),
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0.0),
          topLeft: Radius.circular(13.0),
          bottomRight: Radius.circular(0.0),
          bottomLeft: Radius.circular(13.0),
        ),
        image: image);
  }

  BoxDecoration _rightContainerDecoration({String imageUrl}) {
    DecorationImage image;

    if (imageUrl != null) {
      image = DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.fill);
    }

    return BoxDecoration(
        //color: Color.fromRGBO(182, 158, 130, 1.0),
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(13.0),
            topLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(13.0),
            bottomLeft: Radius.circular(0.0)),
        image: image);
  }

  _reRoll() {
    return FloatingActionButton(
      child: Icon(Icons.refresh),
      backgroundColor: utils.oppositeThemeColor(prefs.isDarkTheme),
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
