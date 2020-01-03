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

import 'package:spacefl/game/game.dart';

/// Generator function (a.k.a. coroutine that generates [count] actors.
Iterable<T> actorGenerator<T>(int count, Function creator) sync* {
  for(int i = 0; i < count; ++i) {
    yield creator();
  }
}

/// Generate [count] actors using the [actorCreator] function and put them in [actors].
void initActorList<T>(List<T> actors, int count, Function actorCreator) {
  actors.setAll(0, actorGenerator(count, actorCreator));
}

/// Generic function that calls the update method on each acdtor in [actors].
void updateActorList<T>(T actors, Game game, Duration deltaT) {
  for (final actor in actors) {
    actor.update(game);
  }
}

/// Remove items from [actors] if they are present in the [actorsToRemove] Set, then clear it.
void clearActors<T>(List<T> actors, Set<T> actorsToRemove) {
  if (actorsToRemove.isNotEmpty) {
    actors.removeWhere((c) => actorsToRemove.contains(c));
    actorsToRemove.clear();
  }
}

/// Returns true if [interval] has passed since the [last] spawn time.
bool isTimeToSpawn(Duration now, Duration last, Duration interval) => now > last + interval;
