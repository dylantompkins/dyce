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

import 'package:flame/timer.dart';
//import 'package:flame/components/timer_component.dart';

import 'package:dyce/balldestroyer/player.dart';

class BallDestroyer extends FlameGame
    with HasDraggables, HasCollisionDetection, TapDetector, PanDetector {
  late Ball ball;
  late Side leftBound;
  late Top topBound;
  late Side rightBound;
  late Bottom bottomBound;

  late Player player;

  bool inAimState = false;
  bool isInGame = false;
  Vector2 lastPos = Vector2(0, 0);

  Timer spawnBall = Timer(0.15, repeat: true);

  int ballCount = 0;
  int maxBalls = 20;

  @override
  Color backgroundColor() => Color.fromARGB(70, 0, 18, 85);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(Vector2(400, 600));

    ball = Ball(Vector2(0, 0))
      ..position = Vector2(size.x / 2, size.y - (size.y / 7))
      // ..width = 100
      // ..height = 30
      ..anchor = Anchor.center;

    //Adds the boundaries
    topBound = Top(0, 0, size.x, 15, true)
      ..position = Vector2(0, 0)
      // ..width = size.x
      // ..height = 10
      //..size = Vector2(size.x * 2, 15)
      ..anchor = Anchor.center;

    leftBound = Side(0, 10, 15, size.y, true)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    rightBound = Side(size.x - 15, 10, 15, size.y, true)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    bottomBound = Bottom(0, size.y - 1, size.x, 15)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    player = Player(Vector2(size.x / 2, size.y - 20), size);

    add(player);

    //add(ball);
    add(topBound);
    add(leftBound);
    add(bottomBound);
    add(rightBound);

    CircleComponent component = CircleComponent(
        radius: 10,
        position: Vector2(size.x / 2, size.y - 15),
        paint: Paint()..color = Color.fromARGB(255, 180, 17, 17));
    component.renderShape = true;
    add(component);

    //Hardcoded bricks
    Brick one = Brick(50, 50, 10)
      ..position = Vector2(200, 200)
      ..anchor = Anchor.center;
    add(one);

    Brick two = Brick(30, 30, 30)
      ..position = Vector2(100, 300)
      ..anchor = Anchor.center;
    add(two);

    Brick three = Brick(30, 30, 30)
      ..position = Vector2(200, 300)
      ..anchor = Anchor.center;
    add(three);

    Brick four = Brick(30, 30, 30)
      ..position = Vector2(250, 300)
      ..anchor = Anchor.center;
    add(four);

    Brick five = Brick(30, 30, 30)
      ..position = Vector2(150, 300)
      ..anchor = Anchor.center;
    add(five);

    Brick six = Brick(50, 50, 10)
      ..position = Vector2(140, 200)
      ..anchor = Anchor.center;
    add(six);

    Brick seven = Brick(30, 30, 5, Color.fromARGB(255, 255, 128, 0))
      ..position = Vector2(180, 260)
      ..anchor = Anchor.center;
    add(seven);

    Brick eight = Brick(225, 30, 20, Color.fromARGB(255, 138, 128, 128))
      ..position = Vector2(80, 100)
      ..anchor = Anchor.center;
    add(eight);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (ballCount <= maxBalls) {
      spawnBall.update(dt);
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (!isInGame) {
      player.initializeBallLine();
    }
  }

  //find the Vector2 of where the thumb/cursor is and pass that to rotate ball line
  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (!isInGame) {
      player.rotateBallLine(info.eventPosition.game);
    }
    //create the line of balls to aim here
  }

  @override
  void onPanEnd(DragEndInfo info) {
    if (!isInGame) {
      player.releaseBalls();
      double botScreenX = size.x / 2;
      double botScreenY = size.y - 15;

      double xVel = (player.lastStuff().x - botScreenX);
      double yVel = (player.lastStuff().y - (size.y - 15));

      spawnBall.onTick = () async {
        add(Ball(player.calculateSpeed((player.lastStuff().x - (size.x / 2)),
            (player.lastStuff().y - (size.y - 15)), 10))
          ..position = Vector2(size.x / 2, size.y - 15)
          ..anchor = Anchor.center);
        ballCount++;
      };

      spawnBall.start();
    }
    ballCount = 0;
  }
}

