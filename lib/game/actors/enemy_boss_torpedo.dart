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

class EnemyBossTorpedo {
  final Image image;

  double x;
  double y;
  double vX;
  double vY;


  EnemyBossTorpedo(this.image, double x, this.y, this.vX, this.vY)
    : this.x = x - image.width / 2.0;

  get width => image.width;
  get height => image.height;
  get size => width > height ? width : height;
  get radius => size * 0.5;

  void update(Game game) {
    throw UnimplementedError();

//    x += vX;
//    y += vY;

//    final hasBeenHit = state.hasBeenHit;
//    final spaceShip = state.spaceShip;
//
//    if (!hasBeenHit) {
//      bool hit;
//      if (spaceShip.shield) {
//        hit = isHitCircleCircle(x, y, radius, spaceShip.x, spaceShip.y, deflectorShieldRadius);
//      } else {
//        hit = isHitCircleCircle(x, y, radius, spaceShip.x, spaceShip.y, spaceShip.radius);
//      }
//      if (hit) {
//        enemyBossTorpedosToRemove.add(EnemyBossTorpedo.this);
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
//      enemyBossTorpedosToRemove.add(EnemyBossTorpedo.this);
//    }
  }
}
