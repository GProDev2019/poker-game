import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/card_info.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/routes.dart';
import 'package:poker_game/utils/constants.dart';

class GamePage extends StatelessWidget {
  static const Key replaceCardsButtonKey = Key('REPLACE_CARDS_BUTTON_KEY');
  static const String cardsKeyString = 'CARDS_KEY_';
  static const Key endTurnButtonKey = Key('END_TURN_BUTTON_KEY');
  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) {
        return Scaffold(
          //appBar: AppBar(title: Text(viewModel.pageTitle)), // ToDo: Consider back arrow that resets the game
          backgroundColor: greenBackground,
          body: _createWidget(context, viewModel),
        );
      });

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 150),
          child: AutoSizeText(
            '${viewModel.pageTitle}',
            style: TextStyle(
                fontFamily: 'Casino3DFilledMarquee',
                fontSize: 50,
                color: goldFontColor),
            maxLines: 1,
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _createCards(viewModel),
              _createButtons(viewModel)
            ],
          ),
        )
      ],
    );
  }

  Widget _createButtons(_ViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: FlatButton(
                color: burgundyButtonColor,
                child: const AutoSizeText('Replace Cards',
                    style: TextStyle(fontFamily: 'Casino')),
                disabledColor: Colors.grey,
                onPressed: viewModel.onReplaceCards,
              )),
          ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: FlatButton(
                color: burgundyButtonColor,
                child: const AutoSizeText('End Turn',
                    style: TextStyle(fontFamily: 'Casino')),
                disabledColor: Colors.grey,
                onPressed: viewModel.onEndTurn,
              ))
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
                  key: Key(cardsKeyString + i.toString()),
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
}

class _ViewModel {
  final int currentPlayer;
  final Function() onReplaceCards;
  final Function() onEndTurn;
  final Function(PlayingCard card) onToggleSelectedCard;
  final Hand playerCards;
  final String pageTitle;

  _ViewModel(this.currentPlayer, this.onReplaceCards, this.onEndTurn,
      this.onToggleSelectedCard, this.playerCards)
      : pageTitle = 'Player $currentPlayer';

  factory _ViewModel.create(Store<GameStore> store) {
    final int currentPlayer = Dispatcher.getCurrentPlayer(store.state);
    final bool replacedCards = Dispatcher.getGameState(store.state)
        .players[currentPlayer]
        .replacedCards;

    return _ViewModel(
        currentPlayer,
        replacedCards
            ? null
            : () {
                store.dispatch(ReplaceCardsAction());
                if (store.state.localStore.isOnlineGame()) {
                  store.dispatch(UpdateRoomAction(
                      Dispatcher.getCurrentOnlineRoom(store.state)));
                }
              },
        store.state.localStore.onlineTurnEnded
            ? null
            : () {
                if (!Dispatcher.getGameState(store.state).gameEnded) {
                  store.dispatch(EndTurnAction());
                  if (store.state.localStore.isOnlineGame()) {
                    store.dispatch(UpdateRoomAction(
                        Dispatcher.getCurrentOnlineRoom(store.state)));
                  }
                }
                if (Dispatcher.getGameState(store.state).gameEnded) {
                  store.dispatch(NavigateToAction.replace(Routes.results));
                }
              }, (PlayingCard card) {
      store.dispatch(ToggleSelectedCardAction(card));
      if (store.state.localStore.isOnlineGame()) {
        store.dispatch(
            UpdateRoomAction(Dispatcher.getCurrentOnlineRoom(store.state)));
      }
    }, Dispatcher.getGameState(store.state).players[currentPlayer].hand);
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
