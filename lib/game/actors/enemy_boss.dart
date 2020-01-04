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

class EnemyBoss {
  static const int maxValue = 99;
  static const int maxHits = 5;

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
  int hits = EnemyBoss.maxHits;


  EnemyBoss(Game game) : image = game.images.lookupImageWithIndex('enemyBoss', 5) {
    init(game);
  }

  void init(Game game) {
    final state = game.state;
    final rnd = state.random;
    final boardSize = state.boardSize;

    // Position
    x = rnd.nextDouble() * boardSize.width;
    y = -image.height.toDouble();

    // Value
    value = rnd.nextInt(maxValue) + 1;

    // Random Speed
    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    width = image.width.toDouble();
    height = image.height.toDouble();
    size = width > height ? width : height;
    radius = size * 0.5;

    // Velocity
    final firstQuarterWidth = boardSize.width * 0.25;
    final lastQuarterWidth = boardSize.width * 0.75;

    // TODO: This is the exact same code as in Enemy. Mixin?
    if (x < firstQuarterWidth) {
      vX = (rnd.nextDouble() * 0.5) * Game.velocityFactorX;
    } else if (x > lastQuarterWidth) {
      vX = -(rnd.nextDouble() * 0.5) * Game.velocityFactorX;
    } else {
      vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * Game.velocityFactorY;
    }
    vY = (((rnd.nextDouble() * 1.5) + minSpeedY) * vYVariation) * Game.velocityFactorY;

    // Rotation
    rot = math.atan2(vY, vX) - math.pi / 2;

    // Related to laser fire
    lastShotY = 0;

    // No of hits
    hits = EnemyBoss.maxHits;
  }

  void update(Game game) {
    x += vX;
    y += vY;

    // TODO: Check for hits
    int newHits = hits;

    if (newHits == 0) {
      // Blown up, sir!
    } else if (newHits != hits) {
      image = game.images.lookupImageWithIndex('enemyBoss', newHits);
    }

    hits = newHits;

    if (_isOffBoard(game.state.boardSize)) {
      game.state.destroyEnemyBoss(this);
    }
  }

  bool _isOffBoard(Size boardSize) => x < -size || x > boardSize.width + size || y > boardSize.height + size;
}
