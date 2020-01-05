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

import 'dart:math';

import 'package:spacefl/game/actors/actor.dart';
import 'package:spacefl/game/actors/mixins/enemy_hit_test.dart';
import 'package:spacefl/game/actors/mixins/enemy_weapons.dart';
import 'package:spacefl/game/actors/mixins/kinematics.dart';
import 'package:spacefl/game/actors/mixins/kinematics_opts.dart';
import 'package:spacefl/game/actors/torpedo.dart';
import 'package:spacefl/game/game.dart';

class Enemy extends Actor with Kinematics, EnemyHitTest, EnemyWeapons {
  final kinematicsOpts = KinematicsOpts(xVariation: 1.0, minSpeedY: 3.0, hasSpeedR: false);

  Enemy(Game game) {
    _init(game);
  }

  void update(Game game, Duration deltaT) {
    final state = game.state;

    updateKinematics(state.boardSize, whenOffBoard: () => _init(game));
    doHitTest(game, onHit: (actor) => _processHit(game, actor));
    aimWeapons(state.spaceShip, onFire: () => _fireTorpedo(game));
  }

  void _init(Game game) {
    image = game.images.randomEnemyImage;
    initWeapons(game);
    initKinematics(game, initialRotation: _calcRotation);
  }

  double _calcRotation() => atan2(vY, vX) - pi / 2.0;

  void _processHit(Game game, Actor actor) {
    if (actor.runtimeType == Torpedo) {
      game.state.spawnExplosion(game, centerX, centerY, vX, vY, 0.5);
    } else {
      game.state.spawnRocketExplosion(game, centerX, centerY, vX, vY, 0.5);
    }
    _init(game);
  }

  void _fireTorpedo(Game game) => game.state.spawnEnemyTorpedo(game, centerX, centerY, vX, vY);
}
