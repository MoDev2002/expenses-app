import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class AdaptiveFlatButton extends StatelessWidget {
final String buttonText;
final Function buttonHandler;

AdaptiveFlatButton({this.buttonText, this.buttonHandler});
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoButton(
      child: Text(buttonText, style: Theme.of(context).textTheme.button,), 
      onPressed: buttonHandler) 
    : TextButton(
                    onPressed: buttonHandler,
                    child: Text(buttonText,
                        style: Theme.of(context).textTheme.button),
                    // textColor: Theme.of(context).accentColor,
                  );
  }
}