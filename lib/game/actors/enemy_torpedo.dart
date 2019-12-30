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

class EnemyTorpedo {
  final Image image;

  double x;
  double y;
  double vX;
  double vY;

  EnemyTorpedo(this.image, this.x, this.y, this.vX, this.vY);

//  {
//    this.image = image;
//    this.x = x - image.getWidth() / 2.0;
//    this.y = y;
//    this.width = image.getWidth();
//    this.height = image.getHeight();
//    this.size = width > height ? width : height;
//    this.radius = size * 0.5;
//    this.vX = vX;
//    this.vY = vY;
//  }

  get width => image.width;

  get height => image.height;

  get size => width > height ? width : height;

  get radius => size * 0.5;

  void update(Game game) {
    throw UnimplementedError();

//    x += vX;
//    y += vY;
//
//    if (!hasBeenHit) {
//      boolean hit;
//      if (spaceShip.shield) {
//        hit = isHitCircleCircle(x, y, radius, spaceShip.x, spaceShip.y, deflectorShieldRadius);
//      } else {
//        hit = isHitCircleCircle(x, y, radius, spaceShip.x, spaceShip.y, spaceShip.radius);
//      }
//      if (hit) {
//        enemyTorpedoesToRemove.add(EnemyTorpedo.this);
//        if (spaceShip.shield) {
//          playSound(shieldHitSound);
//        } else {
//          hasBeenHit = true;
//          playSound(spaceShipExplosionSound);
//          noOfLifes--;
//          if (0 == noOfLifes) {
//            gameOver();
//          }
//        }
//      }
//    } else if (y > HEIGHT) {
//      state.enemyTorpedoesToRemove.add(this);
//    }
  }
}
