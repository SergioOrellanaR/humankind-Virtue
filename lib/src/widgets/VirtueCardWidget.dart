import 'package:flutter/material.dart';

class VirtueCard extends StatefulWidget {
  @override
  _VirtueCardState createState() => _VirtueCardState();
}

class _VirtueCardState extends State<VirtueCard> {
  Size _screenSize;
  final String _cardImageUrl = 'assets/card1.png';

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    return Center(child: _virtueTable());
  }

  _virtueTable() {
    return Row(
      children: <Widget>[
        Wrap(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: _screenSize.height * 0.07,
                  ),
                  _virtueLineAndSpace("abismales", "-1"),
                  _virtueLineAndSpace("", "2"),
                  _virtueLineAndSpace("acracia", "0"),
                  _virtueLineAndSpace("quimera", "-2"),
                  _virtueLineAndSpace("corporacion", "1"),
                  SizedBox(
                    height: _screenSize.height * 0.05,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              decoration: BoxDecoration(image: _cardImage()),
            )
          ],
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  DecorationImage _cardImage() {
    return DecorationImage(image: AssetImage(_cardImageUrl));
  }

  Column _virtueLineAndSpace(String factionValue, String virtueValue) {
    return Column(
      children: <Widget>[
        _virtueLine(factionValue, virtueValue),
        SizedBox(height: _screenSize.height * 0.02)
      ],
    );
  }

  Row _virtueLine(String factionValue, String virtueValue) {
    return Row(children: <Widget>[
      SizedBox(width: _screenSize.width * 0.08),
      _virtueSpace(_leftContainerDecoration(), factionValue),
      SizedBox(
        width: 0.3,
      ),
      _virtueSpace(_rightContainerDecoration(), virtueValue),
      SizedBox(width: _screenSize.width * 0.08),
    ], mainAxisAlignment: MainAxisAlignment.center);
  }

  Container _virtueSpace(BoxDecoration decoration, String value) {
    return Container(
      child: Center(child: Text(value)),
      decoration: decoration,
      width: _screenSize.width * 0.247,
      height: _screenSize.height * 0.06,
    );
  }

  BoxDecoration _leftContainerDecoration() {
    return BoxDecoration(
      //color: Color.fromRGBO(182, 158, 130, 1.0),
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(0.0),
        topLeft: Radius.circular(13.0),
        bottomRight: Radius.circular(0.0),
        bottomLeft: Radius.circular(13.0),
      ),
    );
  }

  BoxDecoration _rightContainerDecoration() {
    return BoxDecoration(
      //color: Color.fromRGBO(182, 158, 130, 1.0),
      color: Colors.white,
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(13.0),
          topLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(13.0),
          bottomLeft: Radius.circular(0.0)),
    );
  }
}
