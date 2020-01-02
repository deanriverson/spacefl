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

  final stars = List<Star>(Game.starCount);
  final asteroids = List<Asteroid>(Game.asteroidCount);
  final enemies = List<Enemy>(Game.enemyCount);

  final hallOfFame = <Player>[];
  final hits = <Hit>[];
  final hitsToRemove = <Hit>[];
  final crystals = <Crystal>[];
  final crystalsToRemove = <Crystal>{};
  final rockets = <Rocket>[];
  final rocketsToRemove = <Rocket>{};
  final torpedoes = <Torpedo>[];
  final torpedoesToRemove = <Torpedo>{};

  final enemyBosses = <EnemyBoss>[];
  final enemyBossesToRemove = <EnemyBoss>{};
  final enemyTorpedoes = <EnemyTorpedo>[];
  final enemyTorpedoesToRemove = <EnemyTorpedo>{};
  final enemyBossHits = <EnemyBossHit>[];
  final enemyBossHitsToRemove = <EnemyBossHit>{};
  final enemyBossTorpedoes = <EnemyBossTorpedo>[];
  final enemyBossTorpedoesToRemove = <EnemyBossTorpedo>{};

  final rocketExplosions = <RocketExplosion>[];
  final rocketExplosionsToRemove = <RocketExplosion>{};
  final enemyBossExplosions = <EnemyBossExplosion>[];
  final enemyBossExplosionsToRemove = <EnemyBossExplosion>{};
  final explosions = <Explosion>[];
  final explosionsToRemove = <Explosion>{};
  final asteroidExplosions = <AsteroidExplosion>[];
  final asteroidExplosionsToRemove = <AsteroidExplosion>{};
  final crystalExplosions = <CrystalExplosion>[];
  final crystalExplosionsToRemove = <CrystalExplosion>{};

  Random random = Random();
  Size boardSize = Size.zero;

  Duration lastEnemyBossAttack = Duration.zero;
  Duration lastCrystal = Duration.zero;
  Duration lastTimerCall = Duration.zero;

  Duration _deltaT = Duration.zero;
  Duration _lastTimestamp = Duration.zero;

  double scorePosX;
  double scorePosY;
  double backgroundViewportY = 2079; //backgroundImg.getHeight() - HEIGHT;

  int score = 0;
  int lifeCount = Game.lifeCount;

  bool hasBeenHit = false;
  bool initialized = false;
  bool running = false;
  bool gameOverScreen = false;
  bool hallOfFameScreen = false;
  bool inputAllowed = false;

  Duration get deltaT => _deltaT;

  Duration get lastTimestamp => _lastTimestamp;

  /// Initialize all actors and other game state
  void init(Game game, Size size) {
    if (boardSize == size) {
      return;
    }

    boardSize = size;

    if (initialized) {
      return;
    }

    spaceShip = SpaceShip(game);

    initActorList(stars, Game.starCount, () => Star(game));
    initActorList(asteroids, Game.asteroidCount, () => Asteroid(game));
    initActorList(enemies, Game.enemyCount, () => Enemy(game));

    initialized = true;
  }

  /// Update the game's state.
  void update(Game game, Duration timestamp) {
    _frameReset(game);
    _deltaT = _computeDeltaT(timestamp, _lastTimestamp);
    _lastTimestamp = timestamp;

    _updateActors(game, timestamp, deltaT);
    _updateAutoSpawns(game, timestamp);
  }

  void spawnTorpedo(Game game, double x, double y) {
    torpedoes.add(Torpedo(game, x, y));
  }

  void destroyTorpedo(Torpedo t) => torpedoesToRemove.add(t);

  void spawnRocket(Game game, double x, double y) {
    if (rockets.length < Game.maxRocketCount) {
      rockets.add(Rocket(game, x, y));
    }
  }

  void destroyRocket(Rocket t) => rocketsToRemove.add(t);

  void spawnAsteroidExplosion(double x, double y, double vX, double vY, double scale) {
    final xPos = x - AsteroidExplosion.frameCenter * scale;
    final yPos = y - AsteroidExplosion.frameCenter * scale;
    asteroidExplosions.add(AsteroidExplosion(xPos, yPos, vX, vY, scale));
  }

  void _frameReset(Game game) {
    _clearActors(rockets, rocketsToRemove);
    _clearActors(crystals, crystalsToRemove);
    _clearActors(torpedoes, torpedoesToRemove);

    _clearActors(enemyBosses, enemyBossesToRemove);
    _clearActors(enemyTorpedoes, enemyTorpedoesToRemove);
    _clearActors(enemyBossHits, enemyBossHitsToRemove);
    _clearActors(enemyBossTorpedoes, enemyBossTorpedoesToRemove);

    _clearActors(explosions, explosionsToRemove);
    _clearActors(rocketExplosions, rocketExplosionsToRemove);
    _clearActors(crystalExplosions, crystalExplosionsToRemove);
    _clearActors(asteroidExplosions, asteroidExplosionsToRemove);
    _clearActors(enemyBossExplosions, enemyBossExplosionsToRemove);
  }

  void _clearActors<T>(List<T> actors, Set<T> actorsToRemove) {
    if (actorsToRemove.isNotEmpty) {
      actors.removeWhere((c) => actorsToRemove.contains(c));
      actorsToRemove.clear();
    }
  }

  Duration _computeDeltaT(Duration now, Duration lastTimestamp) {
    Duration delta = now - lastTimestamp;
    if (lastTimestamp == Duration.zero) {
      delta = Duration.zero;
    }

    return delta;
  }

  void _updateActors(Game game, Duration timestamp, Duration deltaT) {
    updateActorList(stars, game, deltaT);
    updateActorList(asteroids, game, deltaT);
    updateActorList(enemies, game, deltaT);
    updateActorList(crystals, game, deltaT);

    updateActorList(torpedoes, game, deltaT);
    updateActorList(rockets, game, deltaT);
    updateActorList(asteroidExplosions, game, deltaT);

    spaceShip.update(game, timestamp);
  }

  void _updateAutoSpawns(Game game, Duration now) {
//    if (now > lastEnemyBossAttack + ENEMY_BOSS_ATTACK_INTERVAL) {
//      spawnEnemyBoss();
//      lastEnemyBossAttack = now;
//    }
    if (isTimeToSpawn(now, lastCrystal, Game.crystalSpawnInterval)) {
      Crystal.spawn(game);
      lastCrystal = now;
    }
  }
}
