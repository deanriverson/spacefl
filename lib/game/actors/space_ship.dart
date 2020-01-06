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
import 'package:spacefl/game/actors/asteroid.dart';
import 'package:spacefl/game/actors/crystal.dart';
import 'package:spacefl/game/actors/enemy.dart';
import 'package:spacefl/game/actors/enemy_boss.dart';
import 'package:spacefl/game/actors/enemy_boss_torpedo.dart';
import 'package:spacefl/game/actors/mixins/player_hit_test.dart';
import 'package:spacefl/game/actors/mixins/player_kinematics.dart';
import 'package:spacefl/game/game.dart';

class SpaceShip extends Actor with PlayerKinematics, PlayerHitTest {
  static const maxHitPoints = 1;

  final Image _shieldImage;
  final Image _thrustImage;
  final Image _noThrustImage;

  int _hitPoints = SpaceShip.maxHitPoints;

  SpaceShip(Game game)
    : _noThrustImage = game.images.lookupImage('fighter'),
      _thrustImage = game.images.lookupImage('fighterThrust'),
      _shieldImage = game.images.lookupImage('shield') {
    assert(_noThrustImage != null && _noThrustImage != null && _shieldImage != null);
    reset(game);
  }

  bool get isAlive => _hitPoints > 0;

  bool get isMoving => vX != 0 || vY != 0;

  Image get shieldImage => _shieldImage;

  void reset(Game game) {
    image = _noThrustImage;
    _hitPoints = SpaceShip.maxHitPoints;
    initHitTesting();
    initKinematics(game.state.boardSize);
  }

  void update(Game game, Duration deltaT) {
    final state = game.state;
    final boardSize = state.boardSize;

    updateKinematics(boardSize);
    image = isMoving ? _thrustImage : _noThrustImage;

    doHitTest(game, onHit: (Actor a) => _handleHit(game, a));
  }

  /// Handle game events that affect this space ship
  void handleEvent(GameEvent ev, Game game) {
    switch (ev) {
      case GameEvent.accelerateUp:
        vY = -5;
        return;

      case GameEvent.accelerateDown:
        vY = 5;
        return;

      case GameEvent.decelerateUp:
      case GameEvent.decelerateDown:
        vY = 0;
        return;

      case GameEvent.accelerateLeft:
        vX = -5;
        return;

      case GameEvent.accelerateRight:
        vX = 5;
        return;

      case GameEvent.decelerateLeft:
      case GameEvent.decelerateRight:
        vX = 0;
        return;

      case GameEvent.activateShield:
        activateShield(game.state);
        // TODO: play sound
//      playSound(deflectorShieldSound);
        return;

      case GameEvent.fireRocket:
        game.state.spawnRocket(game, x, y);
//        playSound(rocketLaunchSound);
        return;

      case GameEvent.fireTorpedo:
        game.state.spawnTorpedo(game, x, y);
//        playSound(laserSound);
        return;

      default:
        return;
    }
  }

  void _handleHit(Game game, Actor a) {
    _destroyActor(a, game);

    if (shieldUp) {
      // TODO play sound
//      playSound(shieldHitSound);
      return;
    }

    _hitPoints--;
    if (_hitPoints <= 0) {
      game.state.destroySpaceShip(game);
    } else {
      // TODO play hit sound
    }
  }

  void _destroyActor(Actor a, Game game) {
    final state = game.state;
    switch (a.runtimeType) {
      case Asteroid:
        final ast = (a as Asteroid);
        state.spawnAsteroidExplosion(game, ast.centerX, ast.centerY, ast.vX, ast.vY, ast.scale);
        ast.respawn(game);
        break;

      case Crystal:
        final c = (a as Crystal);
        state.spawnCrystalExplosion(game, c.centerX, c.centerY, c.vX, c.vY);
        state.destroyCrystal(c);
        break;

      case Enemy:
        final e = (a as Enemy);
        state.spawnExplosion(game, e.centerX, e.centerY, e.vX, e.vY, 0.5);
        e.respawn(game);
        break;

      case EnemyBoss:
        final e = a as EnemyBoss;
        state.spawnEnemyBossExplosion(game, e.centerX, e.centerY, e.vX, e.vY);
        state.destroyEnemyBoss(e);
        break;

      case EnemyBossTorpedo:
        state.destroyEnemyBossTorpedo(a);
        break;

      case EnemyBossTorpedo:
        state.destroyEnemyBossTorpedo(a);
        break;
    }
  }
}
