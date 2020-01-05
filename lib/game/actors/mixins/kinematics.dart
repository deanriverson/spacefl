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

  mixin Kinematics on Actor {
  KinematicsOpts get kinematicsOpts;

  double _x = 0;
  double _y = 0;
  double _rot = 0;
  double _vX = 0;
  double _vY = 0;
  double _vR = 0;
  double _width = 0;
  double _height = 0;
  double _scale = 0.0;
  double _size = 0;
  double _vYVariation = 0;

  double _imgCenterX = 0;
  double _imgCenterY = 0;

  double get x => _x;
  double get y => _y;
  double get rotation => _rot;
  double get vX => _vX;
  double get vY => _vY;
  double get vR => _vR;
  double get width => _width;
  double get height => _height;
  double get scale => _scale;
  double get size => _size;

  double get radius => _size * 0.5;
  double get imgCenterX => _imgCenterX;
  double get imgCenterY => _imgCenterY;
  double get centerX => _x + _imgCenterX;
  double get centerY => _y + _imgCenterY;

  void initKinematics(Game game, {RotationCallback initialRotation}) {
    final rnd = game.state.random;
    final boardSize = game.state.boardSize;

    _x = rnd.nextDouble() * boardSize.width;
    _y = -image.height.toDouble();

    // Random Size
    _scale = game.state.random.nextDouble() * kinematicsOpts.scaleSpread + kinematicsOpts.scaleOffset;

    // Random Speed
    _vYVariation = (rnd.nextDouble() * 0.5) + 0.2;

    _width = image.width * _scale;
    _height = image.height * _scale;
    _size = width > height ? width : height;

    _imgCenterX = image.width * 0.5;
    _imgCenterY = image.height * 0.5;

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

    _vY = (((rnd.nextDouble() * 1.5) + kinematicsOpts.minSpeedY * 1/_scale) * _vYVariation) * Game.velocityFactorY;

    _rot = initialRotation?.call() ?? 0.0;

    if (kinematicsOpts.hasSpeedR) {
      double rotDir = rnd.nextBool() ? -1.0 : 1.0;
      _vR = (((rnd.nextDouble()) * 0.5) + kinematicsOpts.minSpeedR) * Game.velocityFactorR * rotDir;
    } else {
      _vR = 0;
    }
  }

  /// Update the Actor's position on the board.  If the actor has gone off the board,
  /// the offBoardFn callback will be triggered.  By default the actor is just
  /// reinitialized if it leaves the board.
  void updateKinematics(Game game, {OffBoardCallback whenOffBoard}) {
    _x += _vX;
    _y += _vY;
    _rot += _vR;

    if (isOffBoard(game.state.boardSize)) {
      if (whenOffBoard != null) {
        whenOffBoard();
      } else {
        initKinematics(game);
      }
    }
  }

  bool isOffBoard(Size boardSize) => x < -size || x > boardSize.width + size || y > boardSize.height + size;
}