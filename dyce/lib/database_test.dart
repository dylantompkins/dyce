import 'package:dyce/firestore.dart';
import 'package:flutter/material.dart';

class DatabaseTest extends StatefulWidget {
  const DatabaseTest({Key? key}) : super(key: key);

  @override
  State<DatabaseTest> createState() => _DatabaseTestState();
}

class _DatabaseTestState extends State<DatabaseTest> {
  String player = "none";
  int score = 0;
  Database db = Database();
  String res = 'None';

  void _pushInput() {
    // db.pushScore(table: 'pong', player: player, score: score);
    db.pushScore(player: player, score: score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("Player"),
          TextField(
            onChanged: (value) {
              player = value;
            },
          ),
          const Text("Score"),
          TextField(
            onChanged: (value) {
              score = int.parse(value);
            },
          ),
          IconButton(
            onPressed: _pushInput,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
