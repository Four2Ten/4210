import 'package:flutter/material.dart';
import 'package:four_2_ten/Model/Colour.dart';

import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:four_2_ten/View/Commons.dart';

// For now, two players can choose the same colour.
// TODO: only can choose unique colours.
class ChooseCarScreen extends StatefulWidget {

  ChooseCarScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  ChooseCarScreenState createState() => ChooseCarScreenState();
}

class ChooseCarScreenState extends State<ChooseCarScreen> {

  ChooseCarScreenState() {}

  String _colourToAssetString(Colour colour) {
    switch (colour) {
      case Colour.darkBlue:
        return 'lib/assets/images/darkblue_car.png';
      case Colour.green:
        return 'lib/assets/images/green_car.png';
      case Colour.lightBlue:
        return 'lib/assets/images/lightblue_car.png';
      case Colour.orange:
        return 'lib/assets/images/orange_car.png';
      case Colour.pink:
        return 'lib/assets/images/pink_car.png';
      case Colour.red:
        return 'lib/assets/images/red_car.png';
      default:
        return null;
    }
  }

  Widget _getRow(Colour firstColour, Colour secondColour,
      Colour thirdColour, double imageWidth) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FlatButton(onPressed: null, child: _getSizedImage(firstColour, imageWidth)),
        FlatButton(onPressed: null, child: _getSizedImage(secondColour, imageWidth)),
        FlatButton(onPressed: null, child: _getSizedImage(thirdColour, imageWidth)),
      ],
    );
  }

  Image _getSizedImage(Colour colour, double width) {
    String source = _colourToAssetString(colour);

    return Image(
      image: AssetImage(source),
      width: width,
    );
  }

  // void _onPickCar() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => RoomSettings()),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double sidePadding = screenWidth * 0.05;

    // spacing sizes
    double topSpacing = screenHeight * 0.1;
    double headerAndFirstRowSpacing = screenHeight * 0.15;
    double interRowSpacing = screenHeight * 0.2;
    double imageWidth = screenWidth / 5;

    return new Scaffold(
        backgroundColor: HexColor.fromHex('#372549'),
        body: new Container(
            padding: new EdgeInsets.fromLTRB(sidePadding, 0, sidePadding, 0),
            child: Center(
                child: new Column(
                    children: <Widget>[
                      SizedBox(height: topSpacing),
                      Commons.getTitle('Pick Your Car'),
                      SizedBox(height: headerAndFirstRowSpacing),
                      _getRow(Colour.lightBlue, Colour.orange, Colour.green, imageWidth),
                      SizedBox(height: interRowSpacing),
                      _getRow(Colour.darkBlue, Colour.pink, Colour.green, imageWidth),
                    ]
                )
            )
        )
    );
  }
}