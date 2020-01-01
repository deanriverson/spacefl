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
import 'package:spacefl/widgets/game_screen.dart';
import 'package:spacefl/widgets/title_screen.dart';

/// The top-level application widget for the SpaceFL game.
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
          builder: (BuildContext context, AsyncSnapshot snapshot) =>
              snapshot.connectionState == ConnectionState.done ? GameScreen() : TitleScreen(),
        ),
      ),
    );
  }
}
