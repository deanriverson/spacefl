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

import 'package:spacefl/game/actors/actor.dart';
import 'package:spacefl/game/actors/mixins/kinematics.dart';
import 'package:spacefl/game/actors/rocket.dart';
import 'package:spacefl/game/actors/torpedo.dart';
import 'package:spacefl/game/game.dart';
import 'package:spacefl/game/math_utils.dart';

typedef void OnHitFn(Actor ordinance);

mixin EnemyHitTest on Kinematics {
  void doHitTest(Game game, {OnHitFn onHit}) {
    final state = game.state;

    for (Torpedo t in state.torpedoes) {
      if (isHitCircleCircle(t.x, t.y, t.radius, centerX, centerY, radius)) {
        state.destroyTorpedo(t);
        onHit?.call(t);
        return;
      }
    }

    for (Rocket r in state.rockets) {
      if (isHitCircleCircle(r.x, r.y, r.radius, centerX, centerY, radius)) {
        state.destroyRocket(r);
        onHit?.call(r);
        return;
      }
    }
  }
}