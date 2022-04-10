import 'package:dyce/secret.dart';
import 'package:postgres/postgres.dart';

class Database {
  late PostgreSQLConnection connection;

  Database() {
    connection = PostgreSQLConnection(
      "free-tier9.gcp-us-west2.cockroachlabs.cloud",
      26257,
      "dyce-leaderboard-361.defaultdb",
      username: "dylan",
      password: Secret.cockroachPass,
    );
    _openConnection();
  }

  void _openConnection() async {
    await connection.open();
  }

  //TODO player name can only be 50 chars
  void pushScore({
    required String table,
    required String player,
    required int score,
  }) async {
    if (player.length > 50) {
      player = player.substring(0, 51);
    }

    PostgreSQLResult isPresent = await connection.query(
      "SELECT EXISTS(SELECT 1 FROM @table WHERE player='@player')",
      substitutionValues: {
        'table': table,
        'player': player,
      },
    );

    if (isPresent.first.toString() == 'true') {
      connection.query(
        "UPDATE @table SET score = @score WHERE player = '@player'",
        substitutionValues: {
          'table': table,
          'player': player,
          'score': score,
        },
      );
    } else {
      connection.query(
        "INSERT INTO @table(player, score) VALUES ('@player', @score)",
        substitutionValues: {
          'table': table,
          'player': player,
          'score': score,
        },
      );
    }
  }
}
