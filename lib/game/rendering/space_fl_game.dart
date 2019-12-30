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
import 'package:flutter/scheduler.dart';
import 'package:spacefl/game/rendering/render_fns.dart';

const _title = "SpaceFl";

/// Experimenting with drawing the game board with Flutter widgets.
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

Duration _deltaTime = Duration.zero;

class _GameBoardState extends State<GameBoard> {
  Duration _lastDuration = Duration.zero;
  Ticker _gameTicker;

  @override
  void initState() {
    super.initState();
    _gameTicker = Ticker(
        (duration) {
        setState(() {
          _deltaTime = duration - _lastDuration;
          _lastDuration = duration;
        });
      },
    )..start();
  }

  @override
  void dispose() {
    super.dispose();
    _gameTicker.dispose();
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

class GamePainter extends CustomPainter {
  final backgroundPaint = Paint()..color = Colors.black;
  final greenPaint = Paint()..color = Colors.green;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height / 2), greenPaint);

    drawFps(canvas, size, _deltaTime);
  }

  @override
  bool shouldRepaint(GamePainter oldDelegate) => true;
}

