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

  @override
  Color backgroundColor() => Color.fromARGB(70, 0, 0, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(Vector2(400, 600));

    player = Bird()
      ..size = Vector2(20, 20)
      ..position = Vector2(size.x / 3.5, size.y / 2);
    add(player);

    one = Pipe(30, size.y / 2)
      ..size = Vector2(30, size.y / 2)
      ..position = Vector2(size.x / 2, 0);

    add(one);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onTap() {
    //print("working");
    player.move();
  }
}

class Pipe extends PositionComponent with CollisionCallbacks {
  double wi = 0;
  double len = 0;
  Pipe(double w, double l) {
    wi = w;
    len = l;
    Bound top = Bound(0, 0, w, l, true);
    add(top);

    Bound bottom = Bound(0, 0, w, l, true);
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
    add(RectangleHitbox(position: Vector2(l, t), size: Vector2(w, h + 10)));
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
  double time = 3;

  bool jumped = false;

  void move() {
    position.add(Vector2(0, jump));
    jumped = true;
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
  void update(double dt) {
    time += dt;
    //print(time);
    position.add(Vector2(0, time / 2.1 * time / 2.1));
    if (jumped) {
      time = 3;
      jumped = false;
    }
  }
}
