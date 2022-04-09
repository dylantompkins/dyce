import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapIcon extends Marker {
  final LatLng myPoint;
  final IconData icon;
  final Widget? toPush;
  final BuildContext context;

  MapIcon(
      {required this.context,
      required this.myPoint,
      required this.icon,
      this.toPush})
      : super(
          width: 80.0,
          height: 80.0,
          point: myPoint,
          builder: (ctx) => IconButton(
            icon: Stack(
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.black,
                  size: IconTheme.of(context).size! + 15,
                ),
                Icon(
                  icon,
                  color: Theme.of(context).backgroundColor,
                ),
                Icon(
                  Icons.circle_outlined,
                  color: Theme.of(context).backgroundColor,
                  size: IconTheme.of(context).size! + 15,
                ),
              ],
              alignment: Alignment.center,
            ),
            onPressed: toPush == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return toPush;
                        },
                      ),
                    );
                  },
          ),
        );
}
