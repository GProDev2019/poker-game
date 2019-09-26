import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_logic/actions.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<GameState, _ViewModel>(
          converter: (Store<GameState> store) => _ViewModel.create(store),
          builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
              appBar: AppBar(
                title: Text(viewModel.pageTitle),
              ),
              body: _createWidget(viewModel)));

  Widget _createWidget(_ViewModel viewModel) {
    if (!viewModel.isGameStarted) {
      return Center(
          child: FlatButton(
        color: Colors.green,
        child: const Text('PLAY OFFLINE'),
        onPressed: () {
          viewModel.onPlayOffline();
        },
      ));
    }
    return Container(width: 0, height: 0);
  }
}

class _ViewModel {
  final String pageTitle;
  final bool isGameStarted;
  final Function() onPlayOffline;

  _ViewModel(this.pageTitle, this.isGameStarted, this.onPlayOffline);

  factory _ViewModel.create(Store<GameState> store) {
    return _ViewModel(
        'Main menu', false, () => store.dispatch(StartOfflineGameAction()));
  }
}
