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
import 'package:spacefl/game_state.dart';

class _GameImages {
  static const BACKGROUND = 'assets/images/background.jpg';

  Image _backgroundImage;

  get backgroundImage => _backgroundImage;

  Future<void> loadImages() async {
    _backgroundImage = await _loadImage(BACKGROUND);
  }

  Future<Image> _loadImage(String key) async {
    final byteData = await rootBundle.load(key);
    final codec = await instantiateImageCodec(byteData.buffer.asUint8List());
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class Game {
  static Game _instance;

  final state = GameState();
  final images = _GameImages();

  Game._();

  factory Game.instance() {
    if (_instance == null) {
      _instance = Game._();
      _instance.images.loadImages();
    }

    return Game._instance;
  }
}
