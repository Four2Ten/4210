import 'package:flutter/material.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Utils/EnumToDartColor.dart';
import 'package:four_2_ten/Utils/HexColor.dart';

class NumberKeyboard extends StatefulWidget {
  final Function pressCallback;
  final Function deleteCallback;

  NumberKeyboard(this.pressCallback, this.deleteCallback);

  @override
  _NumberKeyboardState createState() => _NumberKeyboardState(pressCallback, deleteCallback);
}

class _NumberKeyboardState extends State<NumberKeyboard> {
  final Function pressCallback;
  final Function deleteCallback;

  _NumberKeyboardState(this.pressCallback, this.deleteCallback);

  void _onPressKeyboardButton(int digit) {
    pressCallback(digit);
  }

  Widget _getButton(int digit, double size) {
    double digitFontSize = 35;

    return SizedBox(
      width: size,
      height: size,
      child: Card(
          color: HexColor.fromHex('#EDDDFB'),
          elevation: 3,
          child: FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () => _onPressKeyboardButton(digit),
            child: Center(
                child: Text(
                  digit.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "WalterTurncoat",
                    fontSize: digitFontSize,
                  ),
                )
            ),
          )
      ),
    );
  }

  Widget _getColumn(double size, List<int> digits) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getButton(digits[0], size),
        _getButton(digits[1], size),
        _getButton(digits[2], size),
      ],
    );
  }
  
  Widget _getDeleteButton(double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: HexColor.fromHex('#EDDDFB'),
        elevation: 3,
        child: IconButton(
          icon: const Icon(Icons.backspace),
          tooltip: 'Backspace',
          onPressed: _onDelete,
        ),
      ),
    );
  }

  // `size refers to button size`
  Widget _getButtons(double buttonSize, double deleteWidth, double deleteHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getColumn(buttonSize, [1, 4, 7]),
        _getColumn(buttonSize, [2, 5, 8]),
        _getColumn(buttonSize, [3, 6, 9]),
        _getDeleteButton(deleteWidth, deleteHeight),
      ],
    );
  }

  void _onDelete() {
    deleteCallback();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth / 5;
    double cardHeight = screenHeight / 2.3;
    double deleteButtonWidth = screenWidth / 6;
    double deleteButtonHeight = screenHeight / 2.5;

    // TODO: figure out how to remove the horizontal margins
    return SizedBox(
      height: cardHeight,
      child: Card(
          margin: EdgeInsets.zero,
          color: EnumToDartColor.fromColourEnum(Colour.lightBlue), // TODO: randomise color
          child: _getButtons(buttonWidth, deleteButtonWidth, deleteButtonHeight),
      ),
    );
  }
}
