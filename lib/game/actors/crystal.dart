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

class Crystal {
  final math.Random rnd = new math.Random();
  final double xVariation = 2;
  final double minSpeedY = 2;
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
  double vYVariation;

  Crystal(Game game) {
    init(game);
  }

  void init(Game game) {
    final rnd = game.state.random;
    final boardSize = game.state.boardSize;

    image = game.images.lookupImage('crystal');

    // Position
    x = rnd.nextDouble() * boardSize.width;
    y = -image.height.toDouble();
    rot = 0;

    // Random Speed
    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    width = image.width.toDouble();
    height = image.height.toDouble();
    size = width > height ? width : height;
    radius = size * 0.5;
    imgCenterX = image.width * 0.5;
    imgCenterY = image.height * 0.5;

    // Velocity
    if (x < boardSize.width * 0.25) {
      vX = rnd.nextDouble() * Game.velocityFactorX;
    } else if (x > boardSize.width * 0.75) {
      vX = -rnd.nextDouble() * Game.velocityFactorX;
    } else {
      vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * Game.velocityFactorX;
    }
    vY = (((rnd.nextDouble() * 1.5) + minSpeedY) * vYVariation) * Game.velocityFactorY;
    vR = (((rnd.nextDouble()) * 0.5) + minRotationR) * Game.velocityFactorR;
    rotateRight = rnd.nextBool();
  }

  void update(Game game) {
    final boardSize = game.state.boardSize;

    x += vX;
    y += vY;

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

    // Remove crystal
    if (x < -size || x - radius > boardSize.width || y - height > boardSize.height) {
      game.state.crystalsToRemove.add(this);
    }
  }

  @override
  String toString() => 'Crystal@($x, $y)';
}
