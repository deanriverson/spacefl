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
import 'package:spacefl/game/actors/asteroid_explosion.dart';
import 'package:spacefl/game/actors/enemy_torpedo.dart';
import 'package:spacefl/game/actors/rocket.dart';
import 'package:spacefl/game/actors/rocket_explosion.dart';
import 'package:spacefl/game/actors/rocket_explosion.dart';
import 'package:spacefl/game/actors/rocket_explosion.dart';
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
  final backgroundImage = game.images.backgroundImage;

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

      canvas.translate(a.cX, a.cY);
      canvas.rotate(a.rot);
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

    canvas.translate(e.x, e.y);
    canvas.rotate(e.rot);
    canvas.drawImage(e.image, Offset(-e.radius, -e.radius), _imagePaint);

    canvas.restore();
  }

//  for (final boss in game.state.enemyBosses) {
//  }
}

void drawCrystals(Canvas canvas, Game game) {
  for (final c in game.state.crystals) {
    canvas.save();

    canvas.translate(c.cX, c.cY);
    canvas.rotate(c.rot);
    canvas.translate(-c.imgCenterX, -c.imgCenterY);
    canvas.drawImage(c.image, Offset.zero, _imagePaint);

    canvas.restore();
  }
}

void drawSpaceShip(Canvas canvas, Game game) {
  final spaceShip = game.state.spaceShip;
  final offset = Offset(spaceShip.x - spaceShip.radius, spaceShip.y - spaceShip.radius);
  canvas.drawImage(spaceShip.image, offset, _imagePaint);

  if (spaceShip.shieldUp) {
    final opacity = game.state.random.nextDouble() * 0.5 + 0.1;
    final shieldPaint = Paint()
      ..color = Color(0xFFFFFFFF).withOpacity(opacity);

    final offset = Offset(spaceShip.x - spaceShip.shieldRadius, spaceShip.y - spaceShip.shieldRadius);

    canvas.drawImage(spaceShip.shieldImage, offset, shieldPaint);

    // TODO: Draw shield indicator.  Do this here or in a separate drawUI function?
//    ctx.setStroke(Game.scoreColor);
//    ctx.setFill(Game.scoreColor);
//    ctx.strokeRect(Game.shieldIn, SHIELD_INDICATOR_Y, SHIELD_INDICATOR_WIDTH, SHIELD_INDICATOR_HEIGHT);
//    ctx.fillRect(Game.shieldIn, SHIELD_INDICATOR_Y,
//        SHIELD_INDICATOR_WIDTH - SHIELD_INDICATOR_WIDTH * delta / DEFLECTOR_SHIELD_TIME, SHIELD_INDICATOR_HEIGHT);
  }
}

void drawShots(Canvas canvas, Game game) {
  for (Torpedo t in game.state.torpedoes) {
    _drawImageWithOffset(canvas, t.image, t.x, t.y, t.radius, t.radius);
  }

  for (Rocket r in game.state.rockets) {
    _drawImageWithOffset(canvas, r.image, r.x, r.y, r.halfWidth, r.halfHeight);
  }

  for (EnemyTorpedo et in game.state.enemyTorpedoes) {
    _drawImageWithOffset(canvas, et.image, et.x, et.y, et.radius, et.radius);
  }
}

void drawExplosions(Canvas canvas, Game game) {
  _drawAsteroidExplosions(canvas, game.state.asteroidExplosions, game.images.asteroidExplosionImage);
  _drawRocketExplosions(canvas, game.state.rocketExplosions, game.images.rocketExplosionImage);
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

void _drawAsteroidExplosions(Canvas canvas, List<AsteroidExplosion> explosions, Image img) {
  final frameWidth = AsteroidExplosion.frameWidth;
  final frameHeight = AsteroidExplosion.frameHeight;

  for (AsteroidExplosion exp in explosions) {
    final src = _srcRect(exp.countX, exp.countY, frameWidth, frameHeight);
    final dst = _dstRect(exp.x, exp.y, frameWidth, frameHeight, exp.scale);
    canvas.drawImageRect(img, src, dst, _imagePaint);
  }
}

void _drawRocketExplosions(Canvas canvas, List<RocketExplosion> explosions, Image img) {
  final frameWidth = RocketExplosion.frameWidth;
  final frameHeight = RocketExplosion.frameHeight;

  for (RocketExplosion exp in explosions) {
    final src = _srcRect(exp.countX, exp.countY, frameWidth, frameHeight);
    final dst = _dstRect(exp.x, exp.y, frameWidth, frameHeight, exp.scale);
    canvas.drawImageRect(img, src, dst, _imagePaint);
  }
}

Rect _srcRect(int countX, int countY, double width, double height) =>
  Rect.fromLTWH(countX * width, countY * height, width, height);

Rect _dstRect(double x, double y, double width, double height, double scale) =>
  Rect.fromLTWH(x, y, width * scale, height * scale);


