import 'package:humankind/src/enums/FactionsEnum.dart';
import 'package:shared_preferences/shared_preferences.dart';
export 'package:humankind/src/enums/FactionsEnum.dart';

class UserConfig {
  static final UserConfig _instance = new UserConfig._private();

  factory UserConfig() {
    return _instance;
  }

  UserConfig._private();

  SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get playerOne {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getString("playerOne") ?? "Yo";
  }

  set playerOne(String value) {
    _prefs.setString("playerOne", value);
  }

  get playerTwo {
    return _prefs.getString("playerTwo") ?? "Rival";
  }

  set playerTwo(String value) {
    _prefs.setString("playerTwo", value);
  }

  get isDarkTheme {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getBool("isDarkTheme") ?? false;
  }

  set isDarkTheme(bool value) {
    _prefs.setBool("isDarkTheme", value);
  }

  get defaultWill {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getInt("defaultWill") ?? 6;
  }

  set defaultWill(int value) {
    _prefs.setInt("defaultWill", value);
  }

  get defaultStructure {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getInt("defaultStructure") ?? 15;
  }

  set defaultStructure(int value) {
    _prefs.setInt("defaultStructure", value);
  }

  get faction {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getInt("faction") ?? Factions.ninguno.index;
  }

  set faction(Factions value) {
    _prefs.setInt("faction", value.index);
  }

  get animationSpeed {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getInt("animationSpeed") ?? 1600;
  }

  set animationSpeed(int value) {
    _prefs.setInt("animationSpeed", value);
  }

  get playerOneAvatar {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getInt("playerOneAvatar") ?? 0;
  }

  set playerOneAvatar(int value) {
    _prefs.setInt("playerOneAvatar", value);
  }

  get playerTwoAvatar {
    //Doble signo de interrogación para preguntar si es NULL
    return _prefs.getInt("playerTwoAvatar") ?? 1;
  }

  set playerTwoAvatar(int value) {
    _prefs.setInt("playerTwoAvatar", value);
  }
}
