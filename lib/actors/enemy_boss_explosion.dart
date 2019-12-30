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

import 'package:spacefl/game.dart';

class EnemyBossExplosion {
  static const double FRAME_WIDTH = 200;
  static const double FRAME_HEIGHT = 200;
  static const double FRAME_CENTER = 100;
  static const int MAX_FRAME_X = 4;
  static const int MAX_FRAME_Y = 7;

  double x;
  double y;
  double vX;
  double vY;
  double scale;
  int countX = 0;
  int countY = 0;

  EnemyBossExplosion(this.x, this.y, this.vX, this.vY, this.scale);

  void update(Game game) {
    x += vX;
    y += vY;

    countX++;
    if (countX == MAX_FRAME_X) {
      countY++;
      if (countX == MAX_FRAME_X && countY == MAX_FRAME_Y) {
        game.state.enemyBossExplosionsToRemove.add(this);
      }
      countX = 0;
      if (countY == MAX_FRAME_Y) {
        countY = 0;
      }
    }
  }
}
