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
  final hitsToRemove = <Hit>{};
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

  void resetSpaceShip(Game game) {
    if (lifeCount == 0) {
      // TODO notify that game is over, for now just reset lifeCount.  Unlimited plays!!!
      //gameOver();
      //return;
      lifeCount = Game.lifeCount;
    }

    spaceShip.reset(game);
  }

  void spawnAsteroidExplosion(Game game, double x, double y, double vX, double vY, double scale) {
    asteroidExplosions.add(AsteroidExplosion(game, x, y, vX, vY, scale));
    // TODO - play sound
  }

  void spawnCrystal(Game game) => crystals.add(Crystal(game));

  void spawnCrystalExplosion(Game game, double x, double y, double vX, double vY) {
    crystalExplosions.add(CrystalExplosion(game, x, y, vX, vY));
  }

  void spawnEnemyBoss(Game game) => enemyBosses.add(EnemyBoss(game));

  void spawnEnemyBossExplosion(Game game, double centerX, double centerY, double vX, double vY) {
    enemyBossExplosions.add(EnemyBossExplosion(game, centerX, centerY, vX, vY));
    // TODO: play sound
  }

  void spawnEnemyBossHit(Game game, double x, double y, double vX, double vY) {
    enemyBossHits.add(EnemyBossHit(game, x, y, vX, vY));
    // TODO - play sound
  }

  void spawnEnemyBossTorpedo(Game game, double x, double y, double vX, double vY) {
    double vFactor = Game.enemyTorpedoSpeed / vY;
    enemyBossTorpedoes.add(EnemyBossTorpedo(game, x, y, vFactor * vX, vFactor * vY));
    // TODO: play sound
//    playSound(enemyLaserSound);
  }

  void spawnEnemyTorpedo(Game game, double x, double y, double vX, double vY) {
    double vFactor = Game.enemyTorpedoSpeed / vY;
    enemyTorpedoes.add(EnemyTorpedo(game, x, y, vFactor * vX, vFactor * vY));
    // TODO: play sound
//    playSound(enemyLaserSound);
  }

  void spawnExplosion(Game game, double x, double y, double vX, double vY, double scale) {
    explosions.add(Explosion(game, x, y, vX, vY, scale));
    // TODO - play sound
  }

  void spawnHit(Game game, double x, double y, double vX, double vY) {
    hits.add(Hit(game, x, y, vX, vY));
    // TODO - play sound
  }

  void spawnRocket(Game game, double x, double y) {
    if (rockets.length < Game.maxRocketCount) {
      rockets.add(Rocket(game, x, y));
    }
    // TODO: play sound
  }

  void spawnRocketExplosion(Game game, double x, double y, double vX, double vY, double scale) {
    rocketExplosions.add(RocketExplosion(game, x, y, vX, vY, scale));
    // TODO: play sound
  }

  void spawnTorpedo(Game game, double x, double y) {
    torpedoes.add(Torpedo(game, x, y));
    // TODO: play sound
  }

  void destroyAsteroidExplosion(AsteroidExplosion ae) => asteroidExplosionsToRemove.add(ae);

  void destroyCrystal(Crystal c) => crystalsToRemove.add(c);

  void destroyCrystalExplosion(CrystalExplosion ce) => crystalExplosionsToRemove.add(ce);

  void destroyEnemyTorpedo(EnemyTorpedo t) => enemyTorpedoesToRemove.add(t);

  void destroyEnemyBoss(EnemyBoss eb) => enemyBossesToRemove.add(eb);

  void destroyEnemyBossExplosion(EnemyBossExplosion ebe) => enemyBossExplosionsToRemove.add(ebe);

  void destroyEnemyBossTorpedo(EnemyBossTorpedo ebt) => enemyBossTorpedoesToRemove.add(ebt);

  void destroyEnemyBossHit(EnemyBossHit ebh) => enemyBossHitsToRemove.add(ebh);

  void destroyExplosion(Explosion e) => explosionsToRemove.add(e);

  void destroyHit(Hit h) => hitsToRemove.add(h);

  void destroyRocket(Rocket r) => rocketsToRemove.add(r);

  void destroyRocketExplosion(RocketExplosion re) => rocketExplosionsToRemove.add(re);

  void destroySpaceShip(Game game) {
    // TODO: play sound
    //playSound(spaceShipExplosionSound);

    lifeCount--;
    spaceShipExplosion = SpaceShipExplosion(game, spaceShip.x, spaceShip.y, spaceShip.vX * .1, spaceShip.vY * .1);
  }

  void destroyTorpedo(Torpedo t) => torpedoesToRemove.add(t);

  void _frameReset(Game game) {
    clearActors(rockets, rocketsToRemove);
    clearActors(crystals, crystalsToRemove);
    clearActors(torpedoes, torpedoesToRemove);

    clearActors(enemyBosses, enemyBossesToRemove);
    clearActors(enemyTorpedoes, enemyTorpedoesToRemove);
    clearActors(enemyBossHits, enemyBossHitsToRemove);
    clearActors(enemyBossTorpedoes, enemyBossTorpedoesToRemove);

    clearActors(hits, hitsToRemove);
    clearActors(enemyBossHits, enemyBossHitsToRemove);

    clearActors(explosions, explosionsToRemove);
    clearActors(rocketExplosions, rocketExplosionsToRemove);
    clearActors(crystalExplosions, crystalExplosionsToRemove);
    clearActors(asteroidExplosions, asteroidExplosionsToRemove);
    clearActors(enemyBossExplosions, enemyBossExplosionsToRemove);
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
    updateActorList(crystals, game, deltaT);
    updateActorList(enemies, game, deltaT);
    updateActorList(enemyBosses, game, deltaT);

    updateActorList(rockets, game, deltaT);
    updateActorList(torpedoes, game, deltaT);
    updateActorList(enemyTorpedoes, game, deltaT);
    updateActorList(enemyBossTorpedoes, game, deltaT);

    updateActorList(hits, game, deltaT);
    updateActorList(enemyBossHits, game, deltaT);

    updateActorList(asteroidExplosions, game, deltaT);
    updateActorList(crystalExplosions, game, deltaT);
    updateActorList(enemyBossExplosions, game, deltaT);
    updateActorList(explosions, game, deltaT);
    updateActorList(rocketExplosions, game, deltaT);

    if (spaceShip.isAlive) {
      spaceShip.update(game, deltaT);
    } else {
      spaceShipExplosion.update(game, deltaT);
    }
  }

  void _updateAutoSpawns(Game game, Duration now) {
    if (now > lastEnemyBossAttack + Game.enemyBossAttackInterval) {
      spawnEnemyBoss(game);
      lastEnemyBossAttack = now;
    }

    if (isTimeToSpawn(now, lastCrystal, Game.crystalSpawnInterval)) {
      spawnCrystal(game);
      lastCrystal = now;
    }
  }
}
