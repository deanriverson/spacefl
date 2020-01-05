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

mixin SimpleKinematics {
  double _x;
  double _y;
  double _vX;
  double _vY;

  double get x => _x;
  double get y => _y;
  double get vX => _vX;
  double get vY => _vY;

  void initKinematics(double x, double y, double vX, double vY) {
    _x = x;
    _y = y;
    _vX = vX;
    _vY = vY;
  }

  void updateKinematics() {
    _x += _vX;
    _y += _vY;
  }
}