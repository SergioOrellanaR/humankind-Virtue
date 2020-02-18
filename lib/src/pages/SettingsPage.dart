import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:humankind/src/config/UserConfig.dart';
import 'package:humankind/src/models/AvatarModel.dart';
import 'package:humankind/utils/utils.dart' as utils;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _unlockedItems;
  List<String> _lockedItems = [
    "dark.theme",
    "green.faction",
    "blue.faction",
    "yellow.faction",
    "red.faction"
  ];
  List<String> _pendingItems = new List();

  String _playerOne;
  String _playerTwo;
  int _defaultWill;
  int _defaultStructure;
  int _animationSpeed;
  bool _isDarkTheme;
  Factions _faction;
  int _playerOneAvatar;
  int _playerTwoAvatar;
  TextEditingController _textEditingController;
  Size _screenSize;
  String _errorMessage;
  final prefs = new UserConfig();

  @override
  void initState() {
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });
    super.initState();
    _loadPlayerData();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _loadPlayerData() {
    _playerOne = prefs.playerOne;
    _playerTwo = prefs.playerTwo;
    _defaultWill = prefs.defaultWill;
    _defaultStructure = prefs.defaultStructure;
    _animationSpeed = prefs.animationSpeed * -1;
    _isDarkTheme = prefs.isDarkTheme;
    _faction = Factions.values[prefs.faction];
    _playerOneAvatar = prefs.playerOneAvatar;
    _playerTwoAvatar = prefs.playerTwoAvatar;
    _unlockedItems = null;
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.error) {
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        if (purchaseDetails.pendingCompletePurchase) {
          _unlockItem(purchaseDetails.productID);
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.pending) 
      {
        _pendingItems.add(purchaseDetails.productID);
      }
    });
  }

  Future<bool> _storeIsAvailable() async {
    return await InAppPurchaseConnection.instance.isAvailable();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    int _initialTabIndex = ModalRoute.of(context).settings.arguments ?? 0;
    return _tabController(_initialTabIndex);
  }

  DefaultTabController _tabController(int _initialTabIndex) {
    return DefaultTabController(
      length: utils.allowAvatars ? 3 : 2,
      child: _mainScaffold(),
      initialIndex: _initialTabIndex,
    );
  }

  Scaffold _mainScaffold() {
    return Scaffold(appBar: _appBar(), body: _tabContent());
  }

  AppBar _appBar() {
    if (prefs.faction != Factions.ninguno.index) {
      return AppBar(
        title: Text("Ajustes"),
        centerTitle: true,
        backgroundColor: utils.mainThemeColor(
            prefs.isDarkTheme, Factions.values[prefs.faction]),
        bottom: _tabBarInformation(),
      );
    } else {
      return AppBar(
          title: Text("Ajustes"),
          centerTitle: true,
          bottom: _tabBarInformation());
    }
  }

  TabBar _tabBarInformation() {
    if (utils.allowAvatars) {
      return TabBar(tabs: [
        Tab(icon: Icon(Icons.settings)),
        Tab(icon: Icon(Icons.settings_system_daydream)),
        Tab(icon: Icon(Icons.face)),
      ], indicatorColor: Colors.white);
    } else {
      return TabBar(tabs: [
        Tab(icon: Icon(Icons.settings)),
        Tab(icon: Icon(Icons.settings_system_daydream))
      ], indicatorColor: Colors.white);
    }
  }

  TabBarView _tabContent() {
    if (utils.allowAvatars) {
      return TabBarView(
        children: <Widget>[_settingsTab(), _themeFutureBuilder(), _avatarTab()],
      );
    } else {
      return TabBarView(
        children: <Widget>[_settingsTab(), _themeFutureBuilder()],
      );
    }
  }

  ListView _settingsTab() {
    return ListView(
      children: <Widget>[
        _subTitle("Jugadores"),
        _playerInformation(playerNumber: 1),
        _playerInformation(playerNumber: 2),
        _subTitle("Valores"),
        _willOrStructureValue(isWill: false),
        _willOrStructureValue(isWill: true),
        _subTitle("Velocidad de Animación"),
        _selectAnimationSpeed(),
        Divider(),
        _footer()
      ],
    );
  }

  ListView _themeTab() {
    return ListView(
      children: <Widget>[
        _subTitle("Tema"),
        _selectTheme(),
        _subTitle("Facción"),
        _selectFaction(),
        Divider(),
        _footer()
      ],
    );
  }

  ListView _avatarTab() {
    return ListView(
      children: <Widget>[
        _subTitle("Avatar"),
        _explainAvatarSelect(),
        _selectAvatar(),
        Divider(),
        _footer()
      ],
    );
  }

  Column _subTitle(String value) {
    return Column(
      children: <Widget>[
        Divider(),
        Container(
          child: Text(
            value,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Divider()
      ],
    );
  }

  Container _playerInformation({@required int playerNumber}) {
    String playerString;

    if (playerNumber == 1) {
      playerString = _playerOne;
    } else if (playerNumber == 2) {
      playerString = _playerTwo;
    }

    Color defaultColor = utils.darkAndLightOppositeThemeColor(_isDarkTheme);
    TextStyle defaultStyle = TextStyle(color: defaultColor);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _textEditingController,
        maxLines: 1,
        initialValue: playerString,
        cursorColor: defaultColor,
        style: defaultStyle,
        inputFormatters: [LengthLimitingTextInputFormatter(20)],
        decoration: InputDecoration(
          labelText: "Jugador $playerNumber",
          labelStyle: defaultStyle,
          helperText: "Nombre de jugador $playerNumber",
          helperStyle: defaultStyle,
          hoverColor: defaultColor,
        ),
        maxLengthEnforced: true,
        onChanged: (value) {
          setState(() {
            if (playerNumber == 1) {
              _playerOne = value;
              prefs.playerOne = value;
            } else if (playerNumber == 2) {
              _playerTwo = value;
              prefs.playerTwo = value;
            }
          });
        },
      ),
    );
  }

  Container _willOrStructureValue({@required bool isWill}) {
    String value = isWill ? "Voluntad" : "Estructura";
    Color defaultColor = utils.darkAndLightOppositeThemeColor(_isDarkTheme);
    TextStyle defaultStyle = TextStyle(color: defaultColor);
    String defaultValue =
        (isWill ? _defaultWill : _defaultStructure).toString();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: _textEditingController,
        maxLines: 1,
        initialValue: defaultValue,
        keyboardType: TextInputType.number,
        cursorColor: defaultColor,
        style: defaultStyle,
        inputFormatters: [
          LengthLimitingTextInputFormatter(2),
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            labelText: value,
            labelStyle: defaultStyle,
            helperText: "Valor de $value por defecto",
            helperStyle: defaultStyle,
            hoverColor: defaultColor,
            suffixIcon: Icon(
              Icons.lens,
              color: isWill ? Colors.blue : Colors.red,
            )),
        maxLengthEnforced: true,
        onChanged: (value) {
          setState(() {
            if (isWill) {
              _defaultWill = int.parse(value);
              prefs.defaultWill = int.parse(value);
            } else {
              _defaultStructure = int.parse(value);
              prefs.defaultStructure = int.parse(value);
            }
          });
        },
      ),
    );
  }

  Column _selectAnimationSpeed() {
    return Column(
      children: <Widget>[
        Text(
          "Este cambio se producirá al iniciar un nuevo juego.",
          style: TextStyle(
              fontSize: 13.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300),
        ),
        Slider.adaptive(
          min: -1500,
          max: -300,
          value: _animationSpeed.toDouble(),
          divisions: 4,
          onChanged: ((value) => setState(() {
                _animationSpeed = value.toInt();
                prefs.animationSpeed = (_animationSpeed * -1);
              })),
          label: utils.speedValue(prefs.animationSpeed),
          //divisions: 10,
        ),
      ],
    );
  }

  Row _selectTheme() {
    return Row(children: <Widget>[
      _containerTheme(isDarkTheme: false),
      _containerTheme(isDarkTheme: true)
    ], mainAxisAlignment: MainAxisAlignment.spaceEvenly);
  }

  Wrap _selectFaction() {
    return Wrap(
        children: <Widget>[
          _containerTheme(faction: Factions.ninguno),
          _containerTheme(faction: Factions.green),
          _containerTheme(faction: Factions.blue),
          _containerTheme(faction: Factions.yellow),
          _containerTheme(faction: Factions.red)
        ],
        direction: Axis.horizontal,
        spacing: _screenSize.width * 0.15,
        runSpacing: _screenSize.height * 0.05,
        alignment: WrapAlignment.spaceEvenly);
  }

  Column _containerTheme({bool isDarkTheme, Factions faction}) {
    String optionValue;
    bool itemIsAvailable = true;

    if (faction == null) {
      optionValue = isDarkTheme ? "Dark" : "Light";
      if (isDarkTheme && _lockedItems.contains("dark.theme")) {
        itemIsAvailable = false;
      }
    } else {
      optionValue = utils.stringfiedFaction(faction);
      String factionStoreIdCode = "${optionValue.toLowerCase()}.faction";
      if (faction != Factions.ninguno &&
          _lockedItems.contains(factionStoreIdCode)) {
        itemIsAvailable = false;
      }
    }

    return Column(children: <Widget>[
      _optionContainer(
          isDarkTheme: isDarkTheme,
          faction: faction,
          itemIsAvailable: itemIsAvailable),
      _optionRadio(
          isDarkTheme: isDarkTheme,
          faction: faction,
          itemIsAvailable: itemIsAvailable),
      Text(optionValue)
    ]);
  }

  GestureDetector _optionContainer(
      {bool isDarkTheme, Factions faction, bool itemIsAvailable}) {
    return GestureDetector(
      onTap: () async {
        if (itemIsAvailable) {
          faction == null
              ? _setSelectedTheme(isDarkTheme)
              : _setSelectedFaction(faction);
        } else {
          await _buyItem(isDarkTheme, faction);
        }
      },
      child: Stack(
        children: <Widget>[
          _optionContainerInformation(faction, isDarkTheme),
          _blurredContainerSetter(faction, isDarkTheme, itemIsAvailable)
        ],
      ),
    );
  }

  _blurredContainerSetter(
      Factions faction, bool isDarkTheme, bool itemIsAvailable) {
    String price;
    String pending = "";
    String pendingStoreIdCode;

    if (!itemIsAvailable) {
      if (faction == null) {
        pendingStoreIdCode = "dark.theme";
        price = "1000";
      } else {
        String optionValue = utils.stringfiedFaction(faction);
        pendingStoreIdCode = "${optionValue.toLowerCase()}.faction";
        price = "2000";
      }
    }

    if (pendingStoreIdCode != null &&
        _pendingItems.contains(pendingStoreIdCode)) {
      pending = "Pendiente: ";
    }

    return price == null ? SizedBox() : _blurredContainer(pending, price);
  }

  Container _blurredContainer(String pending, String price) {
    return Container(
      height: _screenSize.height * 0.15,
      width: _screenSize.height * 0.15,
      alignment: Alignment.center,
      child: Text(
        "$pending" + r"$" + "$price",
        style: TextStyle(
            fontWeight: FontWeight.bold, backgroundColor: Colors.white24),
        textAlign: TextAlign.center,
      ),
      decoration: BoxDecoration(
        color: Colors.white70,
      ),
    );
  }

  Container _optionContainerInformation(Factions faction, bool isDarkTheme) {
    return Container(
      height: _screenSize.height * 0.15,
      width: _screenSize.height * 0.15,
      decoration: faction == null
          ? _darkThemeBoxDecoration(isDarkTheme)
          : _factionBoxDecoration(faction),
    );
  }

  BoxDecoration _darkThemeBoxDecoration(bool isDarkTheme) {
    return BoxDecoration(
        color: utils.darkAndLightThemeColor(isDarkTheme),
        border: Border.all(
            width: 3.0,
            color: utils.darkAndLightOppositeThemeColor(isDarkTheme)));
  }

  BoxDecoration _factionBoxDecoration(Factions faction) {
    if (faction != Factions.ninguno) {
      return BoxDecoration(
          color: utils.darkAndLightThemeColor(_isDarkTheme),
          image: DecorationImage(
              image: utils.factionImage(faction), fit: BoxFit.contain),
          border: Border.all(
              width: 3.0,
              color: utils.darkAndLightOppositeThemeColor(_isDarkTheme)));
    } else {
      return _darkThemeBoxDecoration(_isDarkTheme);
    }
  }

  Radio _optionRadio(
      {bool isDarkTheme, Factions faction, bool itemIsAvailable}) {
    if (itemIsAvailable) {
      return Radio(
          value: faction == null ? isDarkTheme : faction,
          groupValue: faction == null ? _isDarkTheme : _faction,
          onChanged: (value) {
            faction == null
                ? _setSelectedTheme(value)
                : _setSelectedFaction(faction);
          });
    } else {
      return Radio(value: false, groupValue: null, onChanged: null);
    }
  }

  void _setSelectedTheme(bool value) {
    setState(() {
      _isDarkTheme = value;
      prefs.isDarkTheme = value;
      DynamicTheme.of(context)
          .setBrightness(value ? Brightness.dark : Brightness.light);
    });
  }

  void _setSelectedFaction(Factions faction) {
    setState(() {
      _faction = faction;
      prefs.faction = faction;
    });
  }

  Wrap _explainAvatarSelect() {
    return Wrap(
      children: <Widget>[
        _explanatoryRadio(isPlayerOne: true),
        _explanatoryRadio(isPlayerOne: false)
      ],
    );
  }

  Wrap _selectAvatar() {
    return Wrap(
        children: _avatarList(),
        direction: Axis.horizontal,
        spacing: 0,
        runSpacing: _screenSize.height * 0.05,
        alignment: WrapAlignment.spaceEvenly);
  }

  List<Widget> _avatarList() {
    List<Widget> widgetList = new List<Widget>();

    for (int i = 0; i < utils.avatarsMap.length; i++) {
      widgetList.add(_avatarContainer(avatar: utils.avatarsMap[i], index: i));
    }

    return widgetList;
  }

  Widget _avatarContainer({Avatar avatar, int index}) {
    return Container(
        width: _screenSize.width * 0.3,
        child: Column(children: <Widget>[
          _avatarOptionContainer(avatar: avatar),
          _illustratorText(avatar.illustrator),
          _avatarRadioButtons(index),
          _avatarName(avatar)
        ]));
  }

  Text _avatarName(Avatar avatar) {
    return Text(
      avatar.name,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.0),
    );
  }

  Row _avatarRadioButtons(int index) {
    return Row(
      children: <Widget>[
        _radioAvatar(isPlayerOne: true, index: index),
        _radioAvatar(isPlayerOne: false, index: index),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Text _illustratorText(String illustratorName) {
    TextStyle style = TextStyle(
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        fontSize: 9.6);
    return Text(
      "Ilustrador: $illustratorName",
      style: style,
    );
  }

  Container _avatarOptionContainer({Avatar avatar}) {
    return Container(
        height: _screenSize.height * 0.15,
        width: _screenSize.height * 0.15,
        decoration: _avatarBoxDecoration(avatar: avatar));
  }

  BoxDecoration _avatarBoxDecoration({Avatar avatar}) {
    AssetImage avatarImage = AssetImage(avatar.source);
    return BoxDecoration(
        color: utils.darkAndLightThemeColor(_isDarkTheme),
        image: DecorationImage(image: avatarImage, fit: BoxFit.contain),
        shape: BoxShape.circle,
        border:
            Border.all(width: 4.0, color: utils.factionColor(avatar.faction)));
  }

  Radio _radioAvatar({bool isPlayerOne, index}) {
    Color color = isPlayerOne ? Colors.blue : Colors.red;

    return Radio(
        value: index,
        groupValue: isPlayerOne ? _playerOneAvatar : _playerTwoAvatar,
        activeColor: color,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (value) {
          _setSelectedAvatarOption(value: value, isPlayerOne: isPlayerOne);
        });
  }

  RadioListTile _explanatoryRadio({bool isPlayerOne}) {
    Color color = isPlayerOne ? Colors.blue : Colors.red;
    return RadioListTile(
      title: Text("Color de Jugador ${isPlayerOne ? 1 : 2}"),
      subtitle: Text("Botón a la ${isPlayerOne ? "izquierda" : "derecha"}"),
      value: 1,
      groupValue: 1,
      onChanged: (val) {},
      activeColor: color,
      selected: true,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  void _setSelectedAvatarOption({int value, bool isPlayerOne}) {
    setState(() {
      if (isPlayerOne) {
        _playerOneAvatar = value;
        prefs.playerOneAvatar = value;
      } else {
        _playerTwoAvatar = value;
        prefs.playerTwoAvatar = value;
      }
    });
  }

  // Widget _saveButton(BuildContext context) {
  //   return Center(
  //     child: RaisedButton(
  //         color: utils.mainThemeColor(
  //             prefs.isDarkTheme, Factions.values[prefs.faction]),
  //         child: Padding(
  //           //EdgeInsets.symetric para distintos valores UwU
  //           padding: EdgeInsets.all(12.0),
  //           child: Text(
  //             "Guardar",
  //             style: TextStyle(fontSize: 18.0),
  //           ),
  //         ),
  //         onPressed: () {
  //           Navigator.pop(context);
  //         },
  //         shape: StadiumBorder()),
  //   );
  // }

  Column _footer() {
    return Column(
      children: <Widget>[
        Divider(),
        Container(
            child: Row(children: <Widget>[
          Text(
            "Developed by: Sergio Orellana Rey - V.${utils.version}",
            style: TextStyle(fontSize: 12.5),
          ),
          Expanded(child: SizedBox()),
          Image(
            image: AssetImage("assets/OrellanaLogo.png"),
            fit: BoxFit.scaleDown,
            width: 50,
            height: 50,
          ),
          SizedBox(
            width: 10,
          )
        ])),
      ],
    );
  }

  _buyItem(bool isDarkTheme, Factions faction) async {
    String itemId;
    if (faction == null) {
      itemId = "dark.theme";
    } else {
      String factionString = utils.stringfiedFaction(faction);
      itemId = "${factionString.toLowerCase()}.faction";
    }
    _startItemTransaction(itemId);
  }

  Widget _themeFutureBuilder() {
    return FutureBuilder(
      future: _loadProductsForSale(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (_errorMessage != null) {
          return _errorBody(_errorMessage);
        } else {
          return _themeTab();
        }
      },
    );
  }

  _loadPreviousPurchases() async {
    _unlockedItems = new List();
    _pendingItems = new List();

    final QueryPurchaseDetailsResponse response =
        await InAppPurchaseConnection.instance.queryPastPurchases();

    if (response.error != null) {
      _errorMessage = "Error al cargar las compras previas";
    }

    for (PurchaseDetails purchase in response.pastPurchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _unlockedItems.add(purchase.productID);
      } else if (purchase.status == PurchaseStatus.pending) {
          _pendingItems.add(purchase.productID);
        setState(() {
        });
        
      }
    }

    // _verifyPurchase(
    //     purchase); // Verify the purchase following the best practices for each storefront.
    // _deliverPurchase(
    //     purchase); // Deliver the purchase to the user in your app.

    // if (Platform.isIOS) {
    //   // Mark that you've delivered the purchase. Only the App Store requires
    //   // this final confirmation.
    //   InAppPurchaseConnection.instance.completePurchase(purchase);
    // }
  }

  _loadProductsForSale() async {
    List<ProductDetails> products = new List();

    if (await _storeIsAvailable()) {
      await _loadPreviousPurchases();

      List<String> itemsList = _lockedItems;
      _lockedItems = new List();

      for (String item in itemsList) {
        if (!_unlockedItems.contains(item)) {
          _lockedItems.add(item);
        }
      }

      Set<String> _productsIds = _lockedItems.toSet();

      final ProductDetailsResponse response = await InAppPurchaseConnection
          .instance
          .queryProductDetails(_productsIds);

      if (response.notFoundIDs.isNotEmpty) {
        _errorMessage = "No se ha podido acceder a los productos en la tienda";
      }

      products = response.productDetails;
    } else {
      _errorMessage =
          "No ha sido posible acceder a la tienda, verifique su conexión y que exista una cuenta vinculada a su dispositivo";
    }

    return products;
  }

  _errorBody(String errorText) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.fromLTRB(60.0, 0, 60.0, 60.0),
        children: <Widget>[
          Column(children: <Widget>[
            Icon(Icons.sentiment_dissatisfied, size: 40),
            Text(errorText, textAlign: TextAlign.center)
          ])
        ],
      ),
    );
  }

  _startItemTransaction(String requestedId) async {
    List<ProductDetails> products = await _loadProductsForSale();

    if (products.isNotEmpty) {
      ProductDetails productDetails =
          products.firstWhere((prod) => prod.id == requestedId);

      if (productDetails != null) {
        PurchaseParam purchaseParam =
            PurchaseParam(productDetails: productDetails);
        await InAppPurchaseConnection.instance
            .buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }

  void _unlockItem(String productID) {
    setState(() {
      _lockedItems.removeWhere((value) => value == productID);
      _unlockedItems.add(productID);
    });
  }
}