class Brick extends PositionComponent with CollisionCallbacks {
  late double w;
  late double h;
  int lives = 10;
  Paint _paint = Paint()..color = Colors.white;

  TextPaint text =
      TextPaint(style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)));

  Brick(double width, double height, int l, [Color color = Colors.white]) {
    w = width;
    h = height;
    lives = l;

    _paint.color = color;

    //dont
    Side middle = Side(-2, (h / 20), w + 2, h - (h / 20), false);
    add(middle);

    Top top = Top(0, -1, w - 0.75, (h / 20) + 1, false);
    add(top);

    Top bottom = Top(2, h / 2 - 2, w - 8, (h / 10), false);
    add(bottom);
  }

  //Hitbox for the ball
  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(position: Vector2(0, -1), size: Vector2(w, h + 20)));
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), _paint);
    text.render(canvas, "$lives", Vector2(w / 2, h / 2), anchor: Anchor.center);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ball) {
      lives--;
    }

    if (lives <= 0) {
      shouldRemove = true;
    }
  }
}

//Side of a brick
class Side extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;
  late double l;
  late double t;
  late double w;
  late double h;
  late bool show;
  Side(double left, double top, double width, double height, bool s) {
    l = left;
    t = top;
    w = width;
    h = height;
    show = s;
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(
        position: Vector2(l - 0.5, t), size: Vector2(w + 1, h)));
  }

  @override
  void render(Canvas canvas) {
    if (show) {
      canvas.drawRect(Rect.fromLTWH(l, t, w, h), _paint);
    }
  }
}

//Top of a brick
class Top extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Color.fromARGB(255, 255, 255, 255);

  late double l;
  late double t;
  late double w;
  late double h;
  late bool show;

  Top(double left, double top, double width, double height, bool s) {
    position = Vector2(left, top);
    l = left;
    t = top;
    w = width;
    h = height;
    show = s;
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(position: Vector2(l, t), size: Vector2(w, h + 10)));
  }

  @override
  void render(Canvas canvas) {
    if (show) {
      canvas.drawRect(Rect.fromLTWH(l, t, w, h), _paint);
    }
  }
}

class Bottom extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;

  late double l;
  late double t;
  late double w;
  late double h;

  Bottom(double left, double top, double width, double height) {
    l = left;
    t = top;
    w = width;
    h = height;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(l, t, w, h), _paint);
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(position: Vector2(l, t), size: Vector2(w, h)));
  }
}

/** 
* TODO: When the ball hits the bottom save that location
  and reset all the balls to that location
*/
class Ball extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Color.fromARGB(255, 180, 17, 17);
  Vector2 direction = Vector2(0, 0);
  bool canCollide = true;
  double tCollide = 0;
  Vector2 start = Vector2(0, 0);
  bool moving = true;
  Timer countDown = Timer(0.5);

  bool first = true;

  Ball(Vector2 dir) {
    start = position;
    direction = dir;
  }
  //renders the block(Ball)
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(5, 0), 5, _paint);
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
    countDown.update(t);

    if (countDown.finished) {
      if (moving) {
        position.add(direction);
      } else {
        //returns balls back to starting position
        if (position.x > 200) {
          position.add(Vector2(-10, 0));
        } else {
          position.add(Vector2(10, 0));
        }
        if (position.x > 180 && position.x < 220) {
          shouldRemove = true;
        }
      }
    }
  }

  //Hits one of the borders
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Side && canCollide) {
      direction = Vector2(-direction.x, direction.y);
    } else if (other is Top && canCollide) {
      direction = Vector2(direction.x, -direction.y);
    } else if (other is Bottom) {
      moving = false;
    }
    //canCollide = false;
  }
}
