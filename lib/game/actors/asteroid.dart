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

class Asteroid {
  static const int MAX_VALUE = 10;

  final double xVariation = 1.0;
  final double minSpeedY = 1.0;
  final double minRotationR = 0.005;

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
    vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * Game.VELOCITY_FACTOR_X;
    vY = (((rnd.nextDouble() * 1.5) + minSpeedY * 1 / scale) * vYVariation) * Game.VELOCITY_FACTOR_Y;
    vR = (((rnd.nextDouble()) * 0.01) + minRotationR) * Game.VELOCITY_FACTOR_R;
    rotateRight = rnd.nextBool();
  }

  void update(Game game) {
    x += vX;
    y += vY;

    // Respawn asteroid
    final boardSize = game.state.boardSize;
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
  }
}
