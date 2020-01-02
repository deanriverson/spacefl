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

import 'dart:collection';
import 'dart:ui';

import 'package:flutter/services.dart';

const _imagePath = 'assets/images';
const _backgroundAsset = '$_imagePath/background.jpg';
const _crystalAsset = '$_imagePath/crystal.png';
const _spaceShipAsset = '$_imagePath/fighter.png';
const _torpedoAsset = '$_imagePath/torpedo.png';
const _rocketAsset = '$_imagePath/rocket.png';
const _spaceShipThrustAsset = '$_imagePath/fighterThrust.png';
const _deflectorShieldAsset = '$_imagePath/deflectorshield.png';

const _explosionAsset = '$_imagePath/explosion.png';
const _asteroidExplosionAsset = '$_imagePath/asteroidExplosion.png';

const _asteroidImageCount = 11;
const _asteroidImageSizes = [140, 140, 140, 110, 100, 120, 110, 100, 130, 120, 140];

const _enemyImageCount = 3;
const _enemyImageSizes = [56, 50, 68];

typedef String PathGenerator(int idx);

PathGenerator _createPathGenerator(String assetName) => (int idx) => '$_imagePath/$assetName${idx + 1}.png';

class GameImages {
  Image _backgroundImage;
  Image _crystalImage;
  Image _spaceShipImage;
  Image _spaceShipThrustImage;
  Image _miniSpaceShipImage;
  Image _deflectorShieldImage;
  Image _miniDeflectorShieldImage;
  Image _torpedoImage;
  Image _rocketImage;
  Image _explosionImage;
  Image _asteroidExplosionImage;

  final _enemyImages = List<Image>(_enemyImageCount);
  final _asteroidImages = List<Image>(_asteroidImageCount);

  Image get backgroundImage => _backgroundImage;

  Image get crystalImage => _crystalImage;

  Image get spaceShipImage => _spaceShipImage;

  Image get spaceShipThrustImage => _spaceShipThrustImage;

  Image get miniSpaceShipImage => _miniSpaceShipImage;

  Image get deflectorShieldImage => _deflectorShieldImage;

  Image get miniDeflectorShieldImage => _miniDeflectorShieldImage;

  Image get torpedoImage => _torpedoImage;

  Image get rocketImage => _rocketImage;

  Image get explosionImage => _explosionImage;

  Image get asteroidExplosionImage => _asteroidExplosionImage;

  List<Image> get enemyImages => UnmodifiableListView(_enemyImages);

  List<Image> get asteroidImages => UnmodifiableListView(_asteroidImages);

  Future<void> loadImages() async {
    _backgroundImage = await _loadImage(_backgroundAsset);
    _crystalImage = await _loadImage(_crystalAsset, targetWidth: 100, targetHeight: 100);

    _spaceShipImage = await _loadImage(_spaceShipAsset, targetWidth: 48, targetHeight: 48);
    _spaceShipThrustImage = await _loadImage(_spaceShipThrustAsset, targetWidth: 48, targetHeight: 48);
    _miniSpaceShipImage = await _loadImage(_spaceShipAsset, targetWidth: 16, targetHeight: 16);

    _deflectorShieldImage = await _loadImage(_deflectorShieldAsset, targetWidth: 100, targetHeight: 100);
    _miniDeflectorShieldImage = await _loadImage(_deflectorShieldAsset, targetWidth: 16, targetHeight: 16);

    _torpedoImage = await _loadImage(_torpedoAsset, targetWidth: 17, targetHeight: 20);
    _rocketImage = await _loadImage(_rocketAsset, targetWidth: 17, targetHeight: 50);

    _explosionImage = await _loadImage(_explosionAsset, targetWidth: 960, targetHeight: 768);
    _asteroidExplosionImage = await _loadImage(_asteroidExplosionAsset, targetWidth: 2048, targetHeight: 1792);

    final enemyPath = _createPathGenerator('enemy');
    final asteroidPath = _createPathGenerator('asteroid');

    for (int i = 0; i < _enemyImageCount; ++i) {
      final size = _enemyImageSizes[i];
      _enemyImages[i] = await _loadImage(enemyPath(i), targetWidth: size, targetHeight: size);
    }

    for (int i = 0; i < _asteroidImageCount; ++i) {
      final size = _asteroidImageSizes[i];
      _asteroidImages[i] = await _loadImage(asteroidPath(i), targetWidth: size, targetHeight: size);
    }
  }

  Future<Image> _loadImage(String key, {int targetWidth, int targetHeight}) async {
    final byteData = await rootBundle.load(key);
    final codec = await instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );

    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
