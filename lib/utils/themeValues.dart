import 'package:flutter/material.dart';

Color defaultThemeColor(bool isDarkTheme)
{
  return (isDarkTheme) ? Color.fromRGBO(100, 100, 100, 1.0) : Colors.white;
}

Color oppositeThemeColor(bool isDarkTheme)
{
  return (isDarkTheme) ? Colors.white : Color.fromRGBO(100, 100, 100, 1.0);
}