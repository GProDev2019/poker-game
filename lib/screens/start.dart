import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_logic/actions.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<GameState, _ViewModel>(
      converter: (Store<GameState> store) => _ViewModel.create(store),
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
                color: Colors.green,
                child: const Text('PLAY OFFLINE'),
                onPressed: () {
                  if (viewModel.canBeStarted) {
                    viewModel.onPlayOffline();
                    Navigator.pushNamed(context, '/offlineGame');
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
                    onChanged: (String numOfPlayersText) => viewModel
                        .onNumberOfPlayersChanged(int.parse(numOfPlayersText)),
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
                  ),
                ),
              ),
            ]),
      );
    }
    return Container(width: 0, height: 0);
  }
}

class _ViewModel {
  final String pageTitle;
  final bool isGameStarted;
  bool canBeStarted = true;
  final Function() onPlayOffline;
  final Function(int numOfPlayers) onNumberOfPlayersChanged;

  _ViewModel(this.pageTitle, this.isGameStarted, this.onPlayOffline,
      this.onNumberOfPlayersChanged);

  factory _ViewModel.create(Store<GameState> store) {
    return _ViewModel(
        'Main menu',
        false,
        () => store.dispatch(StartOfflineGameAction()),
        (int numOfPlayers) =>
            store.dispatch(ChangeNumberOfPlayersAction(numOfPlayers)));
  }
}
