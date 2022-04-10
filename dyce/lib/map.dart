import 'package:dyce/game_details.dart';
import 'package:dyce/map_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location location = Location();

  Future<LocationData> _getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        throw Error();
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Error();
      }
    }

    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dyce Map'),
        actions: [
          ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<LocationData>(
        future: _getLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            LatLng currLoc = LatLng(
              snapshot.data!.latitude!,
              snapshot.data!.longitude!,
            );

            final Map<String, LatLng> locations = {
              'pilling': LatLng(35.30013245239185, -120.66216538773018),
              'dorms': LatLng(35.29690002811058, -120.65347967357083),
              'ocob': LatLng(35.30000698691031, -120.66505265584695),
            };

            return FlutterMap(
              options: MapOptions(
                center: LatLng(35.301366049343784, -120.66240555707458),
                zoom: 17.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    MapIcon(
                      context: context,
                      myPoint: locations['pilling']!,
                      icon: Icons.gamepad,
                      toPush: GameDetails(
                        currLoc: currLoc,
                        gameLoc: locations['pilling']!,
                      ),
                    ),
                    MapIcon(
                      context: context,
                      myPoint: locations['dorms']!,
                      icon: Icons.soup_kitchen,
                      toPush: GameDetails(
                        currLoc: currLoc,
                        gameLoc: locations['dorms']!,
                      ),
                    ),
                    MapIcon(
                        context: context,
                        myPoint: locations['ocob']!,
                        icon: Icons.money,
                        toPush: GameDetails(
                          currLoc: currLoc,
                          gameLoc: locations['ocob']!,
                        )),
                    MapIcon(
                      context: context,
                      myPoint: currLoc,
                      icon: Icons.person,
                    )
                  ],
                ),
              ],
            );
          } else {
            return Container(
              child: const CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },
      ),
    );
  }
}
