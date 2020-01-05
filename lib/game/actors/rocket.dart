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

import 'package:spacefl/game/actors/actor.dart';
import 'package:spacefl/game/game.dart';

class Rocket extends Actor {
  final Image image;

  double x;
  double y;
  double width;
  double height;
  double halfWidth;
  double halfHeight;
  double size;
  double radius;
  double vX = 0;
  double vY = Game.rocketSpeed;

  Rocket(Game game, this.x, y) : image = game.images.lookupImage('rocket') {
    this.y = y - image.height;
    this.width      = image.width.toDouble();
    this.height     = image.height.toDouble();

    this.halfWidth  = width * 0.5;
    this.halfHeight = height * 0.5;

    this.size       = width > height ? width : height;
    this.radius     = size * 0.5;
  }

  void update(Game game, Duration deltaT) {
    y -= vY;
    if (y < -size) {
      game.state.rocketsToRemove.add(this);
    }
  }
}
