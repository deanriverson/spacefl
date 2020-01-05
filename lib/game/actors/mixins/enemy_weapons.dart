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

import 'package:spacefl/game/actors/mixins/kinematics.dart';
import 'package:spacefl/game/actors/space_ship.dart';
import 'package:spacefl/game/game.dart';

typedef void OnFireFn();

mixin EnemyWeapons on Kinematics {
  static const minShotSpacing = 15.0;

  double _lastShotY = 0;

  void initWeapons(Game game) {
    _lastShotY = 0;
  }

  void aimWeapons(SpaceShip player, {OnFireFn onFire}) {
    if (_isLinedUpWith(player) && y - _lastShotY > minShotSpacing) {
      _lastShotY = y;
      onFire?.call();
    }
  }

  bool _isLinedUpWith(SpaceShip spaceShip) =>
    x > spaceShip.x - Game.enemyFireSensitivity && x < spaceShip.x + Game.enemyFireSensitivity;
}

