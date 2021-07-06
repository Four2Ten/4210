import 'package:flutter/material.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';
import 'package:four_2_ten/GameLogic/HostGameController.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/View/GameKeyboard.dart';

class MainGameScreen extends StatefulWidget {
  final GameController gameController;

  MainGameScreen(this.gameController);

  @override
  _MainGameScreenState createState() => _MainGameScreenState(gameController);
}

class _MainGameScreenState extends State<MainGameScreen> {
  GameController gameController;
  List<int> currentQuestion;

  // temp
  String status = "Round 1";

  _MainGameScreenState(GameController gameController) {
    this.gameController = gameController;
    this.gameController.uiCallback = startNewRound;

    // Solo Mode
    if (gameController.isHost && (gameController as HostGameController).isSolo) {
      (gameController as HostGameController).startSoloRound();
      List<int> newQuestion = List.filled(4, -1);
      for (int i = 0; i < 4; i++) {
        newQuestion[i] = int.parse(gameController.currentQuestion[i]);
      }
      currentQuestion = newQuestion;
    }
  }

  // Callback for when a new round starts
  void startNewRound() {
    List<int> newQuestion = List.filled(4, -1);
    for (int i = 0; i < 4; i++) {
      newQuestion[i] = int.parse(gameController.currentQuestion[i]);
    }

    setState(() {
      currentQuestion = newQuestion;
      status = "Round " + (gameController as HostGameController).roundNumber.toString();
    });
  }

  // Callback function for the "GO!" button in keyboard
  // TODO: clean up and remove duplication
  void _onPressGo(String answer) {
    bool isCorrect = gameController.checkAnswer(answer, currentQuestion.map((e) => e.toString()).join(""));
    if (isCorrect) {
      print("Correct!!");
      if (gameController.isHost && (gameController as HostGameController).isSolo) {
        (gameController as HostGameController).startSoloRound();
        List<int> newQuestion = List.filled(4, -1);
        for (int i = 0; i < 4; i++) {
          newQuestion[i] = int.parse(gameController.currentQuestion[i]);
        }
        setState(() {
          currentQuestion = newQuestion;
          status = "Round " + (gameController as HostGameController).roundNumber.toString();
        });
      }
    } else {
      setState(() {
        status = "WRONG!";
      });
    }
  }

  // Callback function for the "PASS!" button in keyboard
  void _onPressPass() {
    // TODO: implement; remove duplication
    print("pressed PASS");

    if (gameController.isHost && (gameController as HostGameController).isSolo) {
      (gameController as HostGameController).startSoloRound();
      List<int> newQuestion = List.filled(4, -1);
      for (int i = 0; i < 4; i++) {
        newQuestion[i] = int.parse(gameController.currentQuestion[i]);
      }
      setState(() {
        currentQuestion = newQuestion;
        status = "Round " + (gameController as HostGameController).roundNumber.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // spacing sizes
    double sidePadding = screenWidth * 0.05;
    double spacing = screenHeight * 0.1;

    return Scaffold(
      backgroundColor: HexColor.fromHex('#372549'),
      body: Container(
        padding: EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // TODO: this Text widget is just a temp placeholder
              Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "WalterTurncoat",
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                currentQuestion == null ? "" : currentQuestion.map((e) => e.toString()).join(" "),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "WalterTurncoat",
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacing),
              GameKeyboard(currentQuestion, _onPressGo, _onPressPass), // TODO: change hardcoding
            ]
          ),
        )
      )
    );
  }
}
