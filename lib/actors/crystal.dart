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

import 'package:spacefl/game_state.dart';

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

  Crystal(this.image) {
    init();
  }

  // TODO: Get WIDTH and other constants to this method
  void init() {
//    // Position
//    x = rnd.nextDouble() * WIDTH;
//    y = -image.getHeight();
//    rot = 0;
//
//    // Random Speed
//    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;
//
//    width = image.getWidth();
//    height = image.getHeight();
//    size = width > height ? width : height;
//    radius = size * 0.5;
//    imgCenterX = image.getWidth() * 0.5;
//    imgCenterY = image.getHeight() * 0.5;
//
//    // Velocity
//    if (x < FIRST_QUARTER_WIDTH) {
//      vX = rnd.nextDouble() * VELOCITY_FACTOR_X;
//    } else if (x > LAST_QUARTER_WIDTH) {
//      vX = -rnd.nextDouble() * VELOCITY_FACTOR_X;
//    } else {
//      vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * VELOCITY_FACTOR_X;
//    }
//    vY = (((rnd.nextDouble() * 1.5) + minSpeedY) * vYVariation) * VELOCITY_FACTOR_Y;
//    vR = (((rnd.nextDouble()) * 0.5) + minRotationR) * VELOCITY_FACTOR_R;
//    rotateRight = rnd.nextBoolean();
  }

  // TODO: Get WIDTH and other constants to this method
  void update(GameState state) {
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

    // Respawn crystal
//    if (x < -size || x - radius > WIDTH || y - height > HEIGHT) {
//      state.crystalsToRemove.add(this);
//    }
  }
}
