import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

Widget createPokerButton(String title, Function onPressed, [Key key]) {
  return ButtonTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: FlatButton(
      color: burgundyButtonColor,
      child: AutoSizeText(
        title,
        style: const TextStyle(fontFamily: 'Casino'),
        maxLines: 1,
        key: key,
      ),
      onPressed: onPressed,
    ),
  );
}
