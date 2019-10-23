import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/utils/widgets.dart';
import 'package:redux/redux.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/routes.dart';
import 'package:poker_game/utils/constants.dart';

class StartPage extends StatelessWidget {
  static const Key offlineButtonKey = Key('OFFLINE_BUTTON_KEY');
  static const Key numOfPlayersInputFieldKey =
      Key('NUM_OF_PLAYERS_INPUT_FIELD_KEY');
  static const Key startGameButtonKey = Key('START_GAME_BUTTON_KEY');

  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          backgroundColor: greenBackground,
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    final Function() onPlayOffline = () {
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              _numberOfPlayersDialog(context, viewModel));
    };
    final Function() onPlayOnline = () {
      if (viewModel.canBeStarted) {
        viewModel.onPlayOnline();
      }
    };

    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const AutoSizeText(
              'POKER GAME',
              style: TextStyle(
                  fontFamily: 'Casino', fontSize: 60, color: goldFontColor),
              maxFontSize: 100,
              maxLines: 1,
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        100), // ToDo: check if resize of screen does not break anything
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    createPokerButton(
                        'PLAY OFFLINE', onPlayOffline, offlineButtonKey),
                    createPokerButton('PLAY ONLINE', onPlayOnline)
                  ],
                )),
          ]),
    );
  }

  AlertDialog _numberOfPlayersDialog(
      BuildContext context, _ViewModel viewModel) {
    return AlertDialog(
      title: const Text(
        'Number of players:',
        textAlign: TextAlign.center,
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              expands: false,
              initialValue: '2',
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  // ToDo: Maybe add errorStyle
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: 'Number of players',
                  errorText: ' ',
                  errorMaxLines: 2),
              onChanged: (String numOfPlayersText) =>
                  viewModel.numOfPlayers = int.tryParse(numOfPlayersText),
              autovalidate: true,
              validator: (String numOfPlayersText) {
                final int numOfPlayers = int.tryParse(numOfPlayersText);
                if (numOfPlayers == null ||
                    numOfPlayers < GameState.minNumOfPlayers ||
                    GameState.maxNumOfPlayers < numOfPlayers) {
                  viewModel.canBeStarted = false;
                  return 'Number of players should be between 2 and 5!';
                }
                viewModel.canBeStarted = true;
                return null;
              },
            ),
            FlatButton(
              color: burgundyButtonColor,
              child: const Text('Ok'),
              onPressed: () {
                if (viewModel.canBeStarted) {
                  viewModel.playersNames = List<String>(viewModel.numOfPlayers);
                  for (int index = 0;
                      index < viewModel.playersNames.length;
                      ++index) {
                    viewModel.playersNames[index] =
                        'Player ' + index.toString();
                  }
                  Navigator.pop(context);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _playersNamesDialog(context, viewModel));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  AlertDialog _playersNamesDialog(BuildContext context, _ViewModel viewModel) {
    return AlertDialog(
      title: const Text(
        "Player's names:",
        textAlign: TextAlign.center,
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  shrinkWrap: true,
                  itemCount: viewModel.numOfPlayers,
                  itemBuilder: (BuildContext context, int position) {
                    return TextFormField(
                        textAlign: TextAlign.center,
                        expands: false,
                        initialValue: viewModel.playersNames[position],
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            errorText: ' ',
                            errorMaxLines: 2),
                        onChanged: (String playerName) =>
                            viewModel.playersNames[position] = playerName,
                        autovalidate: true,
                        validator: (String playerName) {
                          if (playerName.isEmpty) {
                            return "Player's name cannot be empty!";
                          }
                          return null;
                        });
                  }),
            ),
            FlatButton(
              color: burgundyButtonColor,
              child: const Text('Start Game'),
              onPressed: () {
                if (viewModel.playersNames
                    .every((String playerName) => playerName.isNotEmpty)) {
                  Navigator.pop(context);
                  viewModel.onPlayOffline(
                      viewModel.numOfPlayers, viewModel.playersNames);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

class _ViewModel {
  final String pageTitle;
  bool canBeStarted = true;
  int numOfPlayers = GameState.minNumOfPlayers;
  final Function(int numOfPlayers, List<String> playersNames) onPlayOffline;
  final Function() onPlayOnline;
  List<String> playersNames;

  _ViewModel(this.pageTitle, this.onPlayOffline, this.onPlayOnline);

  factory _ViewModel.create(Store<GameStore> store) {
    final Function onPlayOffline =
        (int numOfPlayers, List<String> playersNames) {
      store.dispatch(StartOfflineGameAction(numOfPlayers, playersNames));
      store.dispatch(NavigateToAction.push(Routes.game));
    };
    final Function onPlayOnline = () {
      store.dispatch(NavigateToAction.push(Routes.rooms));
    };

    return _ViewModel('Main menu', onPlayOffline, onPlayOnline);
  }
}
