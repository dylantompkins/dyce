import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  CollectionReference pong = FirebaseFirestore.instance.collection('pong');

  void pushScore({required String player, required int score}) {
    Map<String, dynamic> map = Map();
    map.update(
      'player',
      (value) => player,
      ifAbsent: () {},
    );
    map.update(
      'score',
      (value) => score,
      ifAbsent: () {},
    );
    pong.add(map);
    pong.where('player', isEqualTo: 'brandon');
    pong.get();
  }
}
