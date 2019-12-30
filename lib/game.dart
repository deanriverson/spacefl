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

import 'package:flutter/services.dart';
import 'package:spacefl/actors/asteroid_explosion.dart';
import 'package:spacefl/actors/crystal.dart';
import 'package:spacefl/actors/crystal_explosion.dart';
import 'package:spacefl/actors/enemy_boss.dart';
import 'package:spacefl/actors/enemy_boss_explosion.dart';
import 'package:spacefl/actors/enemy_boss_hit.dart';
import 'package:spacefl/actors/enemy_boss_torpedo.dart';
import 'package:spacefl/actors/enemy_torpedo.dart';
import 'package:spacefl/actors/explosion.dart';
import 'package:spacefl/actors/hit.dart';
import 'package:spacefl/actors/player.dart';
import 'package:spacefl/actors/rocket.dart';
import 'package:spacefl/actors/rocket_explosion.dart';
import 'package:spacefl/actors/space_ship.dart';
import 'package:spacefl/actors/space_ship_explosion.dart';
import 'package:spacefl/actors/torpedo.dart';

class _GameImages {
  static const BACKGROUND = 'assets/images/background.jpg';

  Image _backgroundImage;

  get backgroundImage => _backgroundImage;

  Future<void> loadImages() async {
    _backgroundImage = await _loadImage(BACKGROUND);
  }

  Future<Image> _loadImage(String key) async {
    final byteData = await rootBundle.load(key);
    final codec = await instantiateImageCodec(byteData.buffer.asUint8List());
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class GameState {
  SpaceShip spaceShip;
  SpaceShipExplosion spaceShipExplosion;

  List<Player> hallOfFame = [];

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
  bool running = false;
  bool gameOverScreen = false;
  bool hallOfFameScreen = false;
  bool inputAllowed = false;
}

class Game {
  static const bool PLAY_SOUND = true;
  static const bool PLAY_MUSIC = true;
  static const bool SHOW_BACKGROUND = true;
  static const bool SHOW_STARS = true;
  static const bool SHOW_ENEMIES = true;
  static const bool SHOW_ASTEROIDS = true;
  static const int NO_OF_STARS = SHOW_STARS ? 200 : 0;
  static const int NO_OF_ASTEROIDS = SHOW_ASTEROIDS ? 15 : 0;
  static const int NO_OF_ENEMIES = SHOW_ENEMIES ? 5 : 0;

  static const int LIVES = 5;
  static const int SHIELDS = 10;
  static const int DEFLECTOR_SHIELD_TIME = 5000;
  static const int MAX_NO_OF_ROCKETS = 3;
  static const double TORPEDO_SPEED = 6;
  static const double ROCKET_SPEED = 4;
  static const double ENEMY_TORPEDO_SPEED = 5;
  static const double ENEMY_BOSS_TORPEDO_SPEED = 6;
  static const int ENEMY_FIRE_SENSITIVITY = 10;
  static const Duration ENEMY_BOSS_ATTACK_INTERVAL = Duration(seconds: 20);
  static const Duration CRYSTAL_SPAWN_INTERVAL = Duration(seconds: 25);
  static const double WIDTH = 700;
  static const double HEIGHT = 900;
  static const double FIRST_QUARTER_WIDTH = WIDTH * 0.25;
  static const double LAST_QUARTER_WIDTH = WIDTH * 0.75;
  static const double SHIELD_INDICATOR_X = WIDTH * 0.73;
  static const double SHIELD_INDICATOR_Y = HEIGHT * 0.06;
  static const double SHIELD_INDICATOR_WIDTH = WIDTH * 0.26;
  static const double SHIELD_INDICATOR_HEIGHT = HEIGHT * 0.01428571;
  static const double VELOCITY_FACTOR_X = 1.0;
  static const double VELOCITY_FACTOR_Y = 1.0;
  static const double VELOCITY_FACTOR_R = 1.0;
  static const Color SCORE_COLOR = Color.fromARGB(255, 51, 210, 206);

  static Game _instance;

  final state = GameState();
  final images = _GameImages();

  Game._();

  factory Game.instance() {
    if (_instance == null) {
      _instance = Game._();
      _instance.images.loadImages();
    }

    return Game._instance;
  }
}
