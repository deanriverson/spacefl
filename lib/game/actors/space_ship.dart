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

class SpaceShip {
  final Image image;
  final Image imageThrust;

  double  x;
  double  y;
  double  size;
  double  radius;
  double  width;
  double  height;
  double  vX;
  double  vY;
  bool shield;

  SpaceShip(this.image, this.imageThrust);

//  public SpaceShip(final Image image, final Image imageThrust) {
//    this.image       = image;
//    this.imageThrust = imageThrust;
//    this.x           = WIDTH * 0.5;
//    this.y           = HEIGHT - 2 * image.getHeight();
//    this.width       = image.getWidth();
//    this.height      = image.getHeight();
//    this.size        = width > height ? width : height;
//    this.radius      = size * 0.5;
//    this.vX          = 0;
//    this.vY          = 0;
//    this.shield      = false;
//  }

  void update() {
    throw UnimplementedError();

//    x += vX;
//    y += vY;
//    if (x + width * 0.5 > WIDTH) {
//      x = WIDTH - width * 0.5;
//    }
//    if (x - width * 0.5 < 0) {
//      x = width * 0.5;
//    }
//    if (y + height * 0.5 > HEIGHT) {
//      y = HEIGHT - height * 0.5;
//    }
//    if (y - height * 0.5< 0) {
//      y = height * 0.5;
//    }
  }
}
