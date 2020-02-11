import 'package:humankind/src/models/AbstractVirtue.dart';
import 'package:humankind/src/enums/FactionsEnum.dart';
export 'package:humankind/src/enums/FactionsEnum.dart';

class Faction extends AbstractVirtue{
  Factions faction;

  Faction({this.faction}):super()
  {
    value = stringfiedFaction(this.faction);
  }

  stringfiedFaction(Factions factEnum)
  {
    int factionNameIndex = 1;
    String stringedValue = factEnum.toString();
    stringedValue = stringedValue.split('.')[factionNameIndex];
    return stringedValue == 'ninguno' ? "" : stringedValue;
  }

  @override
  String toString() {
    return stringfiedFaction(faction);
  }
}

