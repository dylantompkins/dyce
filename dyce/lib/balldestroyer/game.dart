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

import 'package:dyce/balldestroyer/ball.dart';

//HasDraggables screws up PanDetector
class BallDestroyer extends FlameGame with HasCollisionDetection, PanDetector {
  late Ball ball;
  late Side leftBound;
  late Top topBound;
  late Side rightBound;
  late Bottom bottomBound;

  late Player player;

  bool inAimState = false;
  bool isInGame = true;
  Vector2 lastPos = Vector2(0, 0);

  Timer spawnBall = Timer(0.15, repeat: true);

  final countdown = Timer(3);

  final goTime = Timer(6);

  double time = 3;

  int ballCount = 20;
  int maxBalls = 20;

  int bricksLeft = 11;

  List list = <Brick>[];

  List listOfBalls = <Ball>[];

  bool gameOver = false;

  bool go = false;
  bool showGo = false;

  late int finalTime;

  TextPaint textPaint = TextPaint(
      style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)));

  TextPaint goo = TextPaint(
      style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 0, 0, 0)));
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
      ..anchor = Anchor.topLeft;

    //Adds the boundaries
    topBound = Top(0, 0, size.x, 15, true)
      ..position = Vector2(0, 0)
      // ..width = size.x
      // ..height = 10
      //..size = Vector2(size.x * 2, 15)
      ..anchor = Anchor.topLeft;

    leftBound = Side()
      ..size = Vector2(15, size.y)
      ..position = Vector2(0, 0);
    //..anchor = Anchor.topLeft;

    rightBound = Side()
      ..position = Vector2(size.x - 15, 10)
      ..size = Vector2(15, size.y * 2)
      ..anchor = Anchor.topLeft;

    bottomBound = Bottom(0, size.y, size.x, 15)
      ..position = Vector2(0, 0)
      ..anchor = Anchor.center;

    player = Player(Vector2(size.x / 2, size.y - 20), size);

    add(player);

    add(ball);
    add(topBound);
    add(leftBound);
    add(bottomBound);
    add(rightBound);

    CircleComponent component = CircleComponent(
        radius: 10,
        position: Vector2(size.x / 2, size.y - 16),
        paint: Paint()..color = Color.fromARGB(255, 180, 17, 17));
    component.renderShape = true;
    add(component);

    //Hardcoded bricks
    Brick one = Brick(20)
      ..size = Vector2(50, 50)
      ..anchor = Anchor.topLeft
      ..position = Vector2(200, 200);

    add(one);
    list.add(one);
    Brick two = Brick(20)
      ..position = Vector2(100, 300)
      ..size = Vector2(30, 30)
      ..anchor = Anchor.topLeft;
    add(two);

    list.add(two);

    Brick three = Brick(20)
      ..size = Vector2(30, 30)
      ..position = Vector2(200, 300)
      ..anchor = Anchor.topLeft;
    add(three);

    list.add(three);

    Brick four = Brick(20)
      ..size = Vector2(30, 30)
      ..position = Vector2(250, 300)
      ..anchor = Anchor.topLeft;
    add(four);

    list.add(four);

    Brick five = Brick(20)
      ..size = Vector2(30, 30)
      ..position = Vector2(150, 300)
      ..anchor = Anchor.topLeft;
    add(five);
    list.add(five);

    Brick six = Brick(10)
      ..size = Vector2(50, 50)
      ..position = Vector2(140, 200)
      ..anchor = Anchor.topLeft;
    add(six);

    list.add(six);

    Brick seven = Brick(5, Color.fromARGB(255, 255, 128, 0))
      ..size = Vector2(30, 30)
      ..position = Vector2(180, 260)
      ..anchor = Anchor.topLeft;
    add(seven);

    list.add(seven);
    Brick eight = Brick(20, Color.fromARGB(255, 138, 128, 128))
      ..size = Vector2(225, 30)
      ..position = Vector2(100, 150)
      ..anchor = Anchor.topLeft;
    add(eight);

    list.add(eight);
    Brick nine = Brick(20, Color.fromARGB(255, 138, 128, 128))
      ..position = Vector2(120, 50)
      ..size = Vector2(150, 50)
      ..anchor = Anchor.topLeft;
    add(nine);
    list.add(nine);

    Brick ten = Brick(2, Color.fromARGB(255, 94, 2, 2))
      ..position = Vector2(30, 420)
      ..size = Vector2(70, 40)
      ..anchor = Anchor.topLeft;
    add(ten);
    list.add(ten);

    Brick eleve = Brick(2, Color.fromARGB(255, 94, 2, 2))
      ..position = Vector2(290, 420)
      ..size = Vector2(70, 40)
      ..anchor = Anchor.topLeft;
    add(eleve);
    list.add(eleve);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    textPaint.render(
        canvas, "Time: ${time.round().abs()}", Vector2(size.x / 2, 0));
    if (showGo) {
      goo.render(canvas, "GO!!!!", Vector2(size.x / 2, size.y / 2 + 50));
    }
    if (gameOver) {
      goo.render(canvas, "GAME OVER", Vector2(size.x / 2, size.y / 2 + 50));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    countdown.update(dt);
    goTime.update(dt);

    if (countdown.finished && !go) {
      go = true;
      isInGame = false;
      time = 0;
      showGo = true;
    }
    if (goTime.finished) {
      showGo = false;
    }
    if (!gameOver) {
      time -= dt;
    }

    for (int i = 0; i < list.length; i++) {
      if (list[i].life() <= 0) {
        list.removeAt(i);
      }
    }

    for (int i = 0; i < listOfBalls.length; i++) {
      if (listOfBalls[i].movement() == false) {
        listOfBalls.removeAt(i);
      }
    }

    if (ballCount > 0) {
      spawnBall.update(dt);
    } else {
      ballCount = 20;
      spawnBall.stop();
    }

    if (listOfBalls.isEmpty) {
      isInGame = false;
    } else {
      isInGame = true;
    }

    if (list.length <= 0) {
      finalTime = time.round();
      gameOver = true;
    }
  }

  @override
  void onPanStart(DragStartInfo info) {
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
      double botScreenX = (size.x / 2) + 10;
      double botScreenY = size.y - 6;

      double xVel = (player.lastStuff().x - botScreenX);
      double yVel = (player.lastStuff().y - (size.y - 15));

      spawnBall.onTick = () {
        Ball ball = Ball(player.calculateSpeed(
            (player.lastStuff().x - (size.x / 2)),
            (player.lastStuff().y - (size.y - 15)),
            5))
          ..position = Vector2((size.x / 2), size.y - 20)
          ..anchor = Anchor.topLeft
          ..size.x = 10
          ..size.y = 10;
        add(ball);
        listOfBalls.add(ball);
        ballCount--;
      };
      spawnBall.start();
    }
  }
}

