import 'package:flutter/material.dart';
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
}
