import 'package:flutter/material.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/View/CustomElevatedButton.dart';
import 'package:four_2_ten/View/NumberKeyboard.dart';

import 'ChooseCarScreen.dart';
import 'Commons.dart';

class JoinRoomScreen extends StatefulWidget {
  @override
  _JoinRoomScreenState createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {

  List<int> currentDigits = List.empty(growable: true);

  void _onPressKey(int digit) {
    setState(() {
      if (currentDigits.length < 4) {
        currentDigits.add(digit);
      }
    });
  }

  void _onDelete() {
    setState(() {
      currentDigits.removeLast();
    });
  }

  String _getCurrentString() {
    if (currentDigits.length == 0) {
      return "";
    } else {
      return currentDigits.map((e) => e.toString()).join(" ");
    }
  }

  // TODO: implement this UI properly
  Widget _getInput() {
    return Text(
      _getCurrentString(),
      style: TextStyle(
        color: Colors.white,
        fontFamily: "WalterTurncoat",
        fontSize: 30,
      ),
      textAlign: TextAlign.center,
    );
  }

  void _onPressButton() {
    GameController gameController = new GameController();
    gameController.pin = currentDigits.map((e) => e.toString()).join("");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseCarScreen(gameController)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // spacing sizes
    double sidePadding = screenWidth * 0.05;
    double topSpacing = screenHeight * 0.08;
    double inputAndButtonSpacing = screenHeight * 0.1;
    double buttonAndKeyboardSpacing = screenHeight * 0.06;

    return Scaffold(
        backgroundColor: HexColor.fromHex('#372549'),
        body: Container(
            padding: EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Commons.getTitle('Your Room Pin'),
                  SizedBox(height: topSpacing),
                  _getInput(),
                  SizedBox(height: inputAndButtonSpacing),
                  Opacity(
                    child: CustomElevatedButton('head to garage', _onPressButton),
                    opacity: currentDigits.length == 4 ? 1.0 : 0.0,
                  ),
                  SizedBox(height: buttonAndKeyboardSpacing),
                  NumberKeyboard(_onPressKey, _onDelete),
                ]
              ),
            )
        )
    );
  }
}
