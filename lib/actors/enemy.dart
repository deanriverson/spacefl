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

class Enemy {
  static const int MAX_VALUE = 49;

  final Image image;
  final math.Random rnd = new math.Random();
  final double xVariation = 1;
  final double minSpeedY = 3;

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

  Enemy(this.image) {
    init();
  }

  // TODO: Get WIDTH and other constants to this method
  void init() {
//    // Position
//    x = rnd.nextDouble() * WIDTH;
//    y = -image.getHeight();
//
//    // Value
//    value = rnd.nextInt(MAX_VALUE) + 1;
//
//    // Random Speed
//    vYVariation = (rnd.nextDouble() * 0.5) + 0.2;
//
//    width  = image.getWidth();
//    height = image.getHeight();
//    size   = width > height ? width : height;
//    radius = size * 0.5;
//
//    // Velocity
//    if (x < FIRST_QUARTER_WIDTH) {
//      vX = (rnd.nextDouble() * 0.5) * VELOCITY_FACTOR_X;
//    } else if (x > LAST_QUARTER_WIDTH) {
//      vX = -(rnd.nextDouble() * 0.5) * VELOCITY_FACTOR_X;
//    } else {
//      vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * VELOCITY_FACTOR_X;
//    }
//    vY = (((rnd.nextDouble() * 1.5) + minSpeedY) * vYVariation) * VELOCITY_FACTOR_Y;
//
//    // Rotation
//    rot = Math.toDegrees(Math.atan2(vY, vX)) - 90;
//
//    // Related to laser fire
//    lastShotY = 0;
  }

  // TODO: implement
  void respawn() {
//    image = enemyImages[RND.nextInt(enemyImages.length)];
//    init();
  }

  // TODO: Get WIDTH and other constants to this method
  void update(GameState state) {
    x += vX;
    y += vY;

    // Respawn Enemy
//    if (x < -size || x > WIDTH + size || y > HEIGHT + size) {
//      respawn();
//    }
  }
}
