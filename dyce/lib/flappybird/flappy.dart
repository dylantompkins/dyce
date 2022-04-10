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

  @override
  Color backgroundColor() => Color.fromARGB(70, 0, 0, 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(Vector2(400, 600));

    player = Bird()
      ..size = Vector2(20, 20)
      ..position = Vector2(size.x / 3, size.y / 2);
    add(player);
  }

  @override
  void onTap() {
    player.move();
  }
}

class Bird extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Colors.white;

  double jump = 4;

  void move() {
    position.y += jump;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double dt) {
    position.add(Vector2(0, 3));
  }
}
