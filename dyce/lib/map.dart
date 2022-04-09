import 'package:dyce/map_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dyce Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(35.301366049343784, -120.66240555707458),
          zoom: 17.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              MapIcon(
                  context: context,
                  myPoint:
                      LatLng(35.30138795147228, -120.6624430938508), // pilling
                  icon: Icons.gamepad),
              MapIcon(
                  context: context,
                  myPoint: LatLng(
                      35.29690002811058, -120.65347967357083), // our dorm
                  icon: Icons.soup_kitchen),
              MapIcon(
                context: context,
                myPoint: LatLng(35.30000698691031, -120.66505265584695),
                icon: Icons.money,
              )
            ],
          ),
        ],
      ),
    );
  }
}
