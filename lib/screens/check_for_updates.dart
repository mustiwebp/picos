/*   This file is part of Picos, a health tracking mobile app
*    Copyright (C) 2022 Healthcare IT Solutions GmbH
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Accesses the corresponding app stores to find newer version.
class CheckForUpdates {
  /// Checks for the iOS-Version if there is a newer version.
  static Future<bool> newerVersionIOSAvailable(String currentVersion) async {
    const String bundleIdentifier = 'de.hit-solutions.PICOS';
    const String url =
        'https://itunes.apple.com/lookup?bundleId=$bundleIdentifier';

    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final dynamic appData = data['results'][0];
        final String latestVersion = appData['version'] as String;

        // Compare latestVersion with the currently installed app version
        // and notify the user if an update is available.
        if (currentVersion != latestVersion) return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
