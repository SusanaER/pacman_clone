import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  const MyPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 3.14159265359, // 180 grados en radianes
      child:  Image.asset(
      'lib/images/pacman.png'
      ), 
    );
  }
}