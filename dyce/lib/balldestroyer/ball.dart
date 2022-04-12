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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // if (other is Brick) {
    //   //top collision
    //   bool xCheck = position.x + width > other.x + other.width &&
    //       position.x + width > other.x;
    //   bool yCheck =
    //       other.y > position.y + height && other.y - (height + 10) < position.y;

    //   if (xCheck && yCheck) {
    //     print("working");
    //   }
    // } else
    if (other is Side && canCollide) {
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
