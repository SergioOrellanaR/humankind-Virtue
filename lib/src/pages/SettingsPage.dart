import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humankind/src/config/UserConfig.dart';
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
  int _animationSpeed;
  bool _isDarkTheme;
  Factions _faction;
  bool _isSelected = false;

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
    _animationSpeed = prefs.animationSpeed * -1;
    _isDarkTheme = prefs.isDarkTheme;
    _faction = Factions.values[prefs.faction];
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(appBar: _appBar(), body: _body(context)));
  }

  AppBar _appBar() {
    if (prefs.faction != Factions.ninguno.index) {
      return AppBar(
        title: Text("Ajustes"),
        backgroundColor: utils.mainThemeColor(
            prefs.isDarkTheme, Factions.values[prefs.faction]),
      );
    } else {
      return AppBar(title: Text("Ajustes"));
    }
  }

  ListView _body(BuildContext context) {
    return ListView(
      children: <Widget>[
        _subTitle("Jugadores"),
        _playerInformation(playerNumber: 1),
        _playerInformation(playerNumber: 2),
        _subTitle("Valores"),
        _willOrStructureValue(isWill: false),
        _willOrStructureValue(isWill: true),
        _subTitle("Velocidad de Animación"),
        _selectAnimationSpeed(),
        _subTitle("Tema"),
        _selectTheme(),
        _subTitle("Facción"),
        _selectFaction(),
        Divider(),
        _saveButton(context),
        _footer()
      ],
    );
  }

  _subTitle(String value) {
    return Column(
      children: <Widget>[
        Divider(),
        Container(
          child: Text(
            value,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Divider()
      ],
    );
  }

  Container _playerInformation({@required int playerNumber}) {
    String playerString;

    if (playerNumber == 1) {
      playerString = _playerOne;
    } else if (playerNumber == 2) {
      playerString = _playerTwo;
    }

    Color defaultColor = utils.darkAndLightOppositeThemeColor(_isDarkTheme);
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
    Color defaultColor = utils.darkAndLightOppositeThemeColor(_isDarkTheme);
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
    return Wrap(
        children: <Widget>[
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
        decoration: faction == null
            ? _darkThemeBoxDecoration(isDarkTheme)
            : _factionBoxDecoration(faction),
      ),
    );
  }

  BoxDecoration _darkThemeBoxDecoration(bool isDarkTheme) {
    return BoxDecoration(
        color: utils.darkAndLightThemeColor(isDarkTheme),
        border: Border.all(
            width: 3.0,
            color: utils.darkAndLightOppositeThemeColor(isDarkTheme)));
  }

  BoxDecoration _factionBoxDecoration(Factions faction) {
    if (faction != Factions.ninguno) {
      return BoxDecoration(
          color: utils.darkAndLightThemeColor(_isDarkTheme),
          image: DecorationImage(
              image: utils.factionImage(faction), fit: BoxFit.contain),
          border: Border.all(
              width: 3.0,
              color: utils.darkAndLightOppositeThemeColor(_isDarkTheme)));
    } else {
      return _darkThemeBoxDecoration(_isDarkTheme);
    }
  }

  Radio _optionRadio({bool isDarkTheme, Factions faction}) {
    return Radio(
        value: faction == null ? isDarkTheme : faction,
        groupValue: faction == null ? _isDarkTheme : _faction,
        onChanged: (value) {
          faction == null
              ? _setSelectedTheme(value)
              : _setSelectedFaction(faction);
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

  _footer() {
    return Column(
      children: <Widget>[
        Divider(),
        Container(
            child: Row(children: <Widget>[
          Text(
            "Developed by: Sergio Orellana Rey - V.A${utils.version}",
            style: TextStyle(fontSize: 12.5),
          ),
          Expanded(child: SizedBox()),
          Image(
            image: AssetImage("assets/OrellanaLogo.png"),
            fit: BoxFit.scaleDown,
            width: 50,
            height: 50,
          ),
          SizedBox(
            width: 10,
          )
        ])),
      ],
    );
  }

  _selectAnimationSpeed() {
    return Column(
      children: <Widget>[
        Text(
          "Este cambio se producirá al iniciar un nuevo juego.",
          style: TextStyle(
              fontSize: 13.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300),
        ),
        Slider.adaptive(
          min: -2000,
          max: -400,
          value: _animationSpeed.toDouble(),
          divisions: 4,
          onChanged: ((value) => setState(() {
                _animationSpeed = value.toInt();
                prefs.animationSpeed = (_animationSpeed * -1);
              })),
          label: utils.speedValue(prefs.animationSpeed),
          //divisions: 10,
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return Center(
      child: RaisedButton(
          color: utils.mainThemeColor(
              prefs.isDarkTheme, Factions.values[prefs.faction]),
          child: Padding(
            //EdgeInsets.symetric para distintos valores UwU
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Guardar",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          shape: StadiumBorder()),
    );
  }
}
