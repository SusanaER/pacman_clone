import 'package:flutter/material.dart';

class MyPath extends StatelessWidget {
  final innerColor;
  final outerColor;
  final child;

  MyPath({this.innerColor, this.outerColor, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.all(10),
          color: outerColor,
          child: Center(
              child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: innerColor,
              child: Center(child: child),
            ),
          )),
        ),
      ),
    );
  }
}
