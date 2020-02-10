import 'package:humankind/src/models/AbstractVirtue.dart';
import 'package:humankind/src/enums/FactionsEnum.dart';
export 'package:humankind/src/enums/FactionsEnum.dart';

class Faction extends AbstractVirtue{
  Factions faction;
  //TODO: Agregar source de imagen.
  String imageSource;

  Faction({this.faction}):super()
  {
    value = stringfiedFaction(this.faction);
  }

  stringfiedFaction(Factions factEnum)
  {
    int factionNameIndex = 1;
    String stringedValue = factEnum.toString();
    return stringedValue.split('.')[factionNameIndex];
  }

  @override
  String toString() {
    return stringfiedFaction(faction);
  }
}

