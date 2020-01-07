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

class ImageAsset {
  static const _imageAssetPath = 'assets/images';

  /// The name of the asset must. Must match the asset in pubspec.yaml when it is
  /// appended to the _imagePath with the [ext] is added.
  final String name;

  /// The file extension of the asset.  Must match the asset's file extension in
  /// pubspec.yaml.  Defaults to 'png'.
  final String ext;

  /// The alias is used to look up the asset in the map.  Defaults to [name] if not given.
  final String alias;

  /// An optional width used to scale the asset after it's loaded
  final int targetWidth;

  /// An optional height used to scale the asset after it's loaded
  final int targetHeight;

  const ImageAsset(String name, {String ext, this.targetWidth, this.targetHeight, String alias})
    : this.name = name,
      this.ext = ext ?? 'png',
      this.alias = alias ?? name;

  const ImageAsset.square(String name, int size, {String ext, String alias})
    : this(name, targetWidth: size, targetHeight: size, ext: ext, alias: alias);

  String get assetPath => '$_imageAssetPath/$name.$ext';
}

const _asteroidImageSizes = [140, 140, 140  , 110, 100, 120, 110, 100, 130, 120, 140];
const _enemyImageSizes = [56, 50, 68];
const _enemyBossImageSizes = [100, 100, 100, 100, 100];

final asteroidImageCount = _asteroidImageSizes.length;
final enemyImageCount = _enemyImageSizes.length;
final enemyBossImageCount = _enemyBossImageSizes.length;

/// Note that indexed assets are 1-based!
String indexedAssetName(String assetName, int idx) => '$assetName${idx + 1}';

final imageAssets = [
  for (int i = 0; i < asteroidImageCount; ++i)
    ImageAsset.square(indexedAssetName('asteroid', i), _asteroidImageSizes[i]),

  ImageAsset('asteroidExplosion', targetWidth: 2048, targetHeight: 1792),
  ImageAsset('background', ext: 'jpg'),
  ImageAsset.square('crystal', 100),
  ImageAsset('crystalExplosion', targetWidth: 400, targetHeight: 700),
  ImageAsset.square('deflectorshield', 100, alias: 'shield'),
  ImageAsset.square('deflectorshield', 16, alias: 'miniShield'),

  for (int i = 0; i < enemyImageCount; ++i)
    ImageAsset.square(indexedAssetName('enemy', i), _enemyImageSizes[i]),

  for (int i = 0; i < enemyBossImageCount; ++i)
    ImageAsset.square(indexedAssetName('enemyBoss', i), _enemyBossImageSizes[i]),

  ImageAsset('enemyBossExplosion', targetWidth: 800, targetHeight: 1400),
  ImageAsset.square('enemyBossTorpedo', 26),
  ImageAsset.square('enemyTorpedo', 21),
  ImageAsset('explosion', targetWidth: 960, targetHeight: 768),
  ImageAsset.square('fighter', 48),
  ImageAsset.square('fighterThrust', 48),
  ImageAsset.square('fighter', 48, alias: 'miniFighter'),
  ImageAsset('rocket', targetWidth: 17, targetHeight: 50),
  ImageAsset('rocketExplosion', targetWidth: 512, targetHeight: 896),
  ImageAsset('spaceshipExplosion', targetWidth: 800, targetHeight: 600, alias: 'fighterExplosion'),
  ImageAsset('torpedo', targetWidth: 17, targetHeight: 20),
  ImageAsset('torpedoHit2', targetWidth: 400, targetHeight: 160, alias: 'hit'),
  ImageAsset('torpedoHit', targetWidth: 400, targetHeight: 160, alias: 'enemyBossHit'),
];
