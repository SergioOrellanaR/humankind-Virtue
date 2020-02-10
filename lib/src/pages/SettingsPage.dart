import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/utils/themeValues.dart' as theme;
import 'package:humankind/utils/utils.dart' as utils;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _playerOne;
  String _playerTwo;
  int _defaultWill;
  int _defaultStructure;
  bool _isDarkTheme;
  Factions _faction;

  TextEditingController _textEditingController;
  Size _screenSize;
  final prefs = new UserConfig();

  @override
  void initState() {
    super.initState();
    _playerOne = prefs.playerOne;
    _playerTwo = prefs.playerTwo;
    _defaultWill = prefs.defaultWill;
    _defaultStructure = prefs.defaultStructure;
    _isDarkTheme = prefs.isDarkTheme;
    _faction = Factions.values[prefs.faction];
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: _appBar(),
        body: Stack(
          children: <Widget>[_body()],
        ));
  }

  AppBar _appBar() {
    return AppBar(title: Text("Ajustes"));
  }

  ListView _body() {
    return ListView(
      children: <Widget>[
        Divider(),
        _subTitle("Jugadores"),
        Divider(),
        _playerInformation(playerNumber: 1),
        _playerInformation(playerNumber: 2),
        Divider(),
        _subTitle("Valores"),
        Divider(),
        _willOrStructureValue(isWill: false),
        _willOrStructureValue(isWill: true),
        Divider(),
        _subTitle("Tema"),
        Divider(),
        _selectTheme(),
        Divider(),
        _subTitle("Facción"),
        Divider(),
        _selectFaction()
      ],
    );
  }

  Container _subTitle(String value) {
    return Container(
      child: Text(
        value,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Container _playerInformation({@required int playerNumber}) {
    String playerString;

    if (playerNumber == 1) {
      playerString = _playerOne;
    } else if (playerNumber == 2) {
      playerString = _playerTwo;
    }

    Color defaultColor = theme.oppositeThemeColor(_isDarkTheme);
    TextStyle defaultStyle = TextStyle(color: defaultColor);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _textEditingController,
        maxLines: 1,
        initialValue: playerString,
        cursorColor: defaultColor,
        style: defaultStyle,
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        decoration: InputDecoration(
          labelText: "Jugador $playerNumber",
          labelStyle: defaultStyle,
          helperText: "Nombre de jugador $playerNumber",
          helperStyle: defaultStyle,
          hoverColor: defaultColor,
        ),
        maxLengthEnforced: true,
        onChanged: (value) {
          setState(() {
            if (playerNumber == 1) {
              _playerOne = value;
              prefs.playerOne = value;
            } else if (playerNumber == 2) {
              _playerTwo = value;
              prefs.playerTwo = value;
            }
          });
        },
      ),
    );
  }

  Container _willOrStructureValue({@required bool isWill}) {
    String value = isWill ? "Voluntad" : "Estructura";
    Color defaultColor = theme.oppositeThemeColor(_isDarkTheme);
    TextStyle defaultStyle = TextStyle(color: defaultColor);
    String defaultValue =
        (isWill ? _defaultWill : _defaultStructure).toString();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _textEditingController,
        maxLines: 1,
        initialValue: defaultValue,
        keyboardType: TextInputType.number,
        cursorColor: defaultColor,
        style: defaultStyle,
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            labelText: value,
            labelStyle: defaultStyle,
            helperText: "Valor de $value por defecto",
            helperStyle: defaultStyle,
            hoverColor: defaultColor,
            suffixIcon: Icon(
              Icons.lens,
              color: isWill ? Colors.blue : Colors.red,
            )),
        maxLengthEnforced: true,
        onChanged: (value) {
          setState(() {
            if (isWill) {
              _defaultWill = int.parse(value);
              prefs.defaultWill = int.parse(value);
            } else {
              _defaultStructure = int.parse(value);
              prefs.defaultStructure = int.parse(value);
            }
          });
        },
      ),
    );
  }

  _selectTheme() {
    return Row(children: <Widget>[
      _containerTheme(isDarkTheme: false),
      _containerTheme(isDarkTheme: true)
    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }

  _selectFaction() {
    return Wrap(children: <Widget>[
      _containerTheme(faction: Factions.ninguno),
      _containerTheme(faction: Factions.abismales),
      _containerTheme(faction: Factions.quimera),
      _containerTheme(faction: Factions.acracia),
      _containerTheme(faction: Factions.corporacion)
    ],
    direction: Axis.horizontal,
    spacing: _screenSize.width * 0.15,
    runSpacing: _screenSize.height * 0.05,
    alignment: WrapAlignment.spaceEvenly);
  }

  Column _containerTheme({bool isDarkTheme, Factions faction}) {
    String optionValue;

    if (faction == null) {
      optionValue = isDarkTheme ? "Dark" : "Light";
    } else {
      optionValue = utils.stringfiedFaction(faction);
    }

    return Column(children: <Widget>[
      _optionContainer(isDarkTheme: isDarkTheme, faction: faction),
      _optionRadio(isDarkTheme: isDarkTheme, faction: faction),
      Text(optionValue)
    ]);
  }

  _optionContainer({bool isDarkTheme, Factions faction}) {
    return GestureDetector(
      onTap: () => faction == null
          ? _setSelectedTheme(isDarkTheme)
          : _setSelectedFaction(faction),
      child: Container(
        height: _screenSize.height * 0.15,
        width: _screenSize.height * 0.15,
        decoration: faction == null ? _darkThemeBoxDecoration(isDarkTheme) : _factionBoxDecoration(faction),
      ),
    );
  }

  BoxDecoration _darkThemeBoxDecoration(bool isDarkTheme) {
    return BoxDecoration(
          color: theme.defaultThemeColor(isDarkTheme),
          border: Border.all(
              width: 3.0, color: theme.oppositeThemeColor(isDarkTheme)));
  }

  _factionBoxDecoration(Factions faction) {
    return BoxDecoration(
          color: theme.defaultThemeColor(_isDarkTheme),
          border: Border.all(
              width: 3.0, color: theme.oppositeThemeColor(_isDarkTheme)));
  }

  Radio _optionRadio({bool isDarkTheme, Factions faction}) {
    return Radio(
        value: faction == null ? isDarkTheme : faction,
        groupValue: faction == null ? _isDarkTheme : _faction,
        onChanged: (value) {
          faction == null ? _setSelectedTheme(value) : _setSelectedFaction(faction);
        });
  }

  _setSelectedTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
      prefs.isDarkTheme = value;
      DynamicTheme.of(context)
          .setBrightness(value ? Brightness.dark : Brightness.light);
    });
  }

  _setSelectedFaction(Factions faction) {
    setState(() {
      _faction = faction;
      prefs.faction = faction;
    });
  }

  

  // _selectTheme()
  // {
  //   return Wrap(children: <Widget>[
  //       RadioListTile(
  //         value: false,
  //         title: Text("Light"),
  //         groupValue: _isDarkTheme,
  //         onChanged: (value){_setSelectedTheme(value);},
  //       ),
  //       RadioListTile(
  //         value: true,
  //         title: Text("Dark"),
  //         groupValue: _isDarkTheme,
  //         onChanged: (value){_setSelectedTheme(value);}),
  //   ],);
  // }

}