class Brick extends PositionComponent with CollisionCallbacks {
  int lives = 10;
  Paint _paint = Paint()..color = Colors.white;
  bool dead = false;
  TextPaint text =
      TextPaint(style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)));

  Brick(int l, [Color color = Colors.white]) {
    lives = l;

    _paint.color = color;

    // Side middle = Side();
    // add(middle);

    // Top top = Top(0, -0.5, w, h / 20, true);
    // add(top);

    // Top bottom = Top(0, h / 2, w, h / 100, false);
    // add(bottom);
  }

  //Hitbox for the ball
  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  int life() {
    return lives;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _paint);

    text.render(canvas, "$lives", Vector2(size.x / 2, size.y / 2),
        anchor: Anchor.center);
  }

  void hit() {
    lives--;
    if (lives <= 0) {
      shouldRemove = true;
    }
  }
  //commented this out for testing the hitbox
  // @override
  // void onCollisionStart(
  //     Set<Vector2> intersectionPoints, PositionComponent other) {
  //   if (other is Ball) {
  //     lives--;
  //   }

  //   if (lives <= 0) {
  //     shouldRemove = true;
  //   }
  // }
}

//Side of a brick
class Side extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _paint);
    //canvas.drawRect( Rect.LFRB(Offset(size.x / 2, size.y / 2), width: size.x, height: size.y) );
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
    add(RectangleHitbox(
        position: Vector2(l, t), size: Vector2(w, h + 10), priority: 1));
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
