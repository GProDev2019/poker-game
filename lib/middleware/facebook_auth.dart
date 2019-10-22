import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:redux/redux.dart';

Future<void> onFbLogin(Store<GameStore> store) async {
  final FacebookLogin facebookLogin = FacebookLogin();
  final FacebookLoginResult result =
      await facebookLogin.logIn(<String>['email']);

  final String token = result.accessToken.token;
  final http.Response graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  final dynamic profile = jsonDecode(graphResponse.body);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      store.dispatch(SetPlayerNameAction(profile['name']));
      break;
    case FacebookLoginStatus.cancelledByUser:
      break;
    case FacebookLoginStatus.error:
      break;
  }
}
