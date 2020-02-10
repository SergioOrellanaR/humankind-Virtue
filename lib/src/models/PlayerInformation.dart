import 'package:humankind/src/config/UserConfig.dart';

class PlayerInformation {
  int structure;
  int will;
  int savedWill;
  int playerNumber;

  PlayerInformation.playerOne({UserConfig userConfig})
  {
    structure = userConfig.defaultStructure;
    will = userConfig.defaultWill;
    savedWill = userConfig.defaultWill;
    playerNumber = 1;
  }

  PlayerInformation.playerTwo()
  {
    structure = 15;
    will = 4;
    savedWill = 4;
    playerNumber = 2;
  }
  
}