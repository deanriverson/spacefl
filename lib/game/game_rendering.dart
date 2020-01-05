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

import 'package:flutter/rendering.dart';
import 'package:spacefl/game/actors/enemy_torpedo.dart';
import 'package:spacefl/game/actors/mixins/sheet_animation.dart';
import 'package:spacefl/game/actors/rocket.dart';
import 'package:spacefl/game/actors/torpedo.dart';
import 'package:spacefl/game/game.dart';

final _imagePaint = Paint();

final _starPaint = Paint()
  ..color = Color.fromARGB(230, 255, 255, 255);

void drawFps(Canvas canvas, Game game) {
  final size = game.state.boardSize;
  double fps = Duration.microsecondsPerSecond / game.state.deltaT.inMicroseconds;
  TextSpan span = new TextSpan(text: '${fps.toStringAsFixed(1)} FPS');
  TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  tp.layout();
  tp.paint(canvas, new Offset(size.width - tp.width - 5.0, 30.0));
}

void drawBackground(Canvas canvas, Game game) {
  if (!Game.showBackground) {
    return;
  }

  final state = game.state;
  final size = state.boardSize;
  final backgroundImage = game.images.lookupImage('background');

  state.backgroundViewportY -= 0.5;
  if (state.backgroundViewportY <= 0) {
    state.backgroundViewportY = 2079; //backgroundImg.getHeight() - HEIGHT;
  }

  final src = Rect.fromLTWH(0, state.backgroundViewportY, size.width, size.height);
  final dst = Rect.fromLTWH(0, 0, size.width, size.height);

  canvas.drawImageRect(backgroundImage, src, dst, _imagePaint);
}

void drawStars(Canvas canvas, Game game) {
  if (Game.showStars) {
    for (final star in game.state.stars) {
      canvas.drawOval(star.rect, _starPaint);
    }
  }
}

void drawAsteroids(Canvas canvas, Game game) {
  if (Game.showAsteroids) {
    for (final a in game.state.asteroids) {
      canvas.save();

      canvas.translate(a.centerX, a.centerY);
      canvas.rotate(a.rotation);
      canvas.scale(a.scale, a.scale);
      canvas.translate(-a.imgCenterX, -a.imgCenterY);
      canvas.drawImage(a.image, Offset.zero, _imagePaint);

      canvas.restore();
    }
  }
}

void drawEnemies(Canvas canvas, Game game) {
  for (final e in game.state.enemies) {
    canvas.save();

    canvas.translate(e.centerX, e.centerY);
    canvas.rotate(e.rotation);
    canvas.translate(-e.imgCenterX, -e.imgCenterY);
    canvas.drawImage(e.image, Offset.zero, _imagePaint);

    canvas.restore();
  }

  for (final e in game.state.enemyBosses) {
    canvas.save();

    canvas.translate(e.centerX, e.centerY);
    canvas.rotate(e.rotation);
    canvas.translate(-e.imgCenterX, -e.imgCenterY);
    canvas.drawImage(e.image, Offset.zero, _imagePaint);

    canvas.restore();
  }
}

void drawCrystals(Canvas canvas, Game game) {
  for (final c in game.state.crystals) {
    canvas.save();

    canvas.translate(c.centerX, c.centerY);
    canvas.rotate(c.rotation);
    canvas.translate(-c.centerX, -c.centerY);
    canvas.drawImage(c.image, Offset(c.x, c.y), _imagePaint);

    canvas.restore();
  }
}

void drawSpaceShip(Canvas canvas, Game game) {
  final spaceShip = game.state.spaceShip;

  if (!spaceShip.isAlive) {
    return;
  }

  final offset = Offset(spaceShip.x - spaceShip.radius, spaceShip.y - spaceShip.radius);
  canvas.drawImage(spaceShip.image, offset, _imagePaint);

  if (spaceShip.shieldUp) {
    final opacity = game.state.random.nextDouble() * 0.5 + 0.1;
    final shieldPaint = Paint()
      ..color = Color(0xFFFFFFFF).withOpacity(opacity);

    final offset = Offset(spaceShip.x - spaceShip.shieldRadius, spaceShip.y - spaceShip.shieldRadius);

    canvas.drawImage(spaceShip.shieldImage, offset, shieldPaint);
  }
}

void drawShots(Canvas canvas, Game game) {
  for (Torpedo t in game.state.torpedoes) {
    _drawImageWithOffset(canvas, t.image, t.x, t.y, t.radius, t.radius);
  }

  for (Rocket r in game.state.rockets) {
    _drawImageWithOffset(canvas, r.image, r.x, r.y, r.imgCenterX, r.imgCenterY);
  }

  for (EnemyTorpedo et in game.state.enemyTorpedoes) {
    _drawImageWithOffset(canvas, et.image, et.x, et.y, et.radius, et.radius);
  }
}

void drawExplosions(Canvas canvas, Game game) {
  final state = game.state;

  _drawSheetAnimations(canvas, state.asteroidExplosions);
  _drawSheetAnimations(canvas, state.crystalExplosions);
  _drawSheetAnimations(canvas, state.enemyBossExplosions);
  _drawSheetAnimations(canvas, state.explosions);
  _drawSheetAnimations(canvas, state.rocketExplosions);

  if (!state.spaceShip.isAlive) {
    state.spaceShipExplosion.paintAnimation(canvas, _imagePaint);
  }
}

void drawUI(Canvas canvas, Game game) {
  // TODO: Draw shield indicator
//    ctx.setStroke(Game.scoreColor);
//    ctx.setFill(Game.scoreColor);
//    ctx.strokeRect(Game.shieldIn, SHIELD_INDICATOR_Y, SHIELD_INDICATOR_WIDTH, SHIELD_INDICATOR_HEIGHT);
//    ctx.fillRect(Game.shieldIn, SHIELD_INDICATOR_Y,
//        SHIELD_INDICATOR_WIDTH - SHIELD_INDICATOR_WIDTH * delta / DEFLECTOR_SHIELD_TIME, SHIELD_INDICATOR_HEIGHT);

  return;
}

void _drawSheetAnimations(Canvas canvas, List<SheetAnimation> anims) {
  for (SheetAnimation anim in anims) {
    anim.paintAnimation(canvas, _imagePaint);
  }
}

void _drawImageWithOffset(Canvas canvas,
  Image image,
  double x,
  double y,
  double xOffset,
  double yOffset,
  {Paint paint}) {
  final offset = Offset(x - xOffset, y - yOffset);
  canvas.drawImage(image, offset, paint ?? _imagePaint);
}
