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

import 'package:spacefl/game_state.dart';

class Torpedo {
  final Image image;
  double x;
  double y;
  double width;
  double height;
  double size;
  double radius;
  double vX;
  double vY;

  Torpedo(this.image);

//  Torpedo(final Image image, final double x, final double y) {
//    this.image  = image;
//    this.x      = x;
//    this.y      = y - image.height;
//    this.width  = image.width;
//    this.height = image.height;
//    this.size   = width > height ? width : height;
//    this.radius = size * 0.5;
//    this.vX     = 0;
//    this.vY     = TORPEDO_SPEED;
//  }

  void update(GameState state) {
//    y -= vY;
//    if (y < -size) {
//      torpedosToRemove.add(Torpedo.this);
//    }
  }
}