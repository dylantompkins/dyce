import 'package:dyce/details.dart';
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
    required this.gameDet,
    required this.locationDet,
  }) : super(key: key);

  final LatLng currLoc;
  final LatLng gameLoc;
  final FlameGame fg;
  final BuildContext context;
  final Details locationDet;
  final Details gameDet;

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
                    return Scaffold(
                      appBar: AppBar(),
                      body: GameWidget(
                        game: widget.fg,
                      ),
                    );
                  },
                ),
              );
            },
      child: Text(text),
    );
  }

  Expanded _buildInfo(Details d) {
    return Expanded(
      child: Column(
        children: [
          const Spacer(),
          Expanded(
            child: Image(image: d.image),
            flex: 2,
          ),
          Text(
            d.name,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
            ),
          ),
          Text(d.description),
          const Spacer(),
        ],
      ),
      flex: 5,
    );
  }

  Row _buildInfoRow() {
    return Row(
      children: [
        const Spacer(),
        _buildInfo(widget.locationDet),
        const Spacer(),
        _buildInfo(widget.gameDet),
        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameDet.name),
        actions: [_buildPlayButton()],
      ),
      body: _buildInfoRow(),
    );
  }
}
