import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/player.dart';

class ResultsPage extends StatelessWidget {
  static const Key backToMenuButton = Key('BACK_TO_MENU_BUTTON_KEY');
  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
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
              return ListTile(
                title: Card(
                  child: Text(
                      'Player ${viewModel.players[position].playerIndex.toString()}'),
                ),
                subtitle: Text(
                    '${viewModel.players[position].handStrength.handName.toString()}\n'
                    '${viewModel.players[position].handStrength.cardRanks.toString()}'),
              );
            }),
        FlatButton(
          key: backToMenuButton,
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

  factory _ViewModel.create(Store<GameStore> store) {
    return _ViewModel(Dispatcher.getGameState(store.state).players, () {
      store.dispatch(BackToMenuAction());
      store.dispatch(NavigateToAction.pop());
    });
  }
}
