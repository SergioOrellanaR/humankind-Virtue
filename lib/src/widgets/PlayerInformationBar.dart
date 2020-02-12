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
    return _playerNumber == 1 ? _playerOneInformation() : _playerTwoInformation();
  }

  _playerOneInformation()
  {
    return Row(
      children: <Widget>[
        _expanded(),
        _willInformation(),
        SizedBox(width: _screenSize.width * 0.08,),
        _structureInformation(),
        SizedBox(width: _screenSize.width * 0.02,),
        _avatarImage(),
      ],
    );

  }

  _playerTwoInformation()
  {
    return Row(
      children: <Widget>[
        _avatarImage(),
        SizedBox(width: _screenSize.width * 0.02,),
        _structureInformation(),
        SizedBox(width: _screenSize.width * 0.08,),
        _willInformation(),
        _expanded()
      ],
    );
  }

  Column _willInformation() {
    return Column(
        children: <Widget>[
          _willAndStructureInformation(isWill: true),
          _updateButton()
        ],
      );
  }

  Column _structureInformation() {
    return Column(
        children: <Widget>[
          _willAndStructureInformation(isWill: false),
          _fakeIcon()
        ],
      );
  }

  Icon _fakeIcon() => Icon(Icons.lock_outline, color: Colors.transparent,);

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
      child: add ? Icon(Icons.add) : Icon(Icons.remove),
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

  _pointsContainer({@required bool isWill}) {
    return Container(
      width: _screenSize.width * 0.09,
      height: _screenSize.width * 0.09,
      child: _valueToCounter(isWill: isWill),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _counterGradient(isWill: isWill),
          border: Border.all(
              width: 2.0,
              color: Color.fromRGBO(180, 180, 180, 1.0),
              style: BorderStyle.solid),
          boxShadow: kElevationToShadow[12]),
    );
  }

  Text _valueToCounter({@required bool isWill}) {
    
    String value = isWill
        ? "${_willPoints.toString()}/$_savedWill"
        : _structurePoints.toString();

    TextStyle style =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);

    if(isWill && value.length == 5)
    {
      style = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0);
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

  _updateButton() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _savedWill = _willPoints;
          });
        },
        child: Icon(Icons.lock_outline));
  }

  _avatarImage() 
  {
    AssetImage avatarImage;
    if(_playerNumber == 1)
    {
      avatarImage = AssetImage(utils.avatarsMap[prefs.playerOneAvatar].source);
    }
    else
    {
      avatarImage = AssetImage(utils.avatarsMap[prefs.playerTwoAvatar].source);
    }

    return Container(
      width: _screenSize.width * 0.25,
      height: _screenSize.width * 0.25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
        image: DecorationImage(
          image: avatarImage)
        )
      );
  }
}
