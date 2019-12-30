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

import 'dart:ui';

import 'package:spacefl/game/game.dart';

class Star {
  final double xVariation = 0;
  final double minSpeedY = 2;

  Rect rect;
  double vX;
  double vY;
  double vYVariation;

  Star(Game game) {
    final rnd = game.state.random;

    // Random size
    double size = rnd.nextInt(2) + 1.0;

    // Position
    double x = rnd.nextDouble() * game.state.boardSize.width;
    double y = game.state.random.nextDouble() * game.state.boardSize.height;

    rect = Rect.fromLTWH(x, y, size, size);

    // Random Speed
    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    // Velocity
    vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5).round() * Game.VELOCITY_FACTOR_X;
    vY = (((rnd.nextDouble() * 1.5) + minSpeedY) * vYVariation).round() * Game.VELOCITY_FACTOR_Y;
  }

  void update(Game game) {
    double x = rect.left + vX;
    double y = rect.top + vY;

    if (y > game.state.boardSize.height) {
      _respawn(game);
      return;
    }

    rect = Rect.fromLTWH(x, y, rect.width, rect.height);
  }

  @override
  String toString() => 'Star @${rect.toString()}, vX=$vX, vY=$vY, vYVariation=$vYVariation';

  void _respawn(Game game) {
    final state = game.state;
    double x = state.random.nextDouble() * state.boardSize.width;
    double y = -rect.height;
    rect = Rect.fromLTWH(x, y, rect.width, rect.height);
  }
}