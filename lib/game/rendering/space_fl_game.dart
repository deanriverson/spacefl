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
import 'package:spacefl/game/game.dart';
import 'package:spacefl/game/rendering/render_game_box.dart';

/// Load the assets and start the game
class SpaceFlGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Game.instance();

    return MaterialApp(
      title: 'SpaceFL',
      theme: ThemeData.dark(),
      home: Scaffold(
        body: FutureBuilder(
          future: game.loadAssets(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: GameBoard(),
              );
            } else {
              return Container(
                color: Color.fromARGB(255, 27, 48, 70),
                child: Center(
                  child: Text('Loading...', style: Theme.of(context).textTheme.display2),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class GameBoard extends LeafRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) => RenderGameBox();
}

//class GameBoard extends StatefulWidget {
//  @override
//  _GameBoardState createState() => _GameBoardState();
//}
//
//class _GameBoardState extends State<GameBoard> {
////  Duration _lastDuration = Duration.zero;
//  Ticker _gameTicker;
//
//  @override
//  void initState() {
//    super.initState();
//    _gameTicker = Ticker(
//      (duration) {
//        setState(() {
////          _deltaTime = duration - _lastDuration;
////          _lastDuration = duration;
//        });
//      },
//    )..start();
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    _gameTicker.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(title: Text(_title)),
//      body: SafeArea(
//        child: Stack(
//          children: [
//            ConstrainedBox(
//              constraints: BoxConstraints.expand(),
//              child: CustomPaint(painter: GamePainter()),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
//
//class GamePainter extends CustomPainter {
//  final backgroundPaint = Paint()..color = Colors.black;
//  final greenPaint = Paint()..color = Colors.green;
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);
//    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height / 2), greenPaint);
//
//    drawFps(canvas, Game.instance());
//  }
//
//  @override
//  bool shouldRepaint(GamePainter oldDelegate) => true;
//}
