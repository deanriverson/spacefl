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
import 'dart:ui';

import 'package:spacefl/game/actors/actor_utils.dart';
import 'package:spacefl/game/actors/asteroid.dart';
import 'package:spacefl/game/actors/asteroid_explosion.dart';
import 'package:spacefl/game/actors/crystal.dart';
import 'package:spacefl/game/actors/crystal_explosion.dart';
import 'package:spacefl/game/actors/enemy.dart';
import 'package:spacefl/game/actors/enemy_boss.dart';
import 'package:spacefl/game/actors/enemy_boss_explosion.dart';
import 'package:spacefl/game/actors/enemy_boss_hit.dart';
import 'package:spacefl/game/actors/enemy_boss_torpedo.dart';
import 'package:spacefl/game/actors/enemy_torpedo.dart';
import 'package:spacefl/game/actors/explosion.dart';
import 'package:spacefl/game/actors/hit.dart';
import 'package:spacefl/game/actors/player.dart';
import 'package:spacefl/game/actors/rocket.dart';
import 'package:spacefl/game/actors/rocket_explosion.dart';
import 'package:spacefl/game/actors/space_ship.dart';
import 'package:spacefl/game/actors/space_ship_explosion.dart';
import 'package:spacefl/game/actors/star.dart';
import 'package:spacefl/game/actors/torpedo.dart';
import 'package:spacefl/game/game.dart';

class GameState {
  SpaceShip spaceShip;
  SpaceShipExplosion spaceShipExplosion;

  final stars = List<Star>(Game.NO_OF_STARS);
  final asteroids = List<Asteroid>(Game.NO_OF_ASTEROIDS);
  final enemies = List<Enemy>(Game.NO_OF_ENEMIES);

  final hallOfFame = <Player>[];
  final hits = <Hit>[];
  final hitsToRemove = <Hit>[];
  final crystals = <Crystal>[];
  final crystalsToRemove = <Crystal>{};
  final rockets = <Rocket>[];
  final rocketsToRemove = <Rocket>[];
  final torpedoes = <Torpedo>[];
  final torpedoesToRemove = <Torpedo>[];

  final enemyBosses = <EnemyBoss>[];
  final enemyBossesToRemove = <EnemyBoss>[];
  final enemyTorpedoes = <EnemyTorpedo>[];
  final enemyTorpedoesToRemove = <EnemyTorpedo>[];
  final enemyBossHits = <EnemyBossHit>[];
  final enemyBossHitsToRemove = <EnemyBossHit>[];
  final enemyBossTorpedoes = <EnemyBossTorpedo>[];
  final enemyBossTorpedoesToRemove = <EnemyBossTorpedo>[];

  final rocketExplosions = <RocketExplosion>[];
  final rocketExplosionsToRemove = <RocketExplosion>[];
  final enemyBossExplosions = <EnemyBossExplosion>[];
  final enemyBossExplosionsToRemove = <EnemyBossExplosion>[];
  final explosions = <Explosion>[];
  final explosionsToRemove = <Explosion>[];
  final asteroidExplosions = <AsteroidExplosion>[];
  final asteroidExplosionsToRemove = <AsteroidExplosion>[];
  final crystalExplosions = <CrystalExplosion>[];
  final crystalExplosionsToRemove = <CrystalExplosion>[];

  Random random = Random();
  Size boardSize = Size.zero;

  Duration lastShieldActivated = Duration.zero;
  Duration lastEnemyBossAttack = Duration.zero;
  Duration lastCrystal = Duration.zero;
  Duration lastTimerCall = Duration.zero;

  Duration _deltaT = Duration.zero;
  Duration _lastTimestamp = Duration.zero;

  double scorePosX;
  double scorePosY;
  double backgroundViewportY = 2079; //backgroundImg.getHeight() - HEIGHT;

  int score = 0;
  int lifeCount = Game.LIVES;
  int shieldCount = Game.SHIELDS;

  bool hasBeenHit = false;
  bool initialized = false;
  bool running = false;
  bool gameOverScreen = false;
  bool hallOfFameScreen = false;
  bool inputAllowed = false;

  Duration get deltaT => _deltaT;

  /// Initialize all actors and other game state
  void init(Game game) {
    initActorList(stars, Game.NO_OF_STARS, () => Star(game));
    initActorList(asteroids, Game.NO_OF_ASTEROIDS, () => Asteroid(game));
    initActorList(enemies, Game.NO_OF_ENEMIES, () => Enemy(game));
  }

  /// Update the game's state.
  void update(Game game, Duration timestamp) {
    _frameReset(game);
    _deltaT = _computeDeltaT(timestamp);

    _updateActors(game, deltaT);
    _updateSpawns(game, timestamp);
  }

  void _frameReset(Game game) {
    if (crystalsToRemove.isNotEmpty) {
      crystals.removeWhere((c) => crystalsToRemove.contains(c));
      crystalsToRemove.clear();
    }
  }

  Duration _computeDeltaT(Duration now) {
    Duration delta = now - _lastTimestamp;
    if (_lastTimestamp == Duration.zero) {
      delta = Duration.zero;
    }

    _lastTimestamp = now;
    return delta;
  }

  void _updateActors(Game game, Duration deltaT) {
    updateActorList(stars, game, deltaT);
    updateActorList(asteroids, game, deltaT);
    updateActorList(enemies, game, deltaT);
    updateActorList(crystals, game, deltaT);
  }

  void _updateSpawns(Game game, Duration now) {
//    if (now > lastEnemyBossAttack + ENEMY_BOSS_ATTACK_INTERVAL) {
//      spawnEnemyBoss();
//      lastEnemyBossAttack = now;
//    }
    if (isTimeToSpawn(now, lastCrystal, Game.CRYSTAL_SPAWN_INTERVAL)) {
      Crystal.spawn(game);
      lastCrystal = now;
    }
  }
}
