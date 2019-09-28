import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      builder: (BuildContext context, _ViewModel viewModel) {
        if (viewModel.gameEnded) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }
        return Scaffold(
          appBar: AppBar(title: Text(viewModel.pageTitle)),
          body: _createWidget(context, viewModel),
        );
      });

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _createCards(viewModel),
          _createReplaceCardsButton(viewModel),
          _createEndTurnButton(viewModel)
        ],
      ),
    );
  }

  Widget _createCards(_ViewModel viewModel) {
    return Container(
      child: Row(
        children: List<Expanded>.generate(Hand.maxNumOfCards, (int i) {
          final PlayingCard card = viewModel.playerCards.cards[i];
          final String cardRank = card.rank.toString().split('.').last;
          return Expanded(
              child: FlatButton(
                  color: viewModel.getCardColor(i),
                  child: Column(
                    children: <Widget>[
                      Text(card.selectedForReplace.toString(),
                          style: TextStyle(color: Colors.white)),
                      Text(cardRank, style: TextStyle(color: Colors.white))
                    ],
                  ),
                  onPressed: () => viewModel.onToggleSelectedCard(card)));
        }),
      ),
    );
  }

  Widget _createReplaceCardsButton(_ViewModel viewModel) {
    return Container(
        child: FlatButton(
      child: const Text('Replace Cards'),
      color: Colors.blue,
      disabledColor: Colors.grey,
      onPressed: viewModel.onReplaceCards,
    ));
  }

  Widget _createEndTurnButton(_ViewModel viewModel) {
    return Container(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: FlatButton(
          child: const Text('End Turn'),
          color: Colors.blue,
          onPressed: viewModel.onEndTurn,
        ));
  }
}

class _ViewModel {
  final int currentPlayer;
  final bool gameEnded;
  final Function() onReplaceCards;
  final Function() onEndTurn;
  final Function(PlayingCard card) onToggleSelectedCard;
  final Hand playerCards;
  final String pageTitle;

  _ViewModel(this.currentPlayer, this.gameEnded, this.onReplaceCards,
      this.onEndTurn, this.onToggleSelectedCard, this.playerCards)
      : pageTitle = 'Player $currentPlayer';

  factory _ViewModel.create(Store<GameState> store) {
    final int currentPlayer = store.state.currentPlayer;
    final bool replacedCards = store.state.players[currentPlayer].replacedCards;
    return _ViewModel(
        currentPlayer,
        store.state.gameEnded,
        replacedCards ? null : () => store.dispatch(ReplaceCardsAction()),
        () => store.dispatch(EndTurnAction()),
        (PlayingCard card) => store.dispatch(ToggleSelectedCardAction(card)),
        store.state.players[currentPlayer].hand);
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
