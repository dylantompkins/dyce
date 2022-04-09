import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameIcon extends StatefulWidget {
  const GameIcon({Key? key, required this.fg}) : super(key: key);

  final FlameGame fg;

  @override
  State<GameIcon> createState() => _GameIconState();
}

class _GameIconState extends State<GameIcon> {
  @override
  Widget build(BuildContext context) {
    void _pushGame() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return Expanded(
              child: GameWidget(
                game: widget.fg,
              ),
            );
          },
        ),
      );
    }

    return IconButton(
      onPressed: _pushGame,
      icon: const Icon(Icons.games_rounded),
    );
  }
}
