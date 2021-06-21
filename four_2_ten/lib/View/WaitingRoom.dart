import 'package:flutter/material.dart';
import 'package:four_2_ten/GameLogic/GameController.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Model/Player.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/View/Commons.dart';
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

  _WaitingRoomState(GameController gameController) {
    this.gameController = gameController;
    players = [gameController.currPlayer, ...gameController.otherPlayers]; // add self to list of players
    smallFontSize = GlobalConfiguration().getValue("smallFontSize");
  }

  Widget _getPlayerIcon(Player player, double width) {
    Colour colour = player != null ? player.colour : Colour.lightBlue; // TODO: change this to a placeholder
    String name = player != null ? player.name : '---'; // TODO: change this to a placeholder
    String source = Commons.colourToAssetString(colour);

    return Column(
      children: [
        Image(
          image: AssetImage(source),
          width: width,
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

  // returns null if index out of range
  Player _getPlayer(int index) {
    print("players length " + players.length.toString());
    if (index >= players.length) {
      return null;
    } else {
      return players[index];
    }
  }

  Widget _getAllPlayerIcons(double screenWidth, double screenHeight) {
    double imageWidth = screenWidth / 5;
    double spacing = screenHeight * 0.05;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _getPlayerIcon(_getPlayer(0), imageWidth),
            _getPlayerIcon(_getPlayer(1), imageWidth),
            _getPlayerIcon(_getPlayer(2), imageWidth),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _getPlayerIcon(_getPlayer(3), imageWidth),
            _getPlayerIcon(_getPlayer(4), imageWidth),
            _getPlayerIcon(_getPlayer(5), imageWidth),
          ],
        )
      ],
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
    double pinAndCarsSpacing = screenHeight * 0.1;

    return new Scaffold(
      backgroundColor: HexColor.fromHex('#372549'),
      body: new Container(
        padding: new EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
        child: Center(
          child: new Column(
            children: <Widget>[
              SizedBox(height: topSpacing),
              Commons.getTitle('Your Room Pin'),
              SizedBox(height: headerAndPinSpacing),
              Commons.getTitle(gameController.pin.toString()), // TODO: style this
              SizedBox(height: pinAndCarsSpacing),
              _getAllPlayerIcons(screenWidth, screenHeight)
            ]
          ),
          )
      )
    );
  }
}
