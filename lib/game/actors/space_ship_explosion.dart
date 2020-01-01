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
  static const double FRAME_WIDTH  = 100;
  static const double FRAME_HEIGHT = 100;
  static const double FRAME_CENTER = 50;
  static const int    MAX_FRAME_X  = 8;
  static const int    MAX_FRAME_Y  = 6;

  double x;
  double y;
  int    countX = 0;
  int    countY = 0;

  SpaceShipExplosion(this.x, this.y);

  void update(Game game) {
    countX++;
    if (countX == MAX_FRAME_X) {
      countX = 0;
      countY++;
      if (countY == MAX_FRAME_Y) {
        countY = 0;
      }
      if (countX == 0 && countY == 0) {
        final state = game.state;
        state.hasBeenHit = false;
        state.spaceShip.resetPosition(game);
      }
    }
  }
}
