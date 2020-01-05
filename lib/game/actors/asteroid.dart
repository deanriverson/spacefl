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
import 'package:spacefl/game/actors/torpedo.dart';
import 'package:spacefl/game/game.dart';

class Asteroid extends Actor with Kinematics, EnemyHitTest {
  final kinematicsOpts = KinematicsOpts(
    xVariation: 2.0,
    minSpeedY: 2.0,
    scaleOffset: 0.2,
    scaleSpread: 0.6,
  );

  int _hits = 0;

  Asteroid(Game game) {
    _init(game);
  }

  void update(Game game, Duration deltaT) {
    updateKinematics(game, whenOffBoard: () => _init(game));
    doHitTest(game, onHit: (actor) => _processHit(game, actor));
  }

  void _init(Game game) {
    image = game.images.randomAsteroidImage;
    initKinematics(game);
    _hits = (scale * 5.0).toInt();
  }

  void _processHit(Game game, Actor actor) {
    if (actor.runtimeType == Torpedo) {
      _processTorpedoHit(game);
    } else {
      game.state.spawnRocketExplosion(game, centerX, centerY, vX, vY, scale);
      _init(game);
    }
  }

  void _processTorpedoHit(Game game) {
    if (--_hits == 0) {
      game.state.spawnAsteroidExplosion(game, centerX, centerY, vX, vY, scale);
      _init(game);
    }
  }
}
