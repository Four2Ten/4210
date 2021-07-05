import 'package:flutter/material.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:global_configuration/global_configuration.dart';

class Commons {
  static Text getTitle(String string) {
    double bigFontSize = GlobalConfiguration().getValue("bigFontSize");
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontFamily: "WalterTurncoat",
      fontSize: bigFontSize,
    );
    return new Text(string, style: textStyle, textAlign: TextAlign.center);
  }

  static colourToAssetString(Colour colour) {
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
}
