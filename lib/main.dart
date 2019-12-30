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

import 'package:flutter/rendering.dart';
import 'package:spacefl/game/rendering/render_game_box.dart';

/*
 * To do list:
 *   [x] Experiment with direct rendering
 *   [x] Initial port of actor classes
 *   [x] Copy over image and audio assets from original
 *   [x] Load and draw background image
 *   [x] Draw stars
 *   [ ] Load and draw asteroid images
 *   [ ] Load and draw enemy images
 *   [ ] Handle input events
 *   [ ] Draw space ship
 */

/// Run the game using the Flutter rendering engine directly
void main() {
  RenderingFlutterBinding(root: RenderGameBox());
}

/// Run the game using Flutter widgets
//void main() => runApp(SpaceFlGame());
