import 'package:json_annotation/json_annotation.dart';
import 'package:poker_game/middleware/room.dart';
import 'deck.dart';
import 'player.dart';

part 'game_state.g.dart';

enum HandOutStrategy { oneByOneCard, allCardsAtOnce }

@JsonSerializable()
class GameState {
  Deck deck = Deck.initial();
  List<Player> players = <Player>[];
  int currentPlayer = 0;
  int numOfPlayers = 0;
  HandOutStrategy handOutStrategy = HandOutStrategy.oneByOneCard;
  bool gameEnded = false;
  static const int minNumOfPlayers = 2;
  static const int maxNumOfPlayers = 5;

  GameState();

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);

  Map<String, dynamic> toJson() => _$GameStateToJson(this);
}
