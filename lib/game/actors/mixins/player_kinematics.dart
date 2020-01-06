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

mixin PlayerKinematics on Actor {
  double _x = 0;
  double _y = 0;

  double _vX = 0;
  double _vY = 0;

  double get x => _x;

  double get y => _y;

  double get centerX => _x + imgCenterX;

  double get centerY => _y + imgCenterY;

  double get vX => _vX;

  double get vY => _vY;

  set vX(double vel) => _vX = vel.clamp(-5, 5);

  set vY(double vel) => _vY = vel.clamp(-5, 5);

  void initKinematics(Size boardSize) {
    _x = boardSize.width * 0.5;
    _y = boardSize.height - 2 * image.height;
  }

  void updateKinematics(Size boardSize) {
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
  }
}
