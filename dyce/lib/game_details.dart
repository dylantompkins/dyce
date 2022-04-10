import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class GameDetails extends StatefulWidget {
  const GameDetails({
    Key? key,
    required this.currLoc,
    required this.gameLoc,
    required this.fg,
    required this.context,
  }) : super(key: key);

  final LatLng currLoc;
  final LatLng gameLoc;
  final FlameGame fg;
  final BuildContext context;

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {
  final double coordDelta = 0.0005;

  bool _isClose() {
    return absoluteError(widget.currLoc.latitude, widget.gameLoc.latitude) <
            coordDelta &&
        absoluteError(widget.currLoc.longitude, widget.gameLoc.longitude) <
            coordDelta;
  }

  ElevatedButton _buildPlayButton() {
    String text;
    bool playable;

    if (_isClose()) {
      text = 'Play';
      playable = true;
    } else {
      text = 'Too Far Away';
      playable = false;
    }

    return ElevatedButton(
      onPressed: !playable
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return GameWidget(
                      game: widget.fg,
                    );
                  },
                ),
              );
            },
      child: Text(text),
    );
  }

  Expanded _buildInfo(ImageProvider image, String title, String details) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Image(image: image),
          ),
          Text(title),
          Text(details),
        ],
      ),
      flex: 5,
    );
  }

  Row _buildInfoRow() {
    return Row(
      children: [
        const Spacer(),
        _buildInfo(
          Image.asset("images/pilling.jpg").image,
          "Pilling",
          "Where the computer nerds live.",
        ),
        const Spacer(),
        _buildInfo(
          Image.asset("images/pilling.jpg").image,
          "Breakout",
          "The classic ball breaking game",
        ),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ball Breaker"),
        actions: [_buildPlayButton()],
      ),
      body: _buildInfoRow(),
    );
  }
}
