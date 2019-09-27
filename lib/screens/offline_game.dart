import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/playing_card.dart';

class OfflineGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => StoreConnector<GameState, _ViewModel>(
      converter: (Store<GameState> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
            appBar: AppBar(title: Text(viewModel.pageTitle)),
            body: _createWidget(context, viewModel),
          ));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _createCards(viewModel),
          _createReplaceCardsButton(viewModel)
        ],
      ),
    );
  }

  Widget _createCards(_ViewModel viewModel) {
    return Container(
      child: Row(
        children: List<Expanded>.generate(Hand.maxNumOfCards, (int i) {
          return Expanded(
              child: FlatButton(
            color: viewModel.getCardColor(i),
            child: const Text('card'),
            onPressed: () {
              print('Card $i pressed...');
            },
          ));
        }),
      ),
    );
  }

  Widget _createReplaceCardsButton(_ViewModel viewModel) {
    return Container(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FlatButton(
          child: const Text('Replace Cards'),
          onPressed: () => viewModel.replaceCards,
        ));
  }
}

class _ViewModel {
  final int currentPlayer;
  final Function() replaceCards;
  final Hand playerCards;
  final String pageTitle;

  _ViewModel(this.currentPlayer, this.replaceCards, this.playerCards)
      : pageTitle = 'Player $currentPlayer';

  factory _ViewModel.create(Store<GameState> store) {
    return _ViewModel(
        store.state.currentPlayer,
        () => store.dispatch(ReplaceCardsAction),
        store.state.players[store.state.currentPlayer].hand);
  }

  Color getCardColor(int index) {
    final PlayingCard card = playerCards.cards[index];
    if (<CardColor>[CardColor.diamonds, CardColor.hearts]
        .contains(card.color)) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
