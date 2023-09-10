import 'dart:async';
import 'dart:math';
import 'package:pacman_clone/path.dart';
import 'package:pacman_clone/pixel.dart';
import 'package:pacman_clone/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 17;
  int player = numberInRow * 15 + 1;
  bool eater = false;
  int score = 0;
  bool gameStarted = false;
  String btnText = "P L A Y"; 
  String direction = "right";
  List<int> food = [];
  //final audio = AudioPlayer();

  // Barreras/Bordes de la cuadricula
  List<int> barriers = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, // Arriba
    11, 22, 33, 44, 55, 66, 77, 99, 110, 121, 132, 143, 154, 165,
    176, // Izquierda
    177, 178, 179, 180, 181, 182, 183, 184, 185, 186, // Abajo
    175, 164, 153, 142, 131, 120, 109, 87, 76, 65, 54, 43, 32, 21, // Izquierda
    24, 35, 46, 57, // Barrera 1
    26, 37, 38, 39, 28, // Barrera 2
    30, 41, 52, 63, // Barrera 3
    78, 79, 80, 81, 70, 59, // Barrera 4
    61, 72, 83, 84, 85, 86, // Barrera 5
    100, 101, 102, 103, 114, 125, // Barrera 6
    127, 116, 105, 106, 107, 108, 109, // Barrera 7
    123, 134, 145, 156, // Barrera 8
    158, 147, 148, 149, 160, // Barrera 9
    129, 140, 151, 162 // Barrera 10
  ];

  void startGame(){
    //audio.play(UrlSource('game-start.mp3'));
    gameStarted = true;
    btnText = "E N D";
    getFood();
    Duration duration = Duration(milliseconds: 170);
    Timer.periodic(duration, (timer) {
      if(gameStarted == true){
        if (food.contains(player)) {
                food.remove(player);
                score++;
              }

              switch (direction) {
                case "left":
                  moveLeft();
                  break;
                case "right":
                  moveRight();
                  break;
                case "up":
                  moveUp();
                  break;
                case "down":
                  moveDown();
                  break;
              }
            }
      });
  }

  void restarGame(){
    Phoenix.rebirth(context);
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
          player--;
      });
    }else if(player - 1 == 87){
      player = 99;
    }
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }else if(player + 1 == 99){
      player = 87;
    }
  }

  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                // Detecta los movimientos de arriba a abajo
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                // Detecta los movimientos de izquierda a derecha
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        // Crea una cuadricula
                        crossAxisCount: numberInRow),
                    itemBuilder: (BuildContext context, int index) {
                      if (player == index) {
                        switch (direction) {
                          case "left":
                            return Transform.rotate(
                                angle: pi, child: MyPlayer());
                          case "right":
                            return MyPlayer();
                          case "up":
                            return Transform.rotate(
                                angle: 3 * pi / 2, child: MyPlayer());
                          case "down":
                            return Transform.rotate(
                                angle: pi / 2, child: MyPlayer());
                        }
                      } else if (barriers.contains(index)) {
                        return MyPixel(
                          innerColor: Colors.blue[800],
                          outerColor: Colors.blue[900],
                          //child: Text(index.toString()), // Le ponse el numero correspondiente en la cuadricula
                        );
                      } else {
                        if (food.isEmpty && gameStarted == false) {
                          return MyPath(
                            innerColor: Colors.yellow,
                            outerColor: Colors.black,
                          );
                        } else if (food.contains(index)) {
                          return MyPath(
                            innerColor: Colors.yellow,
                            outerColor: Colors.black,
                          );
                        } else {
                          return MyPath(
                            innerColor: Colors.black,
                            outerColor: Colors.black,
                          );
                        }
                      }
                    }),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Score: " + score.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  GestureDetector(
                      onTap: gameStarted ? restarGame : startGame,
                      child: Text(btnText,
                          style: TextStyle(color: Colors.white, backgroundColor: gameStarted ? Colors.red : Colors.green, fontSize: 40))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
