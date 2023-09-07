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
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html;
import 'package:picos/models/document.dart';
import 'package:picos/themes/global_theme.dart';
import 'package:picos/util/backend.dart';
import 'package:picos/util/flutter_secure_storage.dart';
import 'package:picos/widgets/picos_body.dart';
import 'package:picos/widgets/picos_ink_well_button.dart';
import 'package:picos/widgets/picos_screen_frame.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:picos/widgets/picos_text_field.dart';
import 'package:package_info_plus/package_info_plus.dart';

///Displays the login screen.
class LoginScreen extends StatefulWidget {
  ///LoginScreen constructor.
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SecureStorage _secureStorage = SecureStorage();

  bool _isChecked = false;
  bool _passwordVisible = false;
  bool _sendDisabled = false;
  BackendError? _backendError;

  static const double _sponsorLogoPadding = 30;

  String latestVersion = '';
  String currentVersion = '';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _fetchSecureStorageData() async {
    String? valueIsChecked;
    _loginController.text = await _secureStorage.getUsername() ?? '';
    _passwordController.text = await _secureStorage.getPassword() ?? '';
    valueIsChecked = await _secureStorage.getIsChecked() ?? '';

    setState(() {
      _isChecked = valueIsChecked == 'true';
    });
  }

  Future<void> _submitHandler() async {
    setState(() => _sendDisabled = true);

    BackendError? loginError = await Backend.login(
      _loginController.text,
      _passwordController.text,
    );

    if (loginError == null) {
      final String route = await Backend.getRole();

      if (_isChecked) {
        await _secureStorage.setUsername(_loginController.text);
        await _secureStorage.setPassword(_passwordController.text);
      } else {
        await _secureStorage.deleteAll();
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    } else {
      setState(() {
        _backendError = loginError;
        _sendDisabled = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Backend();
    _initPackageInfo();
    if (io.Platform.isIOS) {
      _checkForNewVersionIOS();
    } else if (io.Platform.isAndroid) {
      _checkForNewVersionAndroid();
    }
    _fetchSecureStorageData();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkForNewVersionIOS() async {
    const String bundleId = 'de.hit-solutions.PICOS';
    const String url = 'https://itunes.apple.com/de/lookup?bundleId=$bundleId';

    currentVersion = _packageInfo.version;

    try {
      final http.Response response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        final dynamic results = data['results'];

        if (results.isNotEmpty) {
          final dynamic appData = results[0];
          final String appVersion = appData['version'] as String;

          if (appVersion != currentVersion) {
            // A newer version is available
            setState(() {
              latestVersion = appVersion;
            });

            // Show the AlertDialog immediately
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('New Version Available'),
                    content: Text(
                      'A new version ($latestVersion) is available on the App Store.',
                    ),
                    actions: <TextButton>[
                      TextButton(
                        onPressed: () {
                          // Open the App Store link for your app
                          // You can use the `url_launcher` package for this.
                        },
                        child: const Text('Update'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Later'),
                      ),
                    ],
                  );
                },
              );
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching app version: $e');
    }
  }

  Future<void> _checkForNewVersionAndroid() async {
    const String appPackage = 'de.hitsolutions.picos';
    const String appUrl =
        'https://play.google.com/store/apps/details?id=$appPackage';

    currentVersion = '1.4.0';

    try {
      final http.Response response = await http.get(
        Uri.parse(appUrl),
        headers: <String, String>{
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );
      if (response.statusCode == 200) {
        final document = html_parser.parse(response.body);

        final element = document.querySelector(
            '#yDmH0d > div.VfPpkd-Sx9Kwc.cC1eCc.UDxLd.PzCPDd.HQdjr.VfPpkd-Sx9Kwc-OWXEXe-FNFY6c > '
            'div.VfPpkd-wzTsW > div > div > div > div > div.fysCi > div:nth-child(3) > '
            'div:nth-child(1) > div.reAt0');

        if (element != null) {
          return;
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalTheme theme = Theme.of(context).extension<GlobalTheme>()!;

    return PicosScreenFrame(
      body: Center(
        child: PicosBody(
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage('assets/PICOS_Logo_RGB.png'),
              ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    height: 2,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${AppLocalizations.of(context)!.welcomeToPICOS},'
                          '\n',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!
                          .thankYouForParticipation,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Version ${_packageInfo.version}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _backendError != null
                  ? Text(
                      _backendError!.getMessage(context),
                      style: const TextStyle(color: Color(0xFFe63329)),
                    )
                  : const Text(''),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 200,
                child: PicosTextField(
                  controller: _loginController,
                  hint: AppLocalizations.of(context)!.username,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: PicosTextField(
                  controller: _passwordController,
                  hint: AppLocalizations.of(context)!.password,
                  obscureText: !_passwordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                    ),
                    color: Colors.grey,
                    onPressed: () => setState(() {
                      _passwordVisible = !_passwordVisible;
                    }),
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: Row(
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.rememberMe),
                    Expanded(
                      child: Checkbox(
                        value: _isChecked,
                        checkColor: Colors.white,
                        activeColor: theme.darkGreen1,
                        onChanged: (bool? value) {
                          setState(
                            () {
                              _isChecked = value!;
                              _secureStorage.setIsChecked(_isChecked);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: PicosInkWellButton(
                  disabled: _sendDisabled,
                  onTap: () {
                    _submitHandler();
                  },
                  text: AppLocalizations.of(context)!.submit,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(_sponsorLogoPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Image(
                        image: AssetImage('assets/BMBF.png'),
                      ),
                    ),
                    SizedBox(width: _sponsorLogoPadding),
                    Expanded(
                      child: Image(
                        image: AssetImage('assets/Logo_MII.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
