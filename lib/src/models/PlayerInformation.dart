import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/controllers/VirtuesController.dart';

class PlayerInformation {
  int structure;
  int will;
  int savedWill;
  int playerNumber;
  VirtuesController virtuesController;

  PlayerInformation.playerOne({UserConfig userConfig}) {
    structure = userConfig.defaultStructure;
    will = userConfig.defaultWill;
    savedWill = userConfig.defaultWill;
    playerNumber = 1;
    virtuesController = new VirtuesController();
  }

  PlayerInformation.playerTwo() {
    structure = 15;
    will = 4;
    savedWill = 4;
    playerNumber = 2;
    virtuesController = new VirtuesController();
  }
}
