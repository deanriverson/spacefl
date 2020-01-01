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

import 'package:spacefl/game/game_images.dart';
import 'package:spacefl/game/game_state.dart';
import 'package:spacefl/game/rendering/render_fns.dart';

class Game {
  static const bool playSound = true;
  static const bool playMusic = true;
  static const bool showStars = true;
  static const bool showEnemies = true;
  static const bool showAsteroids = true;
  static const bool showBackground = true;

  static const int lifeCount = 5;
  static const int shieldCount = 10;
  static const int rocketCount = 3;
  static const int starCount = showStars ? 200 : 0;
  static const int asteroidCount = showAsteroids ? 15 : 0;
  static const int enemyCount = showEnemies ? 5 : 0;
  static const int enemyFireSensitivity = 10;

  static const double torpedoSpeed = 6;
  static const double rocketSpeed = 4;
  static const double enemyTorpedoSpeed = 5;
  static const double enemyBossTorpedoSpeed = 6;
  static const double velocityFactorX = 0.5;
  static const double velocityFactorY = 0.5;
  static const double velocityFactorR = 0.01;

  static const Duration deflectorShieldDuration = Duration(seconds: 5);
  static const Duration enemyBossAttackInterval = Duration(seconds: 20);
  static const Duration crystalSpawnInterval = Duration(seconds: 25);

  static const Color scoreColor = Color.fromARGB(255, 51, 210, 206);

//  static const double WIDTH = 700;
//  static const double HEIGHT = 900;
//  static const double FIRST_QUARTER_WIDTH = WIDTH * 0.25;
//  static const double LAST_QUARTER_WIDTH = WIDTH * 0.75;
//  static const double SHIELD_INDICATOR_X = WIDTH * 0.73;
//  static const double SHIELD_INDICATOR_Y = HEIGHT * 0.06;
//  static const double SHIELD_INDICATOR_WIDTH = WIDTH * 0.26;
//  static const double SHIELD_INDICATOR_HEIGHT = HEIGHT * 0.01428571;

  static Game _instance;

  final state = GameState();
  final images = GameImages();

  Game._();

  /// Return the singleton instance of Game
  factory Game.instance() {
    if (_instance == null) {
      _instance = Game._();
    }

    return Game._instance;
  }

  Future<void> loadAssets() async => await _instance.images.loadImages();

  void update(Duration deltaT) => _instance.state.update(this, deltaT);

  void repaint(Canvas canvas) {
    drawBackground(canvas, this);
    drawStars(canvas, this);

    drawAsteroids(canvas, this);
    drawEnemies(canvas, this);
    drawCrystals(canvas, this);

    drawSpaceShip(canvas, this);

    drawFps(canvas, this);
  }
}
