import 'package:flutter/material.dart';
import 'package:humankind/src/config/UserConfig.dart';

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