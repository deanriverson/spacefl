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
import 'package:image/image.dart' as img;
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
    Image image = frameInfo.image;

    print('loaded ${ia.assetPath} as size ${image.width} x ${image.height}');

    // Web platform doesn't support targetWidth/targetHeight so we
    // have to resize manually for now
    if (ia.hasTargetSize && image.width != ia.targetWidth || image.height != ia.targetHeight) {
      print("Detected that resize is needed...");
      Image resized = await _resizeIfNeeded(ia.ext, byteData, image.width, image.height, ia.targetWidth, ia.targetHeight);

      if (resized == null) {
        return image;
      }

      image.dispose();
      return resized;
    }

    return image;
  }

  /// Resize the image using the image library if it doesn't match the target width/height.
  Future<Image> _resizeIfNeeded(String ext, ByteData byteData, int width, int height, int targetWidth, int targetHeight) async {
    try {
      final imgData = byteData.buffer.asUint8List();
      img.Image libImage = ext == 'png' ? img.decodePng(imgData) : img.decodeJpg(imgData);

      print('...created libImage: $libImage');
      img.Image resized = img.copyResize(libImage, width: targetWidth, height: targetHeight);
      print('...resized libImage: $resized');

      print('...created resized image ${resized.width} x ${resized.height}');
      final codec = await instantiateImageCodec(img.encodePng(resized));
      final frameInfo = await codec.getNextFrame();
      Image result = frameInfo.image;

      print('Resize needed: image loaded as $width x $height, resized to ${result.width} x ${result.height}');
      return result;
    } catch(e) {
      print('Exception resizing image!! $e');
    }
    return null;
  }
}
