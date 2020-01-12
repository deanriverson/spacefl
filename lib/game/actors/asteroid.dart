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
import 'package:spacefl/game/actors/mixins/respawn.dart';
import 'package:spacefl/game/actors/mixins/enemy_hit_test.dart';
import 'package:spacefl/game/actors/mixins/kinematics.dart';
import 'package:spacefl/game/actors/mixins/kinematics_opts.dart';
import 'package:spacefl/game/actors/torpedo.dart';
import 'package:spacefl/game/game.dart';
import 'package:spacefl/game/math_utils.dart';

class Asteroid extends Actor with Kinematics, EnemyHitTest, Respawn {
  static const respawnMin = 1.0;
  static const respawnMax = 5.0;

  final kinematicsOpts = KinematicsOpts(
    xVariation: 2.0,
    minSpeedY: 2.0,
    scaleOffset: 0.2,
    scaleSpread: 0.6,
  );

  int _hits = 0;

  Asteroid(Game game) {
    respawn(game);
  }

  void update(Game game, Duration deltaT) {
    if (isRespawning(game.state.lastTimestamp)) return;

    updateKinematics(game.state.boardSize, whenOffBoard: () => respawn(game));
    doHitTest(game, onHit: (actor) => _processHit(game, actor));
  }

  void respawn(Game game, {Duration duration}) {
    image = game.images.randomAsteroidImage;
    initKinematics(game);
    _hits = (scale * 5.0).toInt();

    final respawnDuration = duration ?? randDurationInRange(game.state.random, respawnMin, respawnMax);
    startRespawnTimer(game.state.lastTimestamp, duration: respawnDuration);
  }

  void _processHit(Game game, Actor actor) {
    if (actor.runtimeType == Torpedo) {
      _processTorpedoHit(game, actor);
    } else {
      game.state.spawnRocketExplosion(game, centerX, centerY, vX, vY, scale);
      respawn(game);
    }
  }

  void _processTorpedoHit(Game game, Torpedo torpedo) {
    if (--_hits == 0) {
      game.state.spawnAsteroidExplosion(game, centerX, centerY, vX, vY, scale);
      respawn(game);
    } else {
      game.state.spawnHit(game, torpedo.x, torpedo.y, vX, vY);
    }
  }
}
