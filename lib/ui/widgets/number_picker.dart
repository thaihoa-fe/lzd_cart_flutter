import 'package:flutter/material.dart';

typedef void NumberChangeCallback(int newValue);

class NumberPicker extends StatelessWidget {
  final int value;
  final int max;
  final int min;
  final NumberChangeCallback onChange;

  const NumberPicker({this.value, this.onChange, int max, int min})
      : this.max = max ?? 100,
        this.min = min ?? 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      child: Row(children: [
        InkWell(
          onTap: () {
            int newValue = value - 1;
            if (newValue >= min) {
              handleChange(newValue); 
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Text('-'),
            width: 25,
            height: 25,
          ),
        ),
        Container(
          width: 20,
          color: Color.fromRGBO(248, 248, 248, 1),
          alignment: Alignment.center,
          child: Text('${this.value}'),
        ),
        InkWell(
          onTap: () {
            int newValue = value + 1;
            if (newValue <= max) {
              handleChange(newValue);
            }
          },
          child: Container(
            alignment: Alignment.center,
            child: Text('+'),
            width: 25,
            height: 25,
          ),
        ),
      ]),
    );
  }

  handleChange(newValue) {
    onChange(newValue);
  }
}