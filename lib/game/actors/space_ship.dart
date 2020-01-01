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

import 'package:spacefl/game/game.dart';

class SpaceShip {
  final Image _shieldImage;
  final Image _thrustImage;
  final Image _noThrustImage;

  double _x;
  double _y;
  double _size;
  double _radius;
  double _shieldRadius;

  double vX;
  double vY;
  bool shield;

  SpaceShip(Game game)
      : _noThrustImage = game.images.spaceShipImage,
        _thrustImage = game.images.spaceShipThrustImage,
        _shieldImage = game.images.deflectorShieldImage {
    _size = (width > height ? width : height).toDouble();
    _radius = _size * 0.5;
    vX = 0;
    vY = 0;

    shield = false;
    _shieldRadius = _shieldImage.width * 0.5;

    resetPosition(game);
  }

  void resetPosition(Game game) {
    _x = game.state.boardSize.width * 0.5;
    _y = game.state.boardSize.height - 2 * image.height;
  }

  double get x => _x;

  double get y => _y;

  double get size => _size;

  double get radius => _radius;

  double get shieldRadius => _shieldRadius;

  int get width => _noThrustImage.width;

  int get height => _noThrustImage.height;

  Image get image => _isMoving() ? _thrustImage : _noThrustImage;

  Image get shieldImage => _shieldImage;

  void update(Game game, Duration timestamp) {
    final boardSize = game.state.boardSize;

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

    if (shield) {
      if (timestamp - game.state.lastShieldActivated > Game.deflectorShieldDuration) {
        shield = false;
        game.state.shieldCount--;
      }
    }
  }

  bool _isMoving() => vX != 0 || vY != 0;
}
