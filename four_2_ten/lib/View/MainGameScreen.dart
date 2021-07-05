import 'package:flutter/material.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/View/GameKeyboard.dart';

class MainGameScreen extends StatefulWidget {
  final GameController gameController;

  MainGameScreen(this.gameController);

  @override
  _MainGameScreenState createState() => _MainGameScreenState(gameController);
}

class _MainGameScreenState extends State<MainGameScreen> {
  final GameController gameController;

  _MainGameScreenState(this.gameController);

  // Callback function for the "GO!" button in keyboard
  void _onPressGo(String answer) {
    // TODO: implement
    print("pressed GO! The current string is: ");
    print(answer);
  }

  // Callback function for the "PASS!" button in keyboard
  void _onPressPass() {
    // TODO: implement
    print("pressed PASS");
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // spacing sizes
    double sidePadding = screenWidth * 0.05;
    double topSpacing = screenHeight * 0.1;

    return Scaffold(
      backgroundColor: HexColor.fromHex('#372549'),
      body: Container(
        padding: EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(height: topSpacing),
              GameKeyboard([5, 6, 7, 8], _onPressGo, _onPressPass), // TODO: change hardcoding
            ]
          ),
        )
      )
    );
  }
}