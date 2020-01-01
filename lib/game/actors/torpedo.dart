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

class Torpedo {
  final Image image;
  double x;
  double y;
  double vX;
  double vY;

  Torpedo(this.image, this.x, double y)
      : y = y - image.height,
        vX = 0,
        vY = Game.torpedoSpeed;

  get width => image.width;

  get height => image.height;

  get size => width > height ? width : height;

  get radius => size * 0.5;

  void update(Game game) {
    y -= vY;
    if (y < -size) {
      game.state.torpedoesToRemove.add(this);
    }
  }
}
