import 'package:flutter/material.dart';
import 'package:four_2_ten/Utils/HexColor.dart';
import 'package:global_configuration/global_configuration.dart';

class CustomElevatedButton extends StatefulWidget {
  CustomElevatedButton({Key key, this.text, this.onPress}) : super(key: key);

  final String text;
  final Function() onPress;

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState(this.text, this.onPress);
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  final String text;
  final Function() onPress;

  _CustomElevatedButtonState(this.text, this.onPress);

  FittedBox _getButtonText(String text) {
    return FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'DidactGothic',
              fontSize: GlobalConfiguration().getValue("bigFontSize"),
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          child: _getButtonText(text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(10),
            primary: HexColor.fromHex('#B9E6FF'),
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            // print('Pressed');
            this.onPress();
          },
        )
    );
  }
}