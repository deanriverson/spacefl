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

typedef void OnEndFn();

mixin SheetAnimation {
  int _countX = 0;
  int _countY = 0;
  int _maxFrameX = 8;
  int _maxFrameY = 7;

  double _frameWidth = 256;
  double _frameHeight = 256;
  double _frameCenter = 128;
  double _scale;

  double get frameWidth => _frameWidth;
  double get frameHeight => _frameHeight;
  double get frameCenter => _frameCenter;
  double get scale => _scale;

  int get countX => _countX;
  int get countY => _countY;

  Image get image;
  double get x;
  double get y;

  void initFrames(int maxX, int maxY, double width, double height, double scale) {
    _maxFrameX = maxX;
    _maxFrameY = maxY;
    _frameWidth = width;
    _frameHeight = height ;
    _frameCenter = width / 2;
    _scale = scale;
  }

  void updateAnimation({OnEndFn onEnd}) {
    _countX++;
    if (_countX == _maxFrameX) {
      _countY++;
      if (_countX >= _maxFrameX && _countY >= _maxFrameY) {
        onEnd?.call();
        return;
      }
      _countX = 0;
      if (_countY >= _maxFrameY) {
        _countY = 0;
      }
    }
  }

  void paintAnimation(Canvas canvas, Paint paint) {
    final src = _srcRect(countX, countY, frameWidth, frameHeight);
    final dst = _dstRect(x, y, frameWidth, frameHeight, scale: scale);
    canvas.drawImageRect(image, src, dst, paint);
  }

  Rect _srcRect(int countX, int countY, double width, double height) =>
    Rect.fromLTWH(countX * width, countY * height, width, height);

  Rect _dstRect(double x, double y, double width, double height, {double scale = 1.0}) =>
    Rect.fromLTWH(
      x - _frameCenter * scale,
      y - _frameCenter * scale,
      width * scale,
      height * scale,
    );
}
