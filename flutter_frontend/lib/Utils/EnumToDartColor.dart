import 'package:flutter/material.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Utils/HexColor.dart';

class EnumToDartColor {
  static Color fromColourEnum(Colour colour) {
    switch(colour) {
      case Colour.darkBlue:
        return HexColor.fromHex('#3775D1');
      case Colour.lightBlue:
        return HexColor.fromHex('#B9E6FF');
      case Colour.green:
        return HexColor.fromHex('#C6E8C0');
      case Colour.orange:
        return HexColor.fromHex('#F9BB83');
      case Colour.pink:
        return HexColor.fromHex('#FFD4D4');
      case Colour.red:
        return HexColor.fromHex('#FC7A7A');
      default:
        return HexColor.fromHex('#3775D1'); // Default to dark blue
    }
  }
}
