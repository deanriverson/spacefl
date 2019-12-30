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

import 'package:flutter/services.dart';

const _imagePath = 'assets/images';
const _background = '$_imagePath/background.jpg';

const _asteroidImageCount = 11;
const _asteroidTargetSizes = [140, 140, 140, 110, 100, 120, 110, 100, 130, 120, 140];

String _genAsteroidPath(int idx) => '$_imagePath/asteroid${idx + 1}.png';

class GameImages {
  Image _backgroundImage;

  Image get backgroundImage => _backgroundImage;

  final _asteroidImages = List<Image>(_asteroidImageCount);

  List<Image> get asteroidImages => _asteroidImages;

  Future<void> loadImages() async {
    _backgroundImage = await _loadImage(_background);

    for (int i = 0; i < _asteroidImageCount; ++i) {
      final size = _asteroidTargetSizes[i];
      _asteroidImages[i] = await _loadImage(_genAsteroidPath(i), targetWidth: size, targetHeight: size);
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
