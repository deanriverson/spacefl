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

import 'package:spacefl/game/actors/asteroid.dart';
import 'package:spacefl/game/actors/asteroid_explosion.dart';
import 'package:spacefl/game/actors/crystal.dart';
import 'package:spacefl/game/actors/crystal_explosion.dart';
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

  List<Player> hallOfFame = [];
  List<Star> stars = List<Star>(Game.NO_OF_STARS);
  List<Asteroid> asteroids = List<Asteroid>(Game.NO_OF_ASTEROIDS);

  List<Hit> hits = [];
  List<Hit> hitsToRemove = [];
  List<Crystal> crystals = [];
  List<Crystal> crystalsToRemove = [];
  List<Rocket> rockets = [];
  List<Rocket> rocketsToRemove = [];
  List<Torpedo> torpedoes = [];
  List<Torpedo> torpedoesToRemove = [];

  List<EnemyBoss> enemyBosses = [];
  List<EnemyBoss> enemyBossesToRemove = [];
  List<EnemyTorpedo> enemyTorpedoes = [];
  List<EnemyTorpedo> enemyTorpedoesToRemove = [];
  List<EnemyBossHit> enemyBossHits = [];
  List<EnemyBossHit> enemyBossHitsToRemove = [];
  List<EnemyBossTorpedo> enemyBossTorpedoes = [];
  List<EnemyBossTorpedo> enemyBossTorpedoesToRemove = [];

  List<RocketExplosion> rocketExplosions = [];
  List<RocketExplosion> rocketExplosionsToRemove = [];
  List<EnemyBossExplosion> enemyBossExplosions = [];
  List<EnemyBossExplosion> enemyBossExplosionsToRemove = [];
  List<Explosion> explosions = [];
  List<Explosion> explosionsToRemove = [];
  List<AsteroidExplosion> asteroidExplosions = [];
  List<AsteroidExplosion> asteroidExplosionsToRemove = [];
  List<CrystalExplosion> crystalExplosions = [];
  List<CrystalExplosion> crystalExplosionsToRemove = [];

  Random random = Random();
  Size boardSize = Size.zero;

  double scorePosX;
  double scorePosY;
  double backgroundViewportY = 2079; //backgroundImg.getHeight() - HEIGHT;

  int score = 0;
  int lifeCount = Game.LIVES;
  int shieldCount = Game.SHIELDS;
  int lastShieldActivated;
  int lastEnemyBossAttack;
  int lastCrystal;
  int lastTimerCall;
  bool hasBeenHit = false;
  bool initialized = false;
  bool running = false;
  bool gameOverScreen = false;
  bool hallOfFameScreen = false;
  bool inputAllowed = false;

  /// Initialize all actors and other game state
  void init(Game game) {
    _initStars(game);
    _initAsteroids(game);
  }

  /// Update the game's state.
  ///
  /// I'm passing in deltaT to this function but it's not used yet.  This would
  /// allow us to eventually update positions based on velocity and time.
  void update(Game game, Duration deltaT) {
    _updateStars(game, deltaT);
    _updateAsteroids(game, deltaT);
  }

  void _initStars(Game game) {
    for (int i = 0; i < Game.NO_OF_STARS; i++) {
      stars[i] = Star(game);
    }
  }

  void _initAsteroids(Game game) {
    for (int i = 0 ; i < Game.NO_OF_ASTEROIDS ; i++) {
      asteroids[i] = Asteroid(game);
    }
  }

  void _updateStars(Game game, Duration _) {
    for (int i = 0; i < Game.NO_OF_STARS; i++) {
      stars[i].update(game);
    }
  }

  void _updateAsteroids(Game game, Duration _) {
    for (int i = 0 ; i < Game.NO_OF_ASTEROIDS ; i++) {
      asteroids[i].update(game);
    }
  }
}
