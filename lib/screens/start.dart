import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/routes.dart';

class StartPage extends StatelessWidget {
  static const Key offlineButtonKey = Key('OFFLINE_BUTTON_KEY');
  static const Key passwordInputFieldKey = Key('PASSWORD_INPUT_FIELD_KEY');

  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          appBar: AppBar(
            title: Text(viewModel.pageTitle),
          ),
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    if (!viewModel.isGameStarted) {
      return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                key: offlineButtonKey,
                color: Colors.green,
                child: const Text('PLAY OFFLINE'),
                onPressed: () {
                  if (viewModel.canBeStarted) {
                    viewModel.onPlayOffline(viewModel.numOfPlayers);
                  }
                },
              ),
              FlatButton(
                color: Colors.green,
                child: const Text('PLAY ONLINE'),
                onPressed: () {
                  if (viewModel.canBeStarted) {
                    viewModel.onPlayOnline();
                  }
                },
              ),
              const Text('Number of players: '),
              Container(
                padding: const EdgeInsets.only(left: 50), // ToDo: Fix this
                child: Center(
                    child: TextFormField(
                  expands: false,
                  initialValue: '2',
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: InputBorder.none,
                      hintText: 'Number of players'),
                  onChanged: (String numOfPlayersText) =>
                      viewModel.numOfPlayers = int.parse(numOfPlayersText),
                  autovalidate: true,
                  validator: (String numOfPlayersText) {
                    final int numOfPlayers = int.parse(numOfPlayersText);
                    if (numOfPlayers < GameState.minNumOfPlayers ||
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
    return Container(width: 0, height: 0);
  }
}

class _ViewModel {
  final String pageTitle;
  final bool isGameStarted; // ToDo: Probably not needed
  bool canBeStarted = true;
  int numOfPlayers = GameState.minNumOfPlayers;
  final Function(int numOfPlayers) onPlayOffline;
  final Function() onPlayOnline;

  _ViewModel(this.pageTitle, this.isGameStarted, this.onPlayOffline,
      this.onPlayOnline);

  factory _ViewModel.create(Store<GameStore> store) {
    return _ViewModel('Main menu', false, (int numOfPlayers) {
      store.dispatch(StartOfflineGameAction(numOfPlayers));
      store.dispatch(NavigateToAction.push(Routes.offlineGame));
    }, () {
      store.dispatch(NavigateToAction.push(Routes.rooms));
    });
  }
}
