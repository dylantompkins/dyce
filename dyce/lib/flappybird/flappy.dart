import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flutter/gestures.dart';
import 'dart:math';

//Need to hide it so Draggable doesnt get flagged2
import 'package:flutter/material.dart' hide Draggable;
import 'package:flame/game.dart';

//Needed to lock phone into portrait mode
import 'package:flutter/services.dart';

class FlappyGame extends FlameGame
    with HasCollisionDetection, TapDetector, PanDetector {
  late Bird player;
  late Pipe one;

  late Pipe two;
  late Pipe three;

  late Pipe four;

  int finalScore = 0;

  String message = "Score:";

  Random rng = Random();
  @override
  Color backgroundColor() => Color.fromARGB(70, 0, 0, 0);
  TextPaint color = TextPaint(
      style: TextStyle(
    color: Color.fromARGB(255, 77, 62, 62),
    fontSize: 30.0,
    fontFamily: 'RobotoMono',
  ));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(Vector2(400, 600));

    player = Bird()
      ..size = Vector2(20, 20)
      ..position = Vector2(size.x / 5, size.y / 2);
    add(player);

    one = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
      ..size = Vector2(30, size.y / 2)
      ..position = Vector2(size.x - 10, 0);

    add(one);

    two = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
      ..size = Vector2(30, size.y / 2)
      ..position = Vector2(size.x + 100, 0);

    add(two);

    three = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
      ..size = Vector2(30, size.y / 2)
      ..position = Vector2(size.x + 200, 0);

    add(three);

    four = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
      ..size = Vector2(30, size.y / 2)
      ..position = Vector2(size.x + 300, 0);

    add(four);

    add(ScreenHitbox());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    color.render(canvas, "$message $finalScore", Vector2(10, 10));
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (player.gameOver) {
      one.gameOver = true;
      two.gameOver = true;

      three.gameOver = true;
      four.gameOver = true;
      message = "tap to restart";
    }

    if (one.done) {
      remove(one);
      finalScore++;
      one = Pipe(30, size.y / 2, (rng.nextInt(50 + 49) - 49))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x - 10, 0);
      add(one);
    }

    if (two.done) {
      remove(two);
      finalScore++;
      two = Pipe(30, size.y / 2, (rng.nextInt(50 + 49) - 49))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x - 10, 0);
      add(two);
    }

    if (three.done) {
      remove(three);
      finalScore++;
      three = Pipe(30, size.y / 2, (rng.nextInt(50 + 49) - 49))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x - 10, 0);
      add(three);
    }

    if (four.done) {
      remove(four);
      finalScore++;
      four = Pipe(30, size.y / 2, (rng.nextInt(50 + 49) - 49))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x - 10, 0);
      add(four);
    }
  }

  @override
  void onTap() {
    //print("working");
    if (player.gameOver) {
      finalScore = 0;
      player.position.y = size.y / 2;
      player.gameOver = false;
      one.gameOver = false;
      two.gameOver = false;

      three.gameOver = false;
      four.gameOver = false;

      remove(one);
      remove(two);
      remove(three);
      remove(four);
      one = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x - 10, 0);

      add(one);

      two = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x + 100, 0);

      add(two);

      three = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x + 200, 0);

      add(three);

      four = Pipe(30, size.y / 2, (rng.nextInt(100 + 99) - 99))
        ..size = Vector2(30, size.y / 2)
        ..position = Vector2(size.x + 300, 0);

      add(four);
      player.gameOver = false;

      message = "Score:";
    }

    if (!player.gameOver) {
      player.move();
    }
  }
}

class Pipe extends PositionComponent with CollisionCallbacks {
  double wi = 0;
  double len = 0;

  bool gameOver = false;
  bool done = false;

  Pipe(double w, double l, int offset) {
    wi = w;
    len = l + offset;
    gameOver = false;
    Bound top = Bound(0, 0.0, w, len, true);
    add(top);

    Bound bottom = Bound(0, len - 30, w, len * 2, true);
    add(bottom);
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(position: position, size: size));
  }

  @override
  void update(double dt) {
    if (position.x < -20) {
      done = true;
    } else {
      done = false;
    }
    if (!gameOver) {
      position.add(Vector2(-3, 0));
    }
  }
}

class Bound extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Color.fromARGB(255, 255, 255, 255);

  late double l;
  late double t;
  late double w;
  late double h;
  late bool show;

  Bound(double left, double top, double width, double height, bool s) {
    position = Vector2(left, top);
    l = left;
    t = top;
    w = width;
    h = height;
    show = s;
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(position: Vector2(l, t), size: Vector2(w, h)));
  }

  @override
  void render(Canvas canvas) {
    if (show) {
      canvas.drawRect(Rect.fromLTWH(l, t, w, h), _paint);
    }
  }
}

class Bird extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;

  double jump = -75;
  double time = 4;

  bool jumped = false;

  bool gameOver = false;

  void move() {
    if (!gameOver) {
      position.add(Vector2(0, jump));
      jumped = true;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(size: size));
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is ScreenHitbox || other is Bound) {
      gameOver = true;
    }
  }

  @override
  void update(double dt) {
    time += dt;
    if (!gameOver) {
      position.add(Vector2(0, time / 2.1 * time / 2.1));
    }
    if (jumped) {
      time = 4;
      jumped = false;
    }
  }
}
