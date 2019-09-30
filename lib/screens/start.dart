import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/routes.dart';
import 'package:poker_game/utils/constants.dart';

class StartPage extends StatelessWidget {
  static const Key offlineButtonKey = Key('OFFLINE_BUTTON_KEY');
  static const Key numOfPlayersInputFieldKey = Key('PASSWORD_INPUT_FIELD_KEY');

  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          backgroundColor: greenBackground,
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              'POKER GAME',
              style: TextStyle(
                  fontFamily: 'Casino', fontSize: 70, color: goldFontColor),
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
                    ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                          key: offlineButtonKey,
                          color: burgundyButtonColor,
                          child: const AutoSizeText(
                            'PLAY OFFLINE',
                            style: TextStyle(fontFamily: 'Casino'),
                            maxLines: 1,
                          ),
                          onPressed: () {
                            if (viewModel.canBeStarted) {
                              viewModel.onPlayOffline(viewModel.numOfPlayers);
                            }
                          },
                        )),
                    ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: FlatButton(
                          color: burgundyButtonColor,
                          child: const AutoSizeText(
                            'PLAY ONLINE',
                            style: TextStyle(fontFamily: 'Casino'),
                            maxLines: 1,
                          ),
                          onPressed: () {
                            if (viewModel.canBeStarted) {
                              viewModel.onPlayOnline();
                            }
                          },
                        )),
                  ],
                )),
            const Text('Number of players: '),
            Container(
              padding: const EdgeInsets.only(left: 50), // ToDo: Fix this
              child: Center(
                  child: TextFormField(
                key: numOfPlayersInputFieldKey,
                expands: false,
                initialValue: '2',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    hintText: 'Number of players'),
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
              )),
            ),
          ]),
    );
  }
}

class _ViewModel {
  final String pageTitle;
  bool canBeStarted = true;
  int numOfPlayers = GameState.minNumOfPlayers;
  final Function(int numOfPlayers) onPlayOffline;
  final Function() onPlayOnline;

  _ViewModel(this.pageTitle, this.onPlayOffline, this.onPlayOnline);

  factory _ViewModel.create(Store<GameStore> store) {
    return _ViewModel('Main menu', (int numOfPlayers) {
      store.dispatch(StartOfflineGameAction(numOfPlayers));
      store.dispatch(NavigateToAction.push(Routes.game));
    }, () {
      store.dispatch(NavigateToAction.push(Routes.rooms));
    });
  }
}
