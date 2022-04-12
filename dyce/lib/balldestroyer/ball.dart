import 'package:dyce/balldestroyer/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:math';
import 'package:flame/collisions.dart';

/** 
* TODO: When the ball hits the bottom save that location
  and reset all the balls to that location
*/
class Ball extends PositionComponent with CollisionCallbacks {
  final _paint = Paint()..color = Color.fromARGB(255, 180, 17, 17);
  final black = Paint()..color = Color.fromARGB(255, 0, 0, 0);
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
    canvas.drawCircle(Offset(size.x / 2, 0), size.x / 2, _paint);
  }

  //Hitbox for the ball
  //hitbox for the rectangle
  Future<void> onLoad() async {
    //add(CircleHitbox(position: Vector2(0, 0), radius: size.x / 2));
    add(CircleHitbox());
    //add(RectangleHitbox());
  }

  //Move the ball back and forth
  @override
  void update(double t) {
    countDown.update(t);

    if (countDown.finished) {
      if (moving && canCollide) {
        position.add(direction);
      } else if (!moving) {
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

  bool movement() {
    return moving;
  }

  //Hits one of the borders
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Brick) {


      //first way to get hitbox
      Vector2 point = intersectionPoints.elementAt(0);
      bool xTopCheck = point.x <= other.x + other.width && point.x >= other.x;
      bool yTopCheck = other.y + other.height <= point.y || point.y <= other.y;

      bool xSideCheck = point.x >= other.x + other.width || point.x <= other.x;
      bool ySideCheck = other.y + height <= point.y && other.y <= point.y;


      //second way
      //top collision
      // bool xTopCheck = position.x + width <= other.x + other.width &&
      //     position.x + width >= other.x;
      // bool yTopCheck =
      //     other.y + other.height <= position.y || position.y <= other.y;
      // print(yTopCheck);

      // bool xSideCheck =
      //     position.x >= other.x + other.width || position.x - width <= other.x;
      // bool ySideCheck =
      //     other.y + height <= position.y && other.y <= position.y + height;

      if (xTopCheck && yTopCheck) {
        direction = Vector2(direction.x, -direction.y);
        position.add(direction);
      } else if (xSideCheck && ySideCheck) {
        direction = Vector2(-direction.x, direction.y);
        position.add(direction);
      }

      //third way
      /**
      //vars are tested and work
      var playerHalfW = width / 2;
      var playerHalfH = height / 2;

      var enemyHalfW = other.width / 2;
      var enemyHalfH = other.height / 2;

      var playerCenterX = position.x + width / 2;
      var playerCenterY = position.y + height / 2;

      var enemyCenterX = other.x + other.width / 2;
      var enemyCenterY = other.y + other.height / 2;

      // Calculate the distance between centers
      var diffX = playerCenterX - enemyCenterX;
      var diffY = playerCenterY - enemyCenterY;
      var minXDist = playerHalfW + enemyHalfW;
      var minYDist = playerHalfH + enemyHalfH;

      // if the first condition is true return first value else
      var depthX = diffX > 0 ? minXDist - diffX : -minXDist - diffX;
      var depthY = diffY > 0 ? minYDist - diffY : -minYDist - diffY;

      if (depthX != 0 && depthY != 0) {
        //print(depthX.abs() - depthY.abs());
        if (depthX.abs() < depthY.abs()) {
          // Collision along the X axis. React accordingly
          if (depthX > 0) {
            direction = Vector2(-direction.x, direction.y);
            position.x += direction.x * 2;
          } else {
            // Right side collision
            direction = Vector2(-direction.x, direction.y);
            position.x += direction.x * 2;
          }
        } else {
          // Collision along the Y axis.
          if (depthY > 0) {
            // Top side collision
            direction = Vector2(direction.x, -direction.y);
            position.y += direction.y * 2;
          } else {
            // Bottom side collision
            direction = Vector2(direction.x, -direction.y);
            position.y += direction.y * 2;
          }
        }
      }
      */
    } else if (other is Side && canCollide) {
      canCollide = false;

      direction = Vector2(-direction.x, direction.y);
    } else if (other is Top && canCollide) {
      canCollide = false;
      direction = Vector2(direction.x, -direction.y);
    } else if (other is Bottom) {
      moving = false;
    }
    canCollide = true;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    canCollide = true;
  }
}
