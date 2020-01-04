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

import 'package:flutter/widgets.dart';
import 'package:spacefl/widgets/space_fl_game.dart';

/*
 * To do list:
 *   [x] Experiment with direct rendering
 *   [x] Initial port of actor classes
 *   [x] Copy over image and audio assets from original
 *   [x] Load and draw background image
 *   [x] Draw stars
 *   [x] Load and draw asteroids
 *   [x] Load and draw enemies
 *   [x] Load and draw crystals
 *   [x] Draw space ship and shield
 *   [x] Handle input events
 *   [x] Draw player torpedoes and rockets
 *   [x] Hit testing on asteroids w.r.t player torpedoes
 *   [x] Hit testing on enemies w.r.t. player torpedoes
 *   [x] Draw asteroid and enemy explosions
 *   [x] Draw enemy torpedoes
 *   [x] Hit testing on space ship w.r.t enemy torpedoes
 *   [x] Draw space ship explosion
 *   [ ] Draw enemy bosses
 *   [ ] Draw enemy boss explosions
 *   [ ] Detect ship-to-ship and ship-to-asteroid collisions
 *   [ ] Draw score, lives, and mini shields
 *   [ ] Play sound effects
 *   [ ] Play music
 *
 * Future Ideas:
 *   [ ] Create class/mixin hierarchy for actor classes to eliminate some duplicate code
 *   [x] Refactor asset loading code by creating a list of asset names and look them up by name
 *   [ ] Use asset list to provide progress indicator on loading screen
 *   [ ] Move draw fns to actor classes to allow, for example, space ship to draw based on it's internal state
 *   [ ] Implement state machine in space ship for states: alive, exploding, respawning.
 *   [ ] Implement respawning animation in spaceship (shimmering translucent effect?)
 */

/// Run the application using a Stateless Widget
void main() => runApp(SpaceFlGame());
