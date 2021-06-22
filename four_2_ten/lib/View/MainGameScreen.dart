import 'package:flutter/material.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';

class MainGameScreen extends StatefulWidget {
  final GameController gameController;

  MainGameScreen(this.gameController);

  @override
  _MainGameScreenState createState() => _MainGameScreenState(gameController);
}

class _MainGameScreenState extends State<MainGameScreen> {
  final GameController gameController;

  _MainGameScreenState(this.gameController);

  @override
  Widget build(BuildContext context) {
    return Text("placeholder");
  }
}
