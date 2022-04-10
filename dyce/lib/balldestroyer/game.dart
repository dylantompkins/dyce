import 'dart:html';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/gestures.dart';

import 'package:flame/timer.dart';

//Need to hide it so Draggable doesnt get flagged2
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';

//Needed to lock phone into portrait mode
import 'package:flutter/services.dart';

import 'package:dyce/balldestroyer/player.dart';

class BallDestroyer extends FlameGame
    with HasDraggables, HasCollisionDetection, TapDetector, PanDetector {
  late Ball ball;
  late Side leftBound;
  late Top topBound;
  late Side rightBound;
  late Top bottomBound;
  late Player player;
  @override
  Color backgroundColor() => Color.fromARGB(70, 0, 18, 85);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(Vector2(400, 600));

    ball = Ball()
      ..position = Vector2(size.x / 2, size.y - (size.y / 7))
      // ..width = 100
      // ..height = 30
      ..anchor = Anchor.center;

    //Adds the boundaries
    topBound = Top(0, 0, size.x, 10)
      ..position = Vector2(0, 0)
      // ..width = size.x
      // ..height = 10
      ..anchor = Anchor.center;

    leftBound = Side(0, 10, 10, size.y)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    rightBound = Side(size.x - 10, 10, 10, size.y)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    bottomBound = Top(0, size.y - 10, size.x, 10)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    player = Player(Vector2(size.x / 2, size.y - 20), size);
    add(player);

    add(ball);
    add(topBound);
    add(leftBound);
    add(bottomBound);
    add(rightBound);
  }

  @override
  void onTapDown(TapDownInfo info) {
    player.initializeBallLine();
  }

  //find the Vector2 of where the thumb/cursor is and pass that to rotate ball line
  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.rotateBallLine(info.eventPosition.game);
  }
}

//Side of a brick
class Side extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;
  late double l;
  late double t;
  late double w;
  late double h;

  Side(double left, double top, double width, double height) {
    l = left;
    t = top;
    w = width;
    h = height;
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(position: Vector2(l, t), size: Vector2(w, h)));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(l, t, w, h), _paint);
  }
}

//Top of a brick
class Top extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;

  late double l;
  late double t;
  late double w;
  late double h;

  Top(double left, double top, double width, double height) {
    l = left;
    t = top;
    w = width;
    h = height;
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(position: Vector2(l, t), size: Vector2(w, h)));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(l, t, w, h), _paint);
  }
}

/** 
* TODO: When the ball hits the bottom save that location
  and reset all the balls to that location
*/
class Ball extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;
  Vector2 direction = Vector2(0, 0);
  bool canCollide = true;
  double tCollide = 0;
  Vector2 start = Vector2(0, 0);

  //Timer countDown = Timer(0.05);

  Ball() {
    start = position;
    direction = Vector2(15, -10);
  }
  //renders the block(Ball)
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(10, 0), 10, _paint);
  }

  //Hitbox for the ball
  //hitbox for the rectangle
  Future<void> onLoad() async {
    //add(CircleHitbox(radius: 10));
    add(RectangleHitbox(size: Vector2(10, 10)));
  }

  //Move the ball back and forth
  @override
  void update(double t) {
    position.add(direction);
    // countDown.update(t);
    // if (countDown.finished) {
    //   canCollide = true;
    // }
  }

  //Hits one of the borders

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    //Timer so that the ball doesnt collide more than once in too short of a time
    //countDown = Timer(0.02);

    if (other is Side && canCollide) {
      direction = Vector2(-direction.x, direction.y);
    } else if (other is Top && canCollide) {
      direction = Vector2(direction.x, -direction.y);
    }
    //canCollide = false;
  }

  //Balls dont speed up when hitting a wall or a brick

}
