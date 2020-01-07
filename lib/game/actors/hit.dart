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
import 'package:spacefl/game/actors/mixins/sheet_animation.dart';
import 'package:spacefl/game/actors/mixins/simple_kinematics.dart';
import 'package:spacefl/game/game.dart';

class Hit extends Actor with SimpleKinematics, SheetAnimation {
  Hit(Game game, double x, double y, double vX, double vY) {
    image = game.images.lookupImage('hit');
    initFrames(5, 2, 80, 80, 1.0);
    initKinematics(x, y, vX, vY);
  }

  void update(Game game, Duration deltaT) {
    updateKinematics(game.state.boardSize);
    updateAnimation(onEnd: () => game.state.destroyHit(this));
  }
}
