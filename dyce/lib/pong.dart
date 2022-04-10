//import 'dart:html';

//import 'dart:html';

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

/**
 * Notes:
 * From Xcode, you can change the Build Configuration of the Run Schema easily. 
 * To do this, click on Runner -> Edit Scheme, then go in the Run tab, choose "Release" 
 * in the Build Configuration drop down menu. To install the application, run the configuration again.
 * 
 * Run app from the phone when disconnected
 */

//with is for mixins
class SimplePongGame extends FlameGame
    with HasDraggables, HasCollisionDetection, TapDetector {
  //late is final but defers the creation to when they are first read
  late Player player;
  late AI opponent;
  late Ball ball;

  @override
  Color backgroundColor() => Color.fromARGB(70, 12, 44, 187);

  @override
  Future<void> onLoad() async {
    //Always call `await super.onLoad()` as the first instruction of your custom `onLoad` method.
    await super.onLoad();

    // var player = Player();
    // player.position = size / 2;
    // player.width = 50;
    // player.height = 100;
    // player.anchor = Anchor.center;

    //size = ;

    camera.viewport = FixedResolutionViewport(Vector2(400, 600));
    
    player = Player()
      //`size` is a `Vector2` variable from the game class and it holds the current dimension of the game area, where `x` is the horizontal dimension, or the width, and `y` the vertical dimension, or the height.
      ..position = Vector2(size.x / 2, size.y - (size.y / 7))
      ..width = 100
      ..height = 30
      ..anchor = Anchor.center;

    ball = Ball(size)
      //`size` is a `Vector2` variable from the game class and it holds the current dimension of the game area, where `x` is the horizontal dimension, or the width, and `y` the vertical dimension, or the height.
      //use size.x to get the x size of the canvas and size.y to get the y size
      ..position = size / 2
      ..width = 20
      ..height = 20
      ..anchor = Anchor.center;

    opponent = AI(ball)
      //`size` is a `Vector2` variable from the game class and it holds the current dimension of the game area, where `x` is the horizontal dimension, or the width, and `y` the vertical dimension, or the height.
      //use size.x to get the x size of the canvas and size.y to get the y size
      ..position = Vector2(size.x / 2, size.y / 7)
      ..width = 100
      ..height = 30
      ..anchor = Anchor.center;
    /*
        .. are cascades
        same as var player = Player();
        player.position = size/2;
        player.width = 50;
        etc......
        player,
      */

    add(player);
    add(ball);
    add(opponent);
    add(ScreenHitbox());
  }

  // @override
  // void onPanUpdate(DragUpdateInfo info) {
  //   player.move(info.delta.game);
  // }

  //Player taps to move the block
  // @override
  // bool onTapDown(TapDownInfo info) {
  //   // print("Player tap down on ${info.eventPosition.game}");

  //   //get x position
  //   //print("${info.eventPosition.game.x}");
  //   double half = size.x / 2;

  //   //if the player is tapping the top of the screen then move upward
  //   if (info.eventPosition.game.x < half) {
  //     player.move(Vector2(-20, 0));
  //     //vice versa
  //   } else if (info.eventPosition.game.x > half) {
  //     player.move(Vector2(20, 0));
  //   }

  //   return true;
  // }

}

class Ball extends PositionComponent with CollisionCallbacks {
  static final _paint = Paint()..color = Colors.white;

  Random rng = Random();
  static Vector2 direction = Vector2(0, 0);

  //gets the screenSize from the gameClass
  late Vector2 screen;

  Ball(Vector2 size) {
    screen = size;

    direction =
        Vector2(rng.nextInt(5) + 1.toDouble(), rng.nextInt(5) + 1.toDouble());
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(size: size));
  }

  //renders the ball
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  @override
  void update(double t) {
    position.add(direction);
    print(screen.x);
    if (position.y > screen.y) {
      position = screen / 2;
    }
  }

  //will run with anything with a hitbox
  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    //Hits right side
    if (other is ScreenHitbox) {
      direction = Vector2(-direction.x, direction.y);
    } else if (other is Player) {
      direction = Vector2(direction.x, -direction.y);
    } else if (other is AI) {
      direction = Vector2(direction.x, -direction.y);
    }
  }

  //Will run with anything with a hitbox
  @override
  void onCollisionEnd(PositionComponent other) {}
}

class AI extends PositionComponent with CollisionCallbacks {
  static final _paint = Paint()..color = Color.fromARGB(255, 185, 100, 100);
  Ball stuff = Ball(Vector2(0, 0));

  AI(Ball b) {
    stuff = b;
  }
  //renders the enemy
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(size: size));
  }

  @override
  void update(double t) {
    move();
  }

  void move() {
    position.setFrom(Vector2(stuff.position.x, position.y));
  }
}

class Player extends PositionComponent with CollisionCallbacks, Draggable {
  //color of the player's block
  static final _paint = Paint()..color = Colors.white;

  static bool colliding = false;
  static bool canMoveLeft = true;
  static bool canMoveRight = true;

  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  @override
  bool onDragStart(DragStartInfo info) {
    dragDeltaPosition = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (parent is! SimplePongGame) {
      return true;
    }
    final dragDeltaPosition = this.dragDeltaPosition;
    if (dragDeltaPosition == null) {
      return false;
    }
    double ogPos = position.x;
    double newX = info.eventPosition.game.x - dragDeltaPosition.x;
    // if (newX > size.x / 2 && canMoveLeft) {
    //   position.setFrom(Vector2(newX, position.y));
    // }
    if (canMoveRight && newX > ogPos) {
      position.setFrom(Vector2(newX, position.y));
    } else if (canMoveLeft && newX < ogPos) {
      position.setFrom(Vector2(newX, position.y));
    }

    return false;
  }

  @override
  bool onDragEnd(DragEndInfo _) {
    dragDeltaPosition = null;
    return false;
  }

  //will run with anything with a hitbox
  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    if (other is ScreenHitbox && position.x > size.x) {
      canMoveRight = false;
    } else if (other is ScreenHitbox && position.x < size.x) {
      canMoveLeft = false;
    }
  }

  //Will run with anything with a hitbox
  @override
  void onCollisionEnd(PositionComponent other) {
    canMoveLeft = true;
    canMoveRight = true;
  }

  //renders the block(player)
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  //hitbox for the rectangle
  Future<void> onLoad() async {
    add(RectangleHitbox(size: size));
  }

  // //Moves block up and down depending on if the block is touching the top or bottom of the screen
  // void move(Vector2 delta) {
  //   if (canMoveRight && delta.x > 0) {
  //     position.add(delta);
  //   } else if (canMoveLeft && delta.x < 0) {
  //     position.add(delta);
  //   }
  // }
}

void main() {
  final myGame = SimplePongGame();

  //Locks the phone into portait mode
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(GameWidget(game: myGame));
}
