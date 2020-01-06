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

import 'package:spacefl/game/actors/actor.dart';
import 'package:spacefl/game/actors/mixins/enemy_hit_test.dart';
import 'package:spacefl/game/actors/mixins/kinematics.dart';
import 'package:spacefl/game/actors/mixins/kinematics_opts.dart';
import 'package:spacefl/game/game.dart';

class Crystal extends Actor with Kinematics, EnemyHitTest {
  final kinematicsOpts = KinematicsOpts(xVariation: 2.0, minSpeedY: 2.0, minSpeedR: 0.1);

  Crystal(Game game) {
    image = game.images.lookupImage('crystal');
    initKinematics(game);
  }

  void update(Game game, Duration deltaT) {
    final state = game.state;
    updateKinematics(state.boardSize, whenOffBoard: () => state.destroyCrystal(this));
    doHitTest(game, onHit: (actor) => _processHit(game));
  }

  @override
  String toString() => 'Crystal@($x, $y)';

  void _processHit(Game game) {
    final state = game.state;
    state.destroyCrystal(this);
    state.spawnCrystalExplosion(game, centerX, centerY, vX, vY);
    state.spaceShip.incShieldCount();
  }
}
