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

import 'package:spacefl/game/actors/rocket.dart';
import 'package:spacefl/game/actors/space_ship.dart';
import 'package:spacefl/game/actors/torpedo.dart';
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
    final state = game.state;
    final boardSize = state.boardSize;

    x += vX;
    y += vY;

    if (_isOffBoard(boardSize)) {
      _init(game);
    }

    if (_shouldFireOn(state.spaceShip)) {
      if (y - lastShotY > 15) {
        state.spawnEnemyTorpedo(game, x, y, vX, vY);
        lastShotY = y;
      }
    }

    for (Torpedo t in state.torpedoes) {
      if (isHitCircleCircle(t.x, t.y, t.radius, x, y, radius)) {
        state.spawnAsteroidExplosion(game, x, y, vX, vY, 0.5);
        state.destroyTorpedo(t);
        _init(game);
      }
    }

    for (Rocket r in state.rockets) {
      if (isHitCircleCircle(r.x, r.y, r.radius, x, y, radius)) {
        state.spawnRocketExplosion(game, x, y, vX, vY, 0.5);
        state.destroyRocket(r);
        _init(game);
      }
    }
  }

  void _init(Game game) {
    final rnd = game.state.random;
    final boardSize = game.state.boardSize;

    image = game.images.randomEnemyImage;

    // Position
    x = rnd.nextDouble() * boardSize.width;
    y = -image.height.toDouble();

    // Value
    value = rnd.nextInt(MAX_VALUE) + 1;

    // Random Speed
    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    width = image.width.toDouble();
    height = image.height.toDouble();
    size = width > height ? width : height;
    radius = size * 0.5;

    // Velocity
    // TODO: This is the exact same code as in EnemyBoss. Mixin?
    if (x < boardSize.width * 0.25) {
      vX = (rnd.nextDouble() * 0.5) * Game.velocityFactorX;
    } else if (x > boardSize.width * 0.75) {
      vX = -(rnd.nextDouble() * 0.5) * Game.velocityFactorX;
    } else {
      vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * Game.velocityFactorX;
    }
    vY = (((rnd.nextDouble() * 1.5) + minSpeedY) * vYVariation) * Game.velocityFactorY;

    // Rotation
    rot = math.atan2(vY, vX) - math.pi / 2;

    // Related to laser fire
    lastShotY = 0;
  }

  bool _isOffBoard(Size boardSize) => x < -size || x > boardSize.width + size || y > boardSize.height + size;

  bool _shouldFireOn(SpaceShip spaceShip) =>
      x > spaceShip.x - Game.enemyFireSensitivity && x < spaceShip.x + Game.enemyFireSensitivity;
}
