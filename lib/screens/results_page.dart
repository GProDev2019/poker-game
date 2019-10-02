import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:redux/redux.dart';

import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_store/player.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:poker_game/utils/constants.dart';

class ResultsPage extends StatelessWidget {
  static const Key backToMenuButtonKey = Key('BACK_TO_MENU_BUTTON_KEY');
  @override
  Widget build(BuildContext context) => StoreConnector<GameStore, _ViewModel>(
      converter: (Store<GameStore> store) => _ViewModel.create(store),
      builder: (BuildContext context, _ViewModel viewModel) => Scaffold(
          backgroundColor: greenBackground,
          body: _createWidget(context, viewModel)));

  Widget _createWidget(BuildContext context, _ViewModel viewModel) {
    return SafeArea(
        child: Column(children: <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 50),
        height: MediaQuery.of(context).size.height / 6,
        child: AutoSizeText(
          'RESULTS',
          style: TextStyle(
              fontFamily: 'Casino3DFilledMarquee',
              fontSize: 70,
              color: goldFontColor),
          maxLines: 1,
          maxFontSize: 100,
        ),
      ),
      Expanded(
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            shrinkWrap: true,
            itemCount: viewModel.players.length,
            itemBuilder: (BuildContext context, int position) {
              final String handStrength = 'Hand type: ' +
                  viewModel.players[position].handStrength.handName
                      .toString()
                      .split('.')
                      .last;
              final List<PlayingCard> cards =
                  viewModel.players[position].hand.cards;
              return Card(
                  color: greenCardColor,
                  child: ListTile(
                      title: Text(
                        'Player ${viewModel.players[position].playerIndex.toString()}',
                        style: const TextStyle(fontFamily: 'Casino'),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            handStrength,
                            style: const TextStyle(
                                fontFamily: 'Casino',
                                fontStyle: FontStyle.italic),
                          ),
                          _createCards(cards)
                        ],
                      )));
            }),
      ),
      Container(
          child: ButtonTheme(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: FlatButton(
                key: backToMenuButtonKey,
                color: burgundyButtonColor,
                child: const AutoSizeText('Back to menu',
                    style: TextStyle(fontFamily: 'Casino')),
                disabledColor: Colors.grey,
                onPressed: viewModel.onButtonClick,
              )))
    ]));
  }

  Widget _createCards(List<PlayingCard> cards) {
    return Container(
      child: Row(
        children: List<Expanded>.generate(cards.length, (int i) {
          final PlayingCard card = cards[i];
          const EdgeInsets padding = EdgeInsets.all(5);
          return Expanded(
              child: FlatButton(
                  padding: padding, child: card.cardImage, onPressed: null));
        }),
      ),
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
      store.dispatch(NavigateToAction.pop(postNavigation: () {
        store.dispatch(
            BackToMenuAction()); // ToDo: This is not working as expected. Maybe async_redux will fix issue with null exceptions?
      }));
    });
  }
}
