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
import 'dart:math' as math;

const double tau = math.pi * 2.0;

const double _hitTightnessFactor = 0.8;

/// Convert radians to degrees
double radToDeg(double radians) => radians * 180.0 / math.pi;

/// Convert degrees to radians
double degToRad(double degrees) => degrees * math.pi / 180.0;

/// Hit test between two circles
///
/// @return True if the distance between the centers is less than the sum of the radii.
bool isHitCircleCircle(
  final double c1X,
  final double c1Y,
  final double c1R,
  final double c2X,
  final double c2Y,
  final double c2R,
) {
  double distX = c1X - c2X;
  double distY = c1Y - c2Y;
  double distance = math.sqrt((distX * distX) + (distY * distY));
  return (distance <= (c1R + c2R) * _hitTightnessFactor);
}

double randInRange(math.Random r, double min, double max) => r.nextDouble() * (max - min) + min;

Duration randDurationInRange(math.Random r, double min, double max) {
  final randSecs = randInRange(r, min, max);
  return Duration(milliseconds: (randSecs * 1000).toInt());
}