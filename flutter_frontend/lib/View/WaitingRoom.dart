import 'package:flutter/material.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';
import 'package:four_2_ten/GameLogic/HostGameController.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/View/Commons.dart';
import 'package:four_2_ten/View/MainGameScreen.dart';
import 'package:global_configuration/global_configuration.dart';

class WaitingRoom extends StatefulWidget {
  final GameController gameController;

  WaitingRoom(this.gameController);

  @override
  _WaitingRoomState createState() => _WaitingRoomState(gameController);
}

class _WaitingRoomState extends State<WaitingRoom> {
  GameController gameController;
  List<Player> players;
  double smallFontSize;

  _WaitingRoomState(this.gameController) {
    this.players = [gameController.currPlayer, ...gameController.otherPlayers]; // add self to list of players
    this.smallFontSize = GlobalConfiguration().getValue("smallFontSize");

    this.gameController.attachJoinListener(onJoin);
    this.gameController.attachReadyListener(onReceiveReady);
    this.gameController.attachGameStartListener(onStartGame);
  }

  //Note: listen for other players joining
  void onJoin() {
    // TODO: remove duplication cuz same as below
    setState(() {
      players = [gameController.currPlayer, ...gameController.otherPlayers]; // add self to list of players
    });
  }

  void onReceiveReady() {
    setState(() {
      players = [gameController.currPlayer, ...gameController.otherPlayers]; // add self to list of players
    });
  }

  void onStartGame() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainGameScreen(gameController)),
    );
  }

  Widget _getIcon(Colour colour, String name, double width, double opacity) {
      String source = Commons.colourToAssetString(colour);
      return Column(
        children: [
          Opacity(
            opacity: opacity,
            child: Image(
                image: AssetImage(source),
                width: width,
              ),
            ),
          Text(
            name,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: "WalterTurncoat",
              fontSize: smallFontSize,
            ),
          )
        ],
      );
    }

  Widget _getAllPlayerIcons(double screenWidth, double screenHeight) {
    double imageWidth = screenWidth / 5;
    double spacing = screenHeight * 0.03;

    var colourAssignment = new Map();
    for (Player player in players) {
      colourAssignment[player.colour] = player;
    }

    List<Widget> playerIcons = <Widget>[];
    Colour.values.forEach((colour) {
      if (colourAssignment.containsKey(colour)) {
        String playerName = colourAssignment[colour].name;
        playerIcons.add(_getIcon(colour, playerName, imageWidth, 1));
      } else {
        playerIcons.add(_getIcon(colour, 'Waiting...', imageWidth, 0.5));
      }
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            playerIcons[0],
            playerIcons[1],
            playerIcons[2]
          ],
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            playerIcons[3],
            playerIcons[4],
            playerIcons[5]
          ],
        )
      ],
    );
  }

  void _onPressStart() {
    if (gameController.isHost) {
      // if host, the "START ENGINE" button functions as a start game button
      if ((gameController as HostGameController).isEveryoneReady()) {
        (gameController as HostGameController).startGame();
      } else {
        print("NOT EVERYONE IS READY YET!"); // TODO: implement UI
      }
    } else {
      // if not host, the "START ENGINE" button functions as a "I'm ready" button
      gameController.indicateReady();
    }
  }

  Widget _getStartButton(double width) {
    return FlatButton(
      onPressed: _onPressStart,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image(
            image: AssetImage('lib/assets/images/start_engine_button.png'),
            width: width,
          ),
          Center(
            child: Text(
              'Start\nEngine',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "WalterTurncoat",
                fontSize: smallFontSize,
              ),
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // spacing sizes
    double sidePadding = screenWidth * 0.05;
    double topSpacing = screenHeight * 0.1;
    double headerAndPinSpacing = screenHeight * 0.06;
    double pinAndCarsSpacing = screenHeight * 0.08;
    double carsAndButtonSpacing = screenHeight * 0.05;

    return Scaffold(
      backgroundColor: HexColor.fromHex('#372549'),
      body: Container(
        padding: EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: topSpacing),
              Commons.getTitle('Your Room Pin'),
              SizedBox(height: headerAndPinSpacing),
              Commons.getTitle(gameController.pin.toString()), // TODO: style this
              SizedBox(height: pinAndCarsSpacing),
              _getAllPlayerIcons(screenWidth, screenHeight),
              SizedBox(height: carsAndButtonSpacing),
              _getStartButton(screenWidth / 3),
            ]
          ),
          )
      )
    );
  }
}
