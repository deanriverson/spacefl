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

import 'package:spacefl/game/actors/rocket.dart';
import 'package:spacefl/game/actors/torpedo.dart';
import 'package:spacefl/game/game.dart';
import 'package:spacefl/game/math_utils.dart';

class Asteroid {
  static const int MAX_VALUE = 10;

  final double xVariation = 2.0;
  final double minSpeedY = 2.0;
  final double minRotationR = 0.1;

  Image image;
  double x;
  double y;
  double width;
  double height;
  double size;
  double imgCenterX;
  double imgCenterY;
  double radius;
  double cX;
  double cY;
  double rot;
  double vX;
  double vY;
  double vR;
  bool rotateRight;
  double scale;
  double vYVariation;
  int value;
  int hits;

  Asteroid(Game game) {
    init(game);
  }

  void init(Game game) {
    final rnd = game.state.random;
    final boardSize = game.state.boardSize;
    final asteroidImages = game.images.asteroidImages;

    image = asteroidImages[game.state.random.nextInt(asteroidImages.length)];

    // Position
    x = rnd.nextDouble() * boardSize.width;
    y = -image.height.toDouble();
    rot = 0;

    // Random Size
    scale = (rnd.nextDouble() * 0.6) + 0.2;

    // No of hits (0.2 - 0.8)
    hits = (scale * 5.0).toInt();

    // Value
    value = (1 / scale * MAX_VALUE).toInt();

    // Random Speed
    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    width = image.width * scale;
    height = image.height * scale;
    size = width > height ? width : height;
    radius = size * 0.5;
    imgCenterX = image.width * 0.5;
    imgCenterY = image.height * 0.5;

    // Velocity
    vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * Game.velocityFactorX;
    vY = (((rnd.nextDouble() * 1.5) + minSpeedY * 1 / scale) * vYVariation) * Game.velocityFactorY;
    vR = (((rnd.nextDouble()) * 0.5) + minRotationR) * Game.velocityFactorR;
    rotateRight = rnd.nextBool();
  }

  void update(Game game) {
    final state = game.state;
    final boardSize = state.boardSize;

    x += vX;
    y += vY;

    // Respawn asteroid
    if (x < -(2*size) || x - radius > boardSize.width || y - height > boardSize.height) {
      init(game);
    }

    cX = x + imgCenterX;
    cY = y + imgCenterY;

    if (rotateRight) {
      rot += vR;
      if (rot > 360) {
        rot = 0;
      }
    } else {
      rot -= vR;
      if (rot < 0) {
        rot = 360;
      }
    }

    for (Torpedo t in state.torpedoes) {
      if (isHitCircleCircle(t.x, t.y, t.radius, cX, cY, radius)) {
        --hits;
        if (hits == 0) {
          state.spawnAsteroidExplosion(game, cX, cY, vX, vY, scale);
          state.destroyTorpedo(t);
          init(game);
        }
      }
    }

    for (Rocket r in state.rockets) {
      if (isHitCircleCircle(r.x, r.y, r.radius, cX, cY, radius)) {
        --hits;
        if (hits == 0) {
          state.spawnRocketExplosion(game, cX, cY, vX, vY, scale);
          state.destroyRocket(r);
          init(game);
        }
      }
    }
  }
}
