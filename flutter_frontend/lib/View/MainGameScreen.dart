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

  // TODO: this is the temporary status text on MainGameScreen. 
  // It will eventually be replaced by nicer UI
  String status = "Round 1";

  _MainGameScreenState(this.gameController) {
    this.gameController.uiCallback = onStartNewRound;

    if (gameController.isHost && (gameController as HostGameController).isSolo) {
      // Solo Mode
      (gameController as HostGameController).startRound();
      List<int> newQuestion = List.filled(4, -1);
      for (int i = 0; i < 4; i++) {
        newQuestion[i] = int.parse(gameController.currentQuestion[i]);
      }
      currentQuestion = newQuestion;
    } else if (gameController.isHost) {
      // Multi-player mode, host player
      (gameController as HostGameController).attachMainGameListeners(onStartNewRound,
          _onGetCorrect, _onTimeUp, _onEndGame);
      (gameController as HostGameController).attachPassCallback();
      (gameController as HostGameController).startRound();
    } else {
      // Multi-player mode, normal player
      gameController.attachMainGameListeners(onStartNewRound, _onGetCorrect,
          _onTimeUp, _onEndGame);
    }
  }

  void _onGetCorrect(String name, int score, String correctAnswer) {
    setState(() {
      status = name + " got it correct with " + correctAnswer;
    });
  }

  void _onTimeUp() {
    setState(() {
      status = "Oh no time's up!";
    });
  }

  void _onEndGame() {
    setState(() {
      status = "Game ended!";
    });
  }

  // Callback when a new round starts
  void onStartNewRound(int round) {
    List<int> newQuestion = List.filled(4, -1);
    for (int i = 0; i < 4; i++) {
      newQuestion[i] = int.parse(gameController.currentQuestion[i]);
    }

    setState(() {
      currentQuestion = newQuestion;
      status = "Round " + round.toString();
    });
  }

  // Callback function for the "GO!" button in keyboard
  // TODO: clean up and remove duplication
  void _onPressGo(String answer) {
    bool isCorrect = gameController.checkAnswer(answer, currentQuestion.map((e) => e.toString()).join(""));
    if (isCorrect) {
      print("Correct!!");
      if (gameController.isHost && (gameController as HostGameController).isSolo) {
        // SOLO MODE
        (gameController as HostGameController).startRound();
        List<int> newQuestion = List.filled(4, -1);
        for (int i = 0; i < 4; i++) {
          newQuestion[i] = int.parse(gameController.currentQuestion[i]);
        }
        setState(() {
          currentQuestion = newQuestion;
          status = "Round " + (gameController as HostGameController).roundNumber.toString();
        });
      } else {
        // Multi Player MODE
        gameController.getCorrect(answer);
      }
    } else {
      setState(() {
        status = "WRONG!";
      });
    }
  }

  // Callback function for the "PASS!" button in keyboard
  void _onPressPass() {
    if (gameController.isHost && (gameController as HostGameController).isSolo) {
      // Solo Mode
      // TODO: remove duplication
      (gameController as HostGameController).startRound();
      List<int> newQuestion = List.filled(4, -1);
      for (int i = 0; i < 4; i++) {
        newQuestion[i] = int.parse(gameController.currentQuestion[i]);
      }
      setState(() {
        currentQuestion = newQuestion;
        status = "Round " + (gameController as HostGameController).roundNumber.toString();
      });
    } else {
      // Multi-player Mode
      gameController.indicatePass();
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
              GameKeyboard(currentQuestion, _onPressGo, _onPressPass),
            ]
          ),
        )
      )
    );
  }
}
