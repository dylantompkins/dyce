import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class MapIcon extends StatefulWidget {
  const MapIcon({Key? key, required this.fg}) : super(key: key);

  final FlameGame fg;

  @override
  State<MapIcon> createState() => _MapIconState();
}

class _MapIconState extends State<MapIcon> {
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
