import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/services.dart';
import 'package:humankind/src/enums/FactionsEnum.dart';
import 'package:flutter/material.dart';
import 'package:humankind/src/models/AvatarModel.dart';
import 'globals.dart' as globals;
export 'globals.dart';

final String appName = 'Humankind Virtue';
final String version = '1.1.0';
final bool allowAvatars = false;
final String leftTab = 'assets/tabs/leftTab.png';
final String rightTab = 'assets/tabs/rightTab.png';

String stringfiedFaction(Factions factEnum) {
  int factionNameIndex = 1;
  String stringedValue = factEnum.toString();
  return StringUtils.capitalize(stringedValue.split('.')[factionNameIndex]);
}

Color darkAndLightThemeColor(bool isDarkTheme) {
  return (isDarkTheme) ? Color.fromRGBO(100, 100, 100, 1.0) : Colors.white;
}

Color darkAndLightOppositeThemeColor(bool isDarkTheme) {
  return (isDarkTheme) ? Colors.white : Color.fromRGBO(30, 30, 30, 1.0);
}

Color factionColor(Factions faction) {
  Color color;
  switch (faction) {
    case Factions.ninguno:
      color = Colors.transparent;
      break;
    case Factions.green:
      color = Colors.green;
      break;
    case Factions.blue:
      color = Colors.blue;
      break;
    case Factions.yellow:
      color = Color.fromRGBO(180, 180, 60, 1.0);
      break;
    case Factions.red:
      color = Colors.red;
      break;
  }
  return color;
}

Color oppositefactionColor(Factions faction) {
  Color color;
  switch (faction) {
    case Factions.ninguno:
      color = Colors.transparent;
      break;
    case Factions.green:
      color = Colors.red;
      break;
    case Factions.blue:
      color = Colors.orange;
      break;
    case Factions.yellow:
      color = Colors.deepPurple;
      break;
    case Factions.red:
      color = Colors.green;
      break;
  }
  return color;
}

AssetImage factionImage(Factions faction) {
  AssetImage image;
  switch (faction) {
    case Factions.ninguno:
      image = null;
      break;
    case Factions.green:
      image = AssetImage("assets/factions/green.png");
      break;
    case Factions.blue:
      image = AssetImage("assets/factions/blue.png");
      break;
    case Factions.yellow:
      image = AssetImage("assets/factions/yellow.png");
      break;
    case Factions.red:
      image = AssetImage("assets/factions/red.png");
      break;
  }
  return image;
}

AssetImage cardImage(Factions faction) {
  AssetImage image;
  switch (faction) {
    case Factions.ninguno:
      image = AssetImage("assets/cards/normalCard.png");
      break;
    case Factions.green:
      image = AssetImage("assets/cards/greenCard.png");
      break;
    case Factions.blue:
      image = AssetImage("assets/cards/blueCard.png");
      break;
    case Factions.yellow:
      image = AssetImage("assets/cards/yellowCard.png");
      break;
    case Factions.red:
      image = AssetImage("assets/cards/redCard.png");
      break;
  }
  return image;
}

String speedValue(int value) {
  String text;

  switch (value) {
    case 300:
      text = "Muy rápido";
      break;
    case 600:
      text = "Rápido";
      break;
    case 900:
      text = "Normal";
      break;
    case 1200:
      text = "Lento";
      break;
    case 1500:
      text = "Muy lento";
      break;
  }

  return text;
}

Icon iconVirtueValue(String value, Color color) {
  IconData iconData;

  if (color == Colors.white) {
    color = Colors.black;
  }

  switch (value) {
    case "-2":
      iconData = Icons.exposure_neg_2;
      break;
    case "-1":
      iconData = Icons.exposure_neg_1;
      break;
    case "0":
      iconData = Icons.exposure_zero;
      break;
    case "1":
      iconData = Icons.exposure_plus_1;
      break;
    case "2":
      iconData = Icons.exposure_plus_2;
      break;
  }
  return Icon(iconData, color: color);
}

Color mainThemeColor(bool isDarkTheme, Factions faction) {
  if (faction == Factions.ninguno) {
    return darkAndLightThemeColor(isDarkTheme);
  } else {
    return factionColor(faction);
  }
}

Color oppositeThemeColor(bool isDarkTheme, Factions faction) {
  ////ESTE MÉTODO ESTÁ COMENTADO PARA FUNCIONALIDADES ACTUALES, PERO PODRÍA SER UTIL EN EL FUTURO.
  // if(faction == Factions.ninguno)
  // {
  //   return darkAndLightOppositeThemeColor(isDarkTheme);
  // }
  // else
  // {
  //   return oppositefactionColor(faction);
  // }
  return darkAndLightOppositeThemeColor(isDarkTheme);
}

loadAvatars() async {
  final data = await rootBundle.loadString('data/avatars.json');
  final dataMap = json.decode(data);
  int counter = 0;
  Map<int, Avatar> mapInformation = new Map<int, Avatar>();

  for (var item in dataMap) {
    Avatar avatar = Avatar.fromJson(item);
    mapInformation.putIfAbsent(counter, () => avatar);
    counter++;
  }
  globals.avatarsMap = mapInformation;
}

String storeString(String item)
{
  String value;
  switch (item) {
    case "Dark":
      value = "dark.theme";
      break;
    case "Green":
      value = "green.faction";
      break;
    case "Blue":
      value = "blue.faction";
      break;
    case "Yellow":
      value = "yellow.faction";
      break;
    case "Red":
      value = "red.faction";
      break;
  }

  return value;
}