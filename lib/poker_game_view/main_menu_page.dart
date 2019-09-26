import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:poker_game/poker_game_store/poker_game_state.dart';
import 'package:poker_game/poker_game_logic/actions.dart';
import 'package:redux/redux.dart';

class MainMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<PokerGameState, _ViewModel>(
          converter: (Store<PokerGameState> store) => _ViewModel.create(store),
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

  factory _ViewModel.create(Store<PokerGameState> store) {
    return _ViewModel(
        'Main menu', false, () => store.dispatch(StartOfflineGameAction()));
  }
}
