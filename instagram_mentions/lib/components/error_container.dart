import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  bool isVisible;
  String errorText;
  Color bgColor;
  ErrorContainer({this.isVisible = false, this.errorText = '', this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          errorText,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
