import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ConfirmButton({this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 155,
        height: 42,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(255, 51, 12, 0.3),
                  blurRadius: 10.0,
                  spreadRadius: 0.0,
                  offset: Offset(0.0, 6.0))
            ],
            borderRadius: BorderRadius.circular(6.0),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(255, 135, 99, 1),
              Color.fromRGBO(255, 51, 12, 1),
            ])),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      onTap: onTap,
    );
  }
}