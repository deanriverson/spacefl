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

import 'package:spacefl/game.dart';

class Rocket {
  final Image image;

  double x;
  double y;
  double width;
  double height;
  double halfWidth;
  double halfHeight;
  double size;
  double radius;
  double vX;
  double vY;

  Rocket(this.image);


//  Rocket(final Image image, final double x, final double y) {
//    this.image      = image;
//    this.x          = x;
//    this.y          = y - image.getHeight();
//    this.width      = image.getWidth();
//    this.height     = image.getHeight();
//    this.halfWidth  = width * 0.5;
//    this.halfHeight = height * 0.5;
//    this.size       = width > height ? width : height;
//    this.radius     = size * 0.5;
//    this.vX         = 0;
//    this.vY         = ROCKET_SPEED;
//  }

  void update(Game game) {
    throw UnimplementedError();

//    y -= vY;
//    if (y < -size) {
//      rocketsToRemove.add(Rocket.this);
//    }
  }
}