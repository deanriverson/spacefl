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

import 'package:flutter/material.dart';
import 'package:spacefl/game/actors/star.dart';
import 'package:spacefl/game/game.dart';

final _imagePaint = Paint();
final _starPaint = Paint()
    ..color = Color.fromARGB(230, 255, 255, 255);


void drawFps(Canvas canvas, Size size, Duration deltaT) {
  double fps = Duration.microsecondsPerSecond / deltaT.inMicroseconds;
  TextSpan span = new TextSpan(text: '${fps.toStringAsFixed(1)} FPS');
  TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  tp.layout();
  tp.paint(canvas, new Offset(size.width - tp.width - 5.0, 30.0));
}

void drawBackground(Canvas canvas, Size size, Game game) {
  if (!Game.SHOW_BACKGROUND) {
    return;
  }

  final state = game.state;
  final backgroundImage = game.images.backgroundImage;

  state.backgroundViewportY -= 0.5;
  if (state.backgroundViewportY <= 0) {
    state.backgroundViewportY = 2079; //backgroundImg.getHeight() - HEIGHT;
  }

  final src = Rect.fromLTWH(0, state.backgroundViewportY, size.width, size.height);
  final dst = Rect.fromLTWH(0, 0, size.width, size.height);

  canvas.drawImageRect(backgroundImage, src, dst, _imagePaint);
}

void drawStars(Canvas canvas, Size size, Game game) {
  if (Game.SHOW_STARS) {
    for (int i = 0; i < Game.NO_OF_STARS; i++) {
      Star star = game.state.stars[i];
      canvas.drawOval(star.rect, _starPaint);
    }
  }
}