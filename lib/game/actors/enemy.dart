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

import 'dart:math' as math;
import 'dart:ui';

import 'package:spacefl/game/game.dart';
import 'package:spacefl/game/math_utils.dart';

class Enemy {
  static const int MAX_VALUE = 49;

  final double xVariation = 1;
  final double minSpeedY = 3;

  Image image;
  double x;
  double y;
  double rot;
  double width;
  double height;
  double size;
  double radius;
  double vX;
  double vY;
  double vYVariation;
  int value;
  double lastShotY;

  Enemy(Game game) {
    _init(game);
  }

  void update(Game game) {
    x += vX;
    y += vY;

    // Respawn Enemy
    final boardSize = game.state.boardSize;
    if (x < -size || x > boardSize.width + size || y > boardSize.height + size) {
      _init(game);
    }
  }

  void _init(Game game) {
    final rnd = game.state.random;
    final boardSize = game.state.boardSize;

    image = game.images.enemyImages[rnd.nextInt(game.images.enemyImages.length)];

    // Position
    x = rnd.nextDouble() * boardSize.width;
    y = -image.height.toDouble();

    // Value
    value = rnd.nextInt(MAX_VALUE) + 1;

    // Random Speed
    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    width  = image.width.toDouble();
    height = image.height.toDouble();
    size   = width > height ? width : height;
    radius = size * 0.5;

    // Velocity
    if (x < boardSize.width * 0.25) {
      vX = (rnd.nextDouble() * 0.5) * Game.VELOCITY_FACTOR_X;
    } else if (x > boardSize.width * 0.75) {
      vX = -(rnd.nextDouble() * 0.5) * Game.VELOCITY_FACTOR_X;
    } else {
      vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * Game.VELOCITY_FACTOR_X;
    }
    vY = (((rnd.nextDouble() * 1.5) + minSpeedY) * vYVariation) * Game.VELOCITY_FACTOR_Y;

    // Rotation
    rot = radToDeg(math.atan2(vY, vX)) - 90;

    // Related to laser fire
    lastShotY = 0;
  }
}
