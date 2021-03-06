import 'package:humankind/src/models/AbstractVirtue.dart';

class VirtuesController {
  List<AbstractVirtue> factions;
  List<AbstractVirtue> virtuesValues;

  VirtuesController() {
    _initializeFactions();
    _initializeVirtuesValues();
    shuffleAll();
  }

  _initializeFactions() {
    factions = new List();
    Factions.values.forEach((fact) {
      Faction virtue = new Faction(faction: fact);
      factions.add(virtue);
    });
  }

  _initializeVirtuesValues() {
    virtuesValues = new List();

    for (int i = -2; i <= 2; i++) {
      Virtue virtue = new Virtue(value: i.toString());
      virtuesValues.add(virtue);
    }
  }

  shuffleFactions() {
    _initializeFactions();
    factions.shuffle();
  }

  shuffleVirtues() {
    _initializeVirtuesValues();
    virtuesValues.shuffle();
  }

  shuffleAll() {
    shuffleFactions();
    shuffleVirtues();
  }
}
