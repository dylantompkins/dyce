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

  Vector2 lastPos = Vector2(0, 0);

  Player(Vector2 start, Vector2 screens) {
    root = start;
    screenSize = screens;

    //THIS CODE WORKs but position is in relation to the parent
    // CircleComponent component = CircleComponent(
    //     radius: 10,
    //     position: Vector2(size.x / 2, size.y - 30),
    //     paint: Paint()..color = Color.fromARGB(255, 180, 17, 17));
    // component.renderShape = true;
    // add(component);
  }

  //renders the ball line
  @override
  void render(Canvas canvas) {
    if (inAimState) {
      canvas.drawCircle(Offset(0, 0), 10, _paint);
    }
  }

  //show ball line when touching screen
  void initializeBallLine() {
    inAimState = true;
  }

  //move ball line when screen moves
  void rotateBallLine(Vector2 thumb) {
    position.x = thumb.x;
    if (thumb.y > screenSize.y - (screenSize.y / 3)) {
      position.y = thumb.y;
    }
    lastPos = thumb;
  }

  Vector2 lastStuff() {
    return lastPos;
  }

  int getBalls() {
    return ballNums;
  }

  Vector2 calculateSpeed(double xVel, double yVel, double speed) {
    //Calculate unit vector
    double bottom = sqrt(xVel * xVel + yVel * yVel);

    Vector2 unit = Vector2(xVel / bottom, yVel / bottom);

    return Vector2(unit.x * speed, unit.y * speed);
  }

  //release balls when no longer touching
  void releaseBalls() {
    inAimState = false;
  }
}
