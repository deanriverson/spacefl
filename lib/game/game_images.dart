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

import 'dart:math';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:spacefl/game/assets/image_asset.dart';

class GameImages {
  final _random = Random();
  final _imageLookup = <String, Image>{};

  Image lookupImage(String alias) => _imageLookup[alias];

  Image lookupImageWithIndex(String alias, int idx) => _imageLookup['$alias$idx'];

  Image get randomAsteroidImage =>
    lookupImageWithIndex('asteroid', _random.nextInt(asteroidImageCount) + 1);

  Image get randomEnemyImage =>
    lookupImageWithIndex('enemy', _random.nextInt(enemyImageCount) + 1);

  Future<void> loadImages() async {
    for (ImageAsset ia in imageAssets) {
      _imageLookup[ia.alias] = await _loadImage(ia);
    }
  }

  Future<Image> _loadImage(ImageAsset ia) async {
    final byteData = await rootBundle.load(ia.assetPath);
    final codec = await instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: ia.targetWidth,
      targetHeight: ia.targetHeight,
    );

    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
