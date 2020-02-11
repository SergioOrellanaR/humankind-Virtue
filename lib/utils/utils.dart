import 'package:basic_utils/basic_utils.dart';
import 'package:humankind/src/enums/FactionsEnum.dart';
import 'package:flutter/material.dart';


final String appName = 'Humankind Virtue';
final String version = '1.0.0';
final String leftTab = 'assets/tabs/leftTab.png';
final String rightTab ='assets/tabs/rightTab.png';

stringfiedFaction(Factions factEnum)
  {
    int factionNameIndex = 1;
    String stringedValue = factEnum.toString();
    return StringUtils.capitalize(stringedValue.split('.')[factionNameIndex]);
  }

Color defaultThemeColor(bool isDarkTheme)
{
  return (isDarkTheme) ? Color.fromRGBO(100, 100, 100, 1.0) : Colors.white;
}

Color oppositeThemeColor(bool isDarkTheme)
{
  return (isDarkTheme) ? Colors.white : Color.fromRGBO(100, 100, 100, 1.0);
}

Color factionColor(Factions faction)
{
  Color color;
  switch(faction)
  {
    case Factions.ninguno:
      color = Colors.transparent;
      break;
    case Factions.abismales:
      color = Colors.green;
      break;
    case Factions.quimera:
      color = Colors.blue;
      break;
    case Factions.acracia:
      color = Colors.yellow;
      break;
    case Factions.corporacion:
      color = Colors.red;
      break;
  }
  return color;
}

AssetImage factionImage(Factions faction)
{
  AssetImage image;
  switch(faction)
  {
    case Factions.ninguno:
      image = AssetImage("");
      break;
    case Factions.abismales:
      image = AssetImage("");
      break;
    case Factions.quimera:
      image = AssetImage("");
      break;
    case Factions.acracia:
      image = AssetImage("");
      break;
    case Factions.corporacion:
      image = AssetImage("");
      break;
  }
  return image;
}