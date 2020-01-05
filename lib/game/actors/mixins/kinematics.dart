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
import 'package:spacefl/game/actors/mixins/kinematics_opts.dart';
import 'package:spacefl/game/game.dart';

typedef void OffBoardCallback();
typedef double RotationCallback();

/// Kinematics determines the Actor's initial x, y, rotation, and their corresponding
/// velocities by assigning random values and then updating the Actor's position on
/// each frame.  It would be good to give more control over how the initial values
/// are generated.  Right now the initial rotation can be overridden but none of the
/// other values can.
mixin Kinematics on Actor {
  KinematicsOpts get kinematicsOpts;

  double _x = 0;
  double _y = 0;
  double _rot = 0;
  double _vX = 0;
  double _vY = 0;
  double _vR = 0;
  double _vYVariation = 0;

  double get centerX => _x + imgCenterX;

  double get centerY => _y + imgCenterY;

  double get x => _x;

  double get y => _y;

  double get rotation => _rot;

  double get vX => _vX;

  double get vY => _vY;

  double get vR => _vR;

  void initKinematics(Game game, {RotationCallback initialRotation}) {
    final rnd = game.state.random;
    final boardSize = game.state.boardSize;

    // Random Size
    scale = game.state.random.nextDouble() * kinematicsOpts.scaleSpread + kinematicsOpts.scaleOffset;

    // Random Position
    _x = rnd.nextDouble() * boardSize.width;
    _y = -image.height * scale;

    // Random Speed
    _vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    final xVariation = kinematicsOpts.xVariation;
    final firstQuarterWidth = boardSize.width * 0.25;
    final lastQuarterWidth = boardSize.width * 0.75;

    // Velocity
    if (x < firstQuarterWidth) {
      _vX = rnd.nextDouble() * Game.velocityFactorX;
    } else if (x > lastQuarterWidth) {
      _vX = -rnd.nextDouble() * Game.velocityFactorX;
    } else {
      _vX = ((rnd.nextDouble() * xVariation) - xVariation * 0.5) * Game.velocityFactorX;
    }

    _vY = (((rnd.nextDouble() * 1.5) + kinematicsOpts.minSpeedY * 1 / scale) * _vYVariation) * Game.velocityFactorY;

    _rot = initialRotation?.call() ?? 0.0;

    if (kinematicsOpts.hasSpeedR) {
      double rotDir = rnd.nextBool() ? -1.0 : 1.0;
      _vR = (((rnd.nextDouble()) * 0.5) + kinematicsOpts.minSpeedR) * Game.velocityFactorR * rotDir;
    } else {
      _vR = 0;
    }
  }

  /// Update the Actor's position on the board.  If the actor has gone off the board,
  /// the offBoardFn callback will be triggered.
  void updateKinematics(Size boardSize, {OffBoardCallback whenOffBoard}) {
    _x += _vX;
    _y += _vY;
    _rot += _vR;

    if (whenOffBoard != null && isOffBoard(boardSize, x, y, size)) {
        whenOffBoard();
    }
  }
}

bool isOffBoard(Size boardSize, double x, double y, double size) =>
  x < -size || x > boardSize.width + size || y < -size || y > boardSize.height + size;