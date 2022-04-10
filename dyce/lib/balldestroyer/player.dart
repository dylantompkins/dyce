import 'package:dyce/balldestroyer/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math';

class Player extends PositionComponent {
  bool ballsInMotion = false;
  bool inAimState = false;

  Vector2 root = Vector2(0, 0);

  final _paint = Paint()..color = Color.fromARGB(255, 180, 17, 17);
  int ballNums = 20;

  Vector2 screenSize = Vector2(0, 0);

  var offsets = List.filled(5, Offset(0, 0));

  Player(Vector2 start, Vector2 screens) {
    root = start;
    screenSize = screens;
  }

  //renders the ball line
  @override
  void render(Canvas canvas) {
    if (inAimState) {
      // canvas.drawCircle(
      //     Offset(200 - position.x.abs(), position.y), 10, _paint);

      //Circle at the starting position
      for (int i = 0; i < 5; i++) {
        canvas.drawCircle(offsets[i], 5, _paint);
      }
    }
  }

  //show ball line when touching screen
  void initializeBallLine() {
    inAimState = true;
  }

  //move ball line when screen moves
  void rotateBallLine(Vector2 thumb) {
    //find the slope

    //use that slope to add 4 balls onto the screen on the line

    position.x = thumb.x;
    position.y = screenSize.y - 100;
    double slope = (thumb.y - root.y) / (thumb.x - root.x);

    double interval = slope / 5;
    double xInterval = screenSize.x / 10;

    //print(position.y * slope);
    print(position.y);
    for (int i = 0; i < 5; i++) {
      offsets[i] = Offset(-xInterval * (i + 1), 0);
    }
    
  }

  //release balls when no longer touching
  void releaseBalls() {
    inAimState = false;
  }

  //player cancelled the ball input
  void noMoreBallLine() {}
}
