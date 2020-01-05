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
import 'package:spacefl/game/actors/enemy_boss_torpedo.dart';
import 'package:spacefl/game/actors/enemy_torpedo.dart';
import 'package:spacefl/game/game.dart';
import 'package:spacefl/game/math_utils.dart';

class SpaceShip extends Actor {
  static const maxHitPoints = 1;

  final Image _shieldImage;
  final Image _thrustImage;
  final Image _noThrustImage;

  double _x;
  double _y;
  double _size;
  double _radius;
  double _shieldRadius;

  bool _shieldUp = false;

  int _shieldCount = Game.shieldCount;
  int _hitPoints = SpaceShip.maxHitPoints;

  Duration _lastShieldActivated = Duration.zero;

  double vX = 0;
  double vY = 0;

  SpaceShip(Game game)
      : _noThrustImage = game.images.lookupImage('fighter'),
        _thrustImage = game.images.lookupImage('fighterThrust'),
        _shieldImage = game.images.lookupImage('shield') {
    assert(_noThrustImage != null && _noThrustImage != null && _shieldImage != null);

    _size = (width > height ? width : height).toDouble();

    _radius = _size * 0.5;
    _shieldRadius = _shieldImage.width * 0.5;

    reset(game);
  }

  void reset(Game game) {
    _x = game.state.boardSize.width * 0.5;
    _y = game.state.boardSize.height - 2 * image.height;
    _hitPoints = SpaceShip.maxHitPoints;
  }

  double get x => _x;

  double get y => _y;

  double get size => _size;

  double get radius => _radius;

  double get shieldRadius => _shieldRadius;

  bool get shieldUp => _shieldUp;

  int get shieldCount => _shieldCount;

  int get width => _noThrustImage.width;

  int get height => _noThrustImage.height;

  bool get isAlive => _hitPoints > 0;

  Image get image => _isMoving() ? _thrustImage : _noThrustImage;

  Image get shieldImage => _shieldImage;

  void update(Game game, Duration deltaT) {
    var state = game.state;
    final boardSize = state.boardSize;

    _x += vX;
    _y += vY;

    if (_x + width * 0.5 > boardSize.width) {
      _x = boardSize.width - width * 0.5;
    } else if (_x - width * 0.5 < 0) {
      _x = width * 0.5;
    }

    if (_y + height * 0.5 > boardSize.height) {
      _y = boardSize.height - height * 0.5;
    } else if (_y - height * 0.5 < 0) {
      _y = height * 0.5;
    }

    if (_shieldUp && _shieldTimeout(state.lastTimestamp)) {
      _shieldUp = false;
      _shieldCount--;
    }

    _performHitTests(game);
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
        _activateShield(game);
        return;
      case GameEvent.fireRocket:
        // TODO: Handle this case.
        return;
      case GameEvent.fireTorpedo:
        // TODO: Handle this case.
        return;
      default:
        return;
    }
  }

  void _activateShield(Game game) {
    if (_shieldCount > 0 && !_shieldUp) {
      _lastShieldActivated = game.state.lastTimestamp;
      _shieldUp = true;

      // TODO: play sound
//      playSound(deflectorShieldSound);
    }
  }

  bool _isMoving() => vX != 0 || vY != 0;

  bool _shieldTimeout(Duration timestamp) => timestamp - _lastShieldActivated > Game.deflectorShieldDuration;

  void _performHitTests(Game game) {
    final state = game.state;

    for (EnemyTorpedo et in state.enemyTorpedoes) {
      _checkTorpedoHit(game, et);
    }

    for (EnemyBossTorpedo ebt in state.enemyBossTorpedoes) {
      _checkBossTorpedoHit(game, ebt);
    }
  }

  bool _isTorpedoHit(EnemyTorpedo et) => _shieldUp
      ? isHitCircleCircle(et.x, et.y, et.radius, x, y, _shieldRadius)
      : isHitCircleCircle(et.x, et.y, et.radius, x, y, radius);

  bool _isBossTorpedoHit(EnemyBossTorpedo et) => _shieldUp
      ? isHitCircleCircle(et.x, et.y, et.radius, x, y, _shieldRadius)
      : isHitCircleCircle(et.x, et.y, et.radius, x, y, radius);

  void _checkTorpedoHit(Game game, EnemyTorpedo et) {
    final state = game.state;
    bool hit = _isTorpedoHit(et);

    if (hit) {
      state.destroyEnemyTorpedo(et);
      if (_shieldUp) {
        // TODO play sound
//          playSound(shieldHitSound);
      } else if (--_hitPoints <= 0) {
        state.destroySpaceShip(game);
        return;
      }
    }
  }

  void _checkBossTorpedoHit(Game game, EnemyBossTorpedo ebt) {
    final state = game.state;
    bool hit = _isBossTorpedoHit(ebt);

    if (hit) {
      state.destroyEnemyBossTorpedo(ebt);
      if (_shieldUp) {
        // TODO play sound
//          playSound(shieldHitSound);
      } else if (--_hitPoints <= 0) {
        state.destroySpaceShip(game);
        return;
      }
    }
  }

  // TODO: implement
  void addShield() {
    print("You get another shield!!");
  }
}
