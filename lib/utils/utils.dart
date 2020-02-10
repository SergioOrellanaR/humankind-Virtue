import 'package:basic_utils/basic_utils.dart';
import 'package:humankind/src/enums/FactionsEnum.dart';


final String appName = 'Humankind Virtue';
final String version = '1.0.0';

stringfiedFaction(Factions factEnum)
  {
    int factionNameIndex = 1;
    String stringedValue = factEnum.toString();
    return StringUtils.capitalize(stringedValue.split('.')[factionNameIndex]);
  }