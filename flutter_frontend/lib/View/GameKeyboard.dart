import 'package:flutter/material.dart';
import 'package:four_2_ten/Model/Colour.dart';
import 'package:four_2_ten/Utils/EnumToDartColor.dart';
import 'package:four_2_ten/Utils/HexColor.dart';

class GameKeyboard extends StatefulWidget {
  final List<int> numbers;
  final Function goCallBack;
  final Function passCallBack;

  // Put here temporarily as a quick fix
  List<bool> isPressedStates = [false, false, false, false]; // whether user has pressed a number button
  String currentString = ""; // what the user has entered on the keyboard
  List<int> pressedIndices = []; // indices of numbers that have been pressed

  GameKeyboard(this.numbers, this.goCallBack, this.passCallBack);

  @override
  _GameKeyboardState createState() => _GameKeyboardState(goCallBack, passCallBack);
}

class _GameKeyboardState extends State<GameKeyboard> {
  final Function goCallBack;
  final Function passCallBack;

  static const GO_BUTTON_TEXT = "GO!";
  static const PASS_BUTTON_TEXT = "PASS";

  _GameKeyboardState(this.goCallBack, this.passCallBack);

  void _onPressKeyboardButton(String text) {
    if (text == GO_BUTTON_TEXT) {
      goCallBack(widget.currentString);
    } else if (text == PASS_BUTTON_TEXT) {
      passCallBack();
    } else {
      setState(() {
        widget.currentString += text;
      });
    }
  }

  Widget _getButton(String text, double size, double fontSize, bool isPressed, {int index}) {
    return SizedBox(
      width: size,
      height: size,
      child: Card(
        color: isPressed ? HexColor.fromHex('#D0B4E7') : HexColor.fromHex('#EDDDFB'),
        elevation: 3,
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (!isPressed) {
              _onPressKeyboardButton(text);
            }

            RegExp _numeric = RegExp(r'^[0-9]$');
            if (_numeric.hasMatch(text) && index != null) {
              setState(() {
                widget.isPressedStates[index] = true;
                widget.pressedIndices.add(index);
              });
            }
          },
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontFamily: "WalterTurncoat",
                fontSize: fontSize,
              ),
            )
          ),
        )
      ),
    );
  }

  Widget _getRow(double size, List<String> texts, List<double> fontSizes, {int firstIndex, int secondIndex}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getButton(texts[0], size, fontSizes[0],
            firstIndex == null ? false : widget.isPressedStates[firstIndex], index: firstIndex),
        _getButton(texts[1], size, fontSizes[1],
            secondIndex == null ? false : widget.isPressedStates[secondIndex], index: secondIndex),
        _getButton(texts[2], size, fontSizes[2], false),
        _getButton(texts[3], size, fontSizes[3], false),
      ],
    );
  }

  // `size refers to button size`
  Widget _getButtons(double size) {
    double symbolFontSize = 35;
    double wordFontSize = 15;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _getRow(size, [widget.numbers[0].toString(), widget.numbers[1].toString(), '+', '-'],
            List.filled(4, symbolFontSize), firstIndex: 0, secondIndex: 1),
        _getRow(size, [widget.numbers[2].toString(), widget.numbers[3].toString(), '×', '÷'],
            List.filled(4, symbolFontSize), firstIndex: 2, secondIndex: 3),
        _getRow(size, ['(', ')', GO_BUTTON_TEXT, PASS_BUTTON_TEXT],
            [symbolFontSize, symbolFontSize, wordFontSize, wordFontSize]),
      ],
    );
  }

  // Includes display text + delete button
  Widget _getKeyboardTop() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            widget.currentString,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "WalterTurncoat",
              fontSize: 40, // TODO: standardise later
            ),
          ),
          IconButton(
            icon: const Icon(Icons.backspace),
            tooltip: 'Backspace',
            onPressed: _onDelete,
          ),
        ],
      ),
    );
  }

  void _onDelete() {
    if (widget.currentString.length > 0) {
      setState(() {
        String lastCharacter = widget.currentString.substring(widget.currentString.length - 1);
        RegExp _numeric = RegExp(r'^[0-9]$');
        if (_numeric.hasMatch(lastCharacter)) {
          // If the last character is a number, we need to un-highlight the keyboard cell.
          int lastIndex = widget.pressedIndices.removeLast();
          widget.isPressedStates[lastIndex] = false;
        }

        // Remove the last character from the keyboard display
        widget.currentString = widget.currentString.substring(0, widget.currentString.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth / 5;
    double cardHeight = screenHeight / 2;

    // TODO: figure out how to remove the horizontal margins
    return SizedBox(
      height: cardHeight,
      child: Card(
        margin: EdgeInsets.zero,
        color: EnumToDartColor.fromColourEnum(Colour.lightBlue), // TODO: change color according to player
        child: Column(
          children: [
            _getKeyboardTop(),
            _getButtons(buttonWidth),
          ],
        )
      ),
    );
  }
}
