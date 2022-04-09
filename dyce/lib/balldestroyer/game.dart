import 'package:flame/components.dart';
import 'package:flutter/material.dart';

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

class BallDestroyer extends FlameGame
    with HasDraggables, HasCollisionDetection, TapDetector {
  late Player player;
  late Bounds bounds;

  @override
  Color backgroundColor() => Color.fromARGB(70, 0, 18, 85);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(Vector2(400, 600));

    player = Player()
      ..position = Vector2(size.x / 2, size.y - (size.y / 7))
      ..width = 100
      ..height = 30
      ..anchor = Anchor.center;

    bounds = Bounds(size)..position = Vector2(0, 0);

    add(player);
    add(bounds);
  }
}

//Boundaries around the entire screen
class Bounds extends PositionComponent {
  final _paint = Paint()..color = Colors.white;
  late Vector2 screenSize;

  Bounds(Vector2 stuff) {
    screenSize = stuff;
  }

  @override
  void render(Canvas canvas) {
    //top border
    canvas.drawRect(Rect.fromLTWH(0, 0, screenSize.x, 10), _paint);

    //left border
    canvas.drawRect(Rect.fromLTWH(0, 10, 10, screenSize.y), _paint);

    canvas.drawRect(
        Rect.fromLTWH(0, screenSize.y - 10, screenSize.x, 10), _paint);

    canvas.drawRect(
        Rect.fromLTWH(screenSize.x - 10, 10, 10, screenSize.y), _paint);
  }
}

//Where the balls originate from
class Player extends PositionComponent {
  final _paint = Paint()..color = Colors.white;

  //renders the block(player)
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(0, 0), 10, _paint);
  }
}
