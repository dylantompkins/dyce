import 'package:dyce/balldestroyer/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Player extends PositionComponent {
  bool ballsInMotion = false;
  bool inAimState = false;

  Vector2 root = Vector2(0, 0);

  final _paint = Paint()..color = Colors.white;
  int ballNums = 20;

  Player(Vector2 start) {
    root = start;
  }

  //renders the ball line
  @override
  void render(Canvas canvas) {
    if (inAimState) {
      canvas.drawCircle(Offset(10, 0), 10, _paint);
    }
  }

  //show ball line when touching screen
  void initializeBallLine() {
    inAimState = true;
  }

  //move ball line when screen moves
  void rotateBallLine(Vector2 thumb) {
    position = thumb;
  }

  //release balls when no longer touching
  void releaseBalls() {
    inAimState = false;
  }

  //player cancelled the ball input
  void noMoreBallLine() {}
}
