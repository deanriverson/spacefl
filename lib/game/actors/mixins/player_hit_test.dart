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

import 'package:spacefl/game/actors/mixins/enemy_hit_test.dart' show OnHitFn;
import 'package:spacefl/game/actors/mixins/kinematics.dart';
import 'package:spacefl/game/actors/mixins/simple_kinematics.dart';
import 'package:spacefl/game/game.dart';
import 'package:spacefl/game/game_state.dart';
import 'package:spacefl/game/math_utils.dart';

mixin PlayerHitTest {
  bool _shieldUp = false;
  int _shieldCount = Game.shieldCount;
  Duration _lastShieldActivated = Duration.zero;

  double get x;

  double get y;

  double get centerX;

  double get centerY;

  double get radius;

  Image get shieldImage;

  double get shieldRadius => shieldImage.width * 0.5;

  bool get shieldUp => _shieldUp;

  int get shieldCount => _shieldCount;

  void incShieldCount() => _shieldCount++;

  /// Initialize shields and hit testing state
  void initHitTesting() {
    _shieldUp = false;
    _shieldCount = Game.shieldCount;
    _lastShieldActivated = Duration.zero;
  }

  /// Update shield status and do hit testing.  The [onHit] callback is optional.  If not
  /// provided, no hit testing will be done (i.e. space ship can not be hit - may be useful
  /// during respawn?).
  void doHitTest(Game game, {OnHitFn onHit}) {
    if (_shieldUp && _shieldTimeout(game.state.lastTimestamp)) {
      _shieldUp = false;
      _shieldCount--;
    }

    if (onHit != null) {
      _performHitTests(game.state, onHit);
    }
  }

  void activateShield(GameState state) {
    if (_shieldCount <= 0 || _shieldUp) {
      return;
    }

    _lastShieldActivated = state.lastTimestamp;
    _shieldUp = true;
  }

  bool _shieldTimeout(Duration timestamp) => timestamp - _lastShieldActivated > Game.deflectorShieldDuration;

  void _performHitTests(GameState state, OnHitFn onHit) {
    for (var actor in state.asteroids) if (_isHit(actor)) onHit(actor);
    for (var actor in state.crystals) if (_isHit(actor)) onHit(actor);

    for (var actor in state.enemies) if (_isHit(actor)) onHit(actor);
    for (var actor in state.enemyTorpedoes) if (_isSimpleHit(actor)) onHit(actor);

    for (var actor in state.enemyBosses) if (_isHit(actor)) onHit(actor);
    for (var actor in state.enemyBossTorpedoes) if (_isSimpleHit(actor)) onHit(actor);
  }

  bool _isHit(Kinematics actor) => _shieldUp
      ? isHitCircleCircle(actor.centerX, actor.centerY, actor.radius, x, y, shieldRadius)
      : isHitCircleCircle(actor.centerX, actor.centerY, actor.radius, x, y, radius);

  bool _isSimpleHit(SimpleKinematics actor) => _shieldUp
      ? isHitCircleCircle(actor.x, actor.y, actor.radius, x, y, shieldRadius)
      : isHitCircleCircle(actor.x, actor.y, actor.radius, x, y, radius);
}
