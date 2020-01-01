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
import 'package:spacefl/game/game.dart';

/// A custom impl of [RenderBox] that draws the game board by talking directly
/// to Flutter's rendering engine.
class RenderGameBox extends RenderBox {
  int _frameCallbackId;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scheduleTick();
  }

  @override
  void detach() {
    super.detach();
    _cancelTick();
  }

  @override
  void performResize() {
    super.performResize();
    Game.instance().init(size);
  }

  @override
  bool get sizedByParent => true;

  @override
  void paint(PaintingContext ctx, Offset offset) {
    Game.instance().repaint(ctx.canvas);
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _cancelTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {
    _scheduleTick();

    if (!attached || !hasSize) {
      return;
    }

    Game.instance().update(timestamp);
    markNeedsPaint();
  }
}
