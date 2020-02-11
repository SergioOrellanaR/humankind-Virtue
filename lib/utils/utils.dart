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

Color darkAndLightThemeColor(bool isDarkTheme)
{
  return (isDarkTheme) ? Color.fromRGBO(100, 100, 100, 1.0) : Colors.white;
}

Color darkAndLightOppositeThemeColor(bool isDarkTheme)
{
  return (isDarkTheme) ? Colors.white : Color.fromRGBO(50, 50, 50, 1.0);
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
      color = Color.fromRGBO(180, 180, 60, 1.0);
      break;
    case Factions.corporacion:
      color = Colors.red;
      break;
  }
  return color;
}

Color oppositefactionColor(Factions faction)
{
  Color color;
  switch(faction)
  {
    case Factions.ninguno:
      color = Colors.transparent;
      break;
    case Factions.abismales:
      color = Colors.red;
      break;
    case Factions.quimera:
      color = Colors.orange;
      break;
    case Factions.acracia:
      color = Colors.deepPurple;
      break;
    case Factions.corporacion:
      color = Colors.green;
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
      image = null;
      break;
    case Factions.abismales:
      image = AssetImage("assets/factions/Abismales.png");
      break;
    case Factions.quimera:
      image = AssetImage("assets/factions/Quimera.png");
      break;
    case Factions.acracia:
      image = AssetImage("assets/factions/Acracia.png");
      break;
    case Factions.corporacion:
      image = AssetImage("assets/factions/Corporacion.png");
      break;
  }
  return image;
}

String speedValue(int value)
{
  String text;

  switch(value)
  {
    case 400:
      text = "Muy rápido";
      break;
    case 800:
      text = "Rápido";
      break;
    case 1200:
      text = "Normal";
      break;
    case 1600:
      text = "Lento";
      break;
    case 2000:
      text = "Muy lento";
      break;
  }

  return text;
}

Color mainThemeColor(bool isDarkTheme, Factions faction)
{
  if(faction == Factions.ninguno)
  {
    return darkAndLightThemeColor(isDarkTheme);
  }
  else
  {
    return factionColor(faction);
  }
}

Color oppositeThemeColor(bool isDarkTheme, Factions faction)
{
  if(faction == Factions.ninguno)
  {
    return darkAndLightOppositeThemeColor(isDarkTheme);
  }
  else
  {
    return darkAndLightOppositeThemeColor(isDarkTheme);
    //return factionColor(faction);
  }
}