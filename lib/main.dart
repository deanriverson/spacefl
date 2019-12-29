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

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math.dart' as v;

final _title = "SpaceFl";

/// To do list:
///   [x] Experiment with direct rendering
///   [x] Initial port of actor classes
///   [ ] Copy over image and audio assets from original
///   [ ] Load and draw background image
///   [ ] Draw stars
///   [ ] Load and draw asteroid images
///   [ ] Load and draw enemy images
///   [ ] Handle input events
void main() => RenderingFlutterBinding(root: RenderGameBox());
//void main() => runApp(SpaceFlGame());

class RenderGameBox extends RenderBox {
  int _frameCallbackId;
  double _deltaT = 0;
  Duration _lastTime = Duration.zero;

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
    canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height), backgroundPaint);
    _drawFps(canvas, size);
  }

  void _drawFps(Canvas canvas, Size size) {
    TextSpan span = new TextSpan(text: '${(1.0 / _deltaT).toStringAsFixed(1)} FPS');
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(size.width - tp.width - 5.0, 30.0));
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

class SpaceFlGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: GameBoard());
  }
}

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

int _deltaTimeMillis = 1000;

class _GameBoardState extends State<GameBoard> {
  int lastMillis = 0;
  Ticker gameTicker;

  @override
  void initState() {
    super.initState();
    gameTicker = Ticker(
      (duration) {
        setState(() {
          final millis = duration.inMilliseconds;
          _deltaTimeMillis = millis - lastMillis;
          lastMillis = millis;
        });
      },
    )..start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SafeArea(
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.expand(),
              child: CustomPaint(painter: GamePainter()),
            )
          ],
        ),
      ),
    );
  }
}

void _drawFps(Canvas canvas, Size size) {
  TextSpan span = new TextSpan(text: '${(1000.0 / _deltaTimeMillis).toStringAsFixed(1)} FPS');
  TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
  tp.layout();
  tp.paint(canvas, new Offset(size.width - tp.width - 5.0, 0.0));
}

class GamePainter extends CustomPainter {
  final backgroundPaint = Paint()..color = Colors.black;
  final greenPaint = Paint()..color = Colors.green;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height / 2), greenPaint);

    _drawFps(canvas, size);
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}

class Colored extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = v.SimplexNoise();
    final frames = 200;
    canvas.drawPaint(Paint()..color = Colors.black87);

    for (double i = 10; i < frames; i += .1) {
      canvas.translate(i % .3, i % .6);
      canvas.save();
      canvas.rotate(pi / i * 25);

      final area = Offset(i, i) & Size(i * 10, i * 10);

      // Blue trail is made of rectangle
      canvas.drawRect(
        area,
        Paint()
          ..filterQuality = FilterQuality.high // Change this to lower render time
          ..blendMode = BlendMode.screen // Remove this to see the natural drawing shape
          ..color = Colors.blue.withRed(i.toInt() * 20 % 11).withOpacity(i / 850),
      );

      // Tail particles effect

      // Change this to add more fibers
      final int tailFibers = (i * 1.5).toInt();

      for (double d = 0; d < area.width; d += tailFibers) {
        for (double e = 0; e < area.height; e += tailFibers) {
          final n = random.noise2D(d, e);
          final tail = exp(i / 50) - 5;
          final tailWidth = .2 + (i * .11 * n);
          canvas.drawCircle(
              Offset(d, e),
              tailWidth,
              Paint()
                ..color = Colors.red.withOpacity(.4)
                ..isAntiAlias = true // Change this to lower render time
                // Particles accelerate as they fall so we change the blur size for movement effect
                ..imageFilter = ImageFilter.blur(sigmaX: tail, sigmaY: 0)
                ..filterQuality = FilterQuality.high // Change this to lower render time
                ..blendMode = BlendMode.screen); // Remove this to see the natural drawing shape
        }
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
