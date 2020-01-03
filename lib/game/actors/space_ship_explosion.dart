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

class SpaceShipExplosion {
  static const int maxFrameX = 8;
  static const int maxFrameY = 6;

  static const double frameWidth = 100;
  static const double frameHeight = 100;
  static const double frameCenter = 50;

  double x;
  double y;
  int countX = 0;
  int countY = 0;

  SpaceShipExplosion(this.x, this.y);

  void update(Game game) {
    countX++;
    if (countX == maxFrameX) {
      countX = 0;
      countY++;
      if (countY == maxFrameY) {
        countY = 0;
      }
      if (countX == 0 && countY == 0) {
        game.state.resetSpaceShip(game);
      }
    }
  }
}
