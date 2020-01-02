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

import 'package:spacefl/game/game.dart';

class AsteroidExplosion {
  static const int maxFrameX = 8;
  static const int maxFrameY = 7;

  static const double frameWidth = 256;
  static const double frameHeight = 256;
  static const double frameCenter = 128;

  double x;
  double y;
  double vX;
  double vY;
  double scale;
  int countX = 0;
  int countY = 0;

  AsteroidExplosion(this.x, this.y, this.vX, this.vY, this.scale);

  void update(Game game) {
    x += vX;
    y += vY;

    countX++;
    if (countX == maxFrameX) {
      countY++;
      if (countX == maxFrameX && countY == maxFrameY) {
        game.state.asteroidExplosionsToRemove.add(this);
      }
      countX = 0;
      if (countY == maxFrameY) {
        countY = 0;
      }
    }
  }
}
