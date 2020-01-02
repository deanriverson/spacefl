/*
 * Copyright (c) 2019 by Gerrit Grunwald
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spacefl/game/game.dart';
import 'package:spacefl/widgets/game_board.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: RawKeyboardListener(
        autofocus: true,
        onKey: _createGameKeyHandler(Game.instance()),
        focusNode: FocusNode(),
        child: GameBoard(),
      ),
    );
  }
}

final _keyDownMap = <LogicalKeyboardKey, GameEvent>{
  LogicalKeyboardKey.arrowUp: GameEvent.accelerateUp,
  LogicalKeyboardKey.arrowDown: GameEvent.accelerateDown,
  LogicalKeyboardKey.arrowLeft: GameEvent.accelerateLeft,
  LogicalKeyboardKey.arrowRight: GameEvent.accelerateRight,
  LogicalKeyboardKey.keyS: GameEvent.activateShield,
};

final _keyUpMap = <LogicalKeyboardKey, GameEvent>{
  LogicalKeyboardKey.arrowUp: GameEvent.decelerateUp,
  LogicalKeyboardKey.arrowDown: GameEvent.decelerateDown,
  LogicalKeyboardKey.arrowLeft: GameEvent.decelerateLeft,
  LogicalKeyboardKey.arrowRight: GameEvent.decelerateRight,
};

Function _createGameKeyHandler(Game game) {
  return (RawKeyEvent e) {
    final keyMap = e is RawKeyDownEvent ? _keyDownMap : _keyUpMap;
    _sendEventToGame(keyMap, e.logicalKey, game);
  };
}

void _sendEventToGame(Map<LogicalKeyboardKey, GameEvent> keyMap, LogicalKeyboardKey key, Game game) {
  final gameEvent = keyMap[key];
  if (gameEvent != null) {
    game.handleEvent(gameEvent);
  }
}
