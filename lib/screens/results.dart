import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/player.dart';

class ResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<GameState, _ViewModel>(
      converter: (Store<GameState> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          appBar: AppBar(
            title: const Text('Results'),
          ),
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Column(
      children: <Widget>[
        ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.players.length,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                child: Text(
                    'Player ${viewModel.players[position].playerIndex.toString()}'),
              );
            }),
        FlatButton(
          child: const Text('Back to menu'),
          onPressed: viewModel.onButtonClick,
        )
      ],
    );
  }
}

class _ViewModel {
  final List<Player> players;
  final Function() onButtonClick;

  _ViewModel(this.players, this.onButtonClick) {
    players.sort();
  }

  factory _ViewModel.create(Store<GameState> store) {
    return _ViewModel(store.state.players, () {
      store.dispatch(BackToMenuAction());
      store.dispatch(NavigateToAction.pop());
    });
  }
}
