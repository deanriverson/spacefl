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
import 'package:spacefl/actors/rocket.dart';
import 'package:spacefl/actors/rocket_explosion.dart';
import 'package:spacefl/actors/space_ship.dart';
import 'package:spacefl/actors/space_ship_explosion.dart';
import 'package:spacefl/actors/torpedo.dart';

class GameState {
  SpaceShip spaceShip;
  SpaceShipExplosion spaceShipExplosion;
  List<EnemyBoss> enemyBosses;
  List<EnemyBoss> enemyBossesToRemove;
  List<Crystal> crystals;
  List<Crystal> crystalsToRemove;
  List<Rocket> rockets;
  List<Rocket> rocketsToRemove;
  List<Torpedo> torpedoes;
  List<Torpedo> torpedoesToRemove;
  List<EnemyTorpedo> enemyTorpedoes;
  List<EnemyTorpedo> enemyTorpedoesToRemove;
  List<EnemyBossTorpedo> enemyBossTorpedoes;
  List<EnemyBossTorpedo> enemyBossTorpedoesToRemove;

  List<RocketExplosion> rocketExplosions;
  List<RocketExplosion> rocketExplosionsToRemove;
  List<EnemyBossExplosion> enemyBossExplosions;
  List<EnemyBossExplosion> enemyBossExplosionsToRemove;
  List<Explosion> explosions;
  List<Explosion> explosionsToRemove;
  List<AsteroidExplosion> asteroidExplosions;
  List<AsteroidExplosion> asteroidExplosionsToRemove;
  List<CrystalExplosion> crystalExplosions;
  List<CrystalExplosion> crystalExplosionsToRemove;

  List<Hit> hits;
  List<Hit> hitsToRemove;
  List<EnemyBossHit> enemyBossHits;
  List<EnemyBossHit> enemyBossHitsToRemove;

  int score;
  double scorePosX;
  double scorePosY;
  bool hasBeenHit;
  int lifeCount;
  int shieldCount;
  int lastShieldActivated;
  int lastEnemyBossAttack;
  int lastCrystal;
  int lastTimerCall;
}
