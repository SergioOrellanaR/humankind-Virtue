import 'package:flutter/material.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/models/PlayerInformation.dart';
import 'package:humankind/utils/utils.dart' as utils;

class PlayerInformationBar extends StatefulWidget {
  final PlayerInformation playerInformation;

  PlayerInformationBar({@required this.playerInformation});

  @override
  _PlayerInformationBarState createState() => _PlayerInformationBarState();
}

class _PlayerInformationBarState extends State<PlayerInformationBar> {
  Size _screenSize;
  int _structurePoints;
  int _willPoints;
  int _savedWill;
  int _playerNumber;
  bool _buttonPressedOnOperation = false;
  bool _loopActiveOnOperation = false;
  final prefs = new UserConfig();

  @override
  void initState() {
    super.initState();
    _structurePoints = widget.playerInformation.structure;
    _willPoints = widget.playerInformation.will;
    _savedWill = widget.playerInformation.savedWill;
    _playerNumber = widget.playerInformation.playerNumber;
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return _rowInformation();
  }

  _rowInformation() {
    return _playerNumber == 1
        ? _playerOneInformation()
        : _playerTwoInformation();
  }

  _playerOneInformation() {
    return Row(
      children: <Widget>[
        _expanded(),
        _willInformation(),
        SizedBox(
          width: _screenSize.width * 0.1,
        ),
        _structureInformation(),
        SizedBox(
          width: _screenSize.width * 0.05,
        ),
        utils.allowAvatars ? _avatarImage() : Container(),
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }

  _playerTwoInformation() {
    return Row(
      children: <Widget>[
        utils.allowAvatars ? _avatarImage() : Container(),
        SizedBox(
          width: _screenSize.width * 0.05,
        ),
        _structureInformation(),
        SizedBox(
          width: _screenSize.width * 0.1,
        ),
        _willInformation(),
        _expanded()
      ],
    );
  }

  Column _willInformation() {
    return Column(
      children: <Widget>[
        _refillWillIcon(),
        _willAndStructureInformation(isWill: true),
        _updateButton()
      ],
    );
  }

  Column _structureInformation() {
    return Column(
      children: <Widget>[
        _fakeIcon(),
        _willAndStructureInformation(isWill: false),
        _fakeIcon()
      ],
    );
  }

  Icon _fakeIcon() => Icon(
        Icons.lock_outline,
        color: Colors.transparent,
        size: _screenSize.height * 0.04,
      );

  Expanded _expanded() {
    return Expanded(
      child: SizedBox(),
    );
  }

  Row _willAndStructureInformation({@required isWill}) {
    return Row(children: <Widget>[
      _addAndSubstractButton(isWill: isWill, add: false),
      _pointsContainer(isWill: isWill),
      _addAndSubstractButton(isWill: isWill, add: true),
    ]);
  }

  _addAndSubstractButton({@required bool isWill, @required bool add}) {
    return _operationButton(isWill: isWill, add: add);
  }

  Listener _operationButton({bool add = false, @required bool isWill}) {
    return Listener(
      onPointerDown: (details) {
        _buttonPressedOnOperation = true;
        _operateWhilePressed(add: add, isWill: isWill);
      },
      onPointerUp: (details) {
        _buttonPressedOnOperation = false;
      },
      child: add ? Icon(Icons.add, size: _screenSize.width * 0.07,) : Icon(Icons.remove, size: _screenSize.width * 0.07),
    );
  }

  void _operateWhilePressed({bool add = false, @required bool isWill}) async {
    // Solo hay 1 loop activo
    if (_loopActiveOnOperation) return;

    _loopActiveOnOperation = true;
    int maxLimit = 99;
    int minLimit = 0;

    while (_buttonPressedOnOperation) {
      setState(() {
        if (isWill) {
          if (add && _willPoints < maxLimit) {
            _willPoints++;
          } else if (!add && _willPoints > minLimit) {
            _willPoints--;
          }
        } else {
          if (add && _structurePoints < maxLimit) {
            _structurePoints++;
          } else if (!add && _structurePoints > minLimit) {
            _structurePoints--;
          }
        }
      });
      await Future.delayed(Duration(milliseconds: 150));
    }

    _loopActiveOnOperation = false;
  }

  GestureDetector _pointsContainer({@required bool isWill}) {
    return GestureDetector(
      onTap: () {
        if (isWill) {
          setState(() {
            _willPoints = _savedWill;
          });
        }
      },
      child: Container(
        width: _screenSize.width * 0.15,
        height: _screenSize.width * 0.15,
        child: _valueToCounter(isWill: isWill),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _counterGradient(isWill: isWill),
            border: Border.all(
                width: 2.0,
                color: utils.mainThemeColor(
                    prefs.isDarkTheme, Factions.values[prefs.faction]),
                style: BorderStyle.solid),
            boxShadow: kElevationToShadow[12]),
      ),
    );
  }

  Text _valueToCounter({@required bool isWill}) {
    String value = isWill
        ? "${_willPoints.toString()}/$_savedWill"
        : _structurePoints.toString();

    TextStyle style =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17);

    if (isWill && value.length >= 4) {
      style = TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14);
    }

    return Text(value, style: style);
  }

  LinearGradient _counterGradient({@required bool isWill}) {
    Color color1;
    Color color2;

    if (isWill) {
      color1 = Color.fromRGBO(167, 209, 249, 1.0);
      color2 = Color.fromRGBO(43, 29, 21, 1.0);
    } else {
      color1 = Color.fromRGBO(255, 104, 93, 1.0);
      color2 = Color.fromRGBO(30, 30, 62, 1.0);
    }

    return LinearGradient(colors: [
      color1,
      color2,
    ], begin: Alignment.topRight, end: Alignment.bottomLeft);
  }

  GestureDetector _updateButton() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _savedWill = _willPoints;
          });
        },
        child: Icon(Icons.lock_outline, size: _screenSize.height*0.04,));
  }

  Column _avatarImage() {
    AssetImage avatarImage;
    Color borderColor;
    String text;
    if (_playerNumber == 1) {
      avatarImage = AssetImage(utils.avatarsMap[prefs.playerOneAvatar].source);
      borderColor =
          utils.factionColor(utils.avatarsMap[prefs.playerOneAvatar].faction);
      text = prefs.playerOne;
    } else {
      avatarImage = AssetImage(utils.avatarsMap[prefs.playerTwoAvatar].source);
      borderColor =
          utils.factionColor(utils.avatarsMap[prefs.playerTwoAvatar].faction);
      text = prefs.playerTwo;
    }

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "settings", arguments: 2);
          },
          child: _avatarContainer(borderColor, avatarImage),
        ),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Container _avatarContainer(Color borderColor, AssetImage avatarImage) {
    return Container(
        width: _screenSize.width * 0.245,
        height: _screenSize.width * 0.245,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.0, color: borderColor),
            image: DecorationImage(image: avatarImage, fit: BoxFit.contain)));
  }

  _refillWill()
  {
    setState(() {
            _willPoints = _savedWill;
          });
  }

  _refillWillIcon() 
  {
    return GestureDetector(
      onTap: _refillWill,
      child: Icon(Icons.undo, size: _screenSize.height*0.04,),);
  }
}
