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
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:spacefl/game.dart';
import 'package:spacefl/render_fns.dart';

/// A custom impl of [RenderBox] that draws the game board by talking directly
/// to Flutter's rendering engine.
class RenderGameBox extends RenderBox {
  int _frameCallbackId;
  double _deltaT = 0;
  Duration _lastTime = Duration.zero;

  final imagePaint = Paint();
  final backgroundPaint = Paint()
    ..color = Colors.black;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scheduleTick();
  }

  @override
  void detach() {
    super.detach();
    _unscheduleTick();
  }

  @override
  bool get sizedByParent => true;

  @override
  void paint(PaintingContext ctx, Offset offset) {
    final canvas = ctx.canvas;
    final game = Game.instance();
    canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height), backgroundPaint);

    final backgroundImage = game.images.backgroundImage;
    if (backgroundImage != null) {
      canvas.drawImage(backgroundImage, Offset.zero, imagePaint);
    }

    drawFps(canvas, size, _deltaT);
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {
    if (!attached) {
      return;
    }
    _scheduleTick();
    _computeDeltaT(timestamp);
    markNeedsPaint();
  }

  void _computeDeltaT(Duration now) {
    Duration delta = now - _lastTime;
    if (_lastTime == Duration.zero) {
      delta = Duration.zero;
    }

    _lastTime = now;
    _deltaT = delta.inMicroseconds / Duration.microsecondsPerSecond;
  }
}


