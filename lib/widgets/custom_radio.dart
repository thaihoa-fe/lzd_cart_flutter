import 'package:flutter/material.dart';

enum RadioState {
  NORMAL,
  SELECTED,
  DISABLED,
}

typedef void RadioChangeCallback(RadioState newState);

class CustomRadio extends StatelessWidget {
  final RadioState state;
  final RadioChangeCallback onChange;
  const CustomRadio({RadioState state, this.onChange})
      : this.state = state ?? RadioState.NORMAL;

  void handleChange() {
    if (state == RadioState.DISABLED) {
      return;
    }
    onChange(state == RadioState.NORMAL ? RadioState.SELECTED : RadioState.NORMAL);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: handleChange,
      child: Container(
        alignment: Alignment.center,
        width: 18,
        height: 18,
        decoration: buildBoxDecoration(),
        child: state == RadioState.SELECTED ?
          Icon(Icons.check, size: 10, color: Colors.white,) : null
        ,
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    BoxDecoration base = BoxDecoration(shape: BoxShape.circle);

    switch(state) {
      case RadioState.DISABLED:
        return base.copyWith(
          color: Color.fromRGBO(238, 238, 238, 1),
        );

      case RadioState.SELECTED:
        return base.copyWith(
          color: Colors.redAccent,
        );

      default:
        return base.copyWith(
          border: Border.all(
            color: Color.fromRGBO(196, 198, 207, 1),
          )
        );
    }
  }
}