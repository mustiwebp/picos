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

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:picos/FCM/notification_badge.dart';
import 'package:picos/FCM/push_notifcation.dart';
import 'package:picos/themes/global_theme.dart';
import 'package:picos/util/backend.dart';
import 'package:picos/util/flutter_secure_storage.dart';
import 'package:picos/widgets/picos_body.dart';
import 'package:picos/widgets/picos_ink_well_button.dart';
import 'package:picos/widgets/picos_screen_frame.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:picos/widgets/picos_text_field.dart';

///Displays the login screen.
class LoginScreen extends StatefulWidget {
  ///LoginScreen constructor.
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SecureStorage _secureStorage = SecureStorage();

  bool _isChecked = false;
  bool _passwordVisible = false;
  bool _sendDisabled = false;
  BackendError? _backendError;

  static const double _sponsorLogoPadding = 30;

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message: ${message.messageId}');
  }

  void requestAndRegisterNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String? token = await _messaging.getToken();
      print("The token is " + token!);
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
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

      if (_isChecked && !kIsWeb) {
        await _secureStorage.setUsername(_loginController.text);
        await _secureStorage.setPassword(_passwordController.text);
      } else if (!kIsWeb) {
        await _secureStorage.deleteAll();
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(route);
    } else {
      setState(
        () {
          _backendError = loginError;
          _sendDisabled = false;
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Backend();
    requestAndRegisterNotification();
    if (!kIsWeb) {
      _fetchSecureStorageData();
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalTheme theme = Theme.of(context).extension<GlobalTheme>()!;

    return PicosScreenFrame(
      body: Center(
        child: PicosBody(
          child: Column(
            children: <Widget>[
              NotificationBadge(totalNotifications: _totalNotifications),
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
                      text:
                          '${AppLocalizations.of(context)!.welcomeToPICOS},\n',
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
                    !kIsWeb
                        ? Text(AppLocalizations.of(context)!.rememberMe)
                        : const SizedBox(
                            width: 0,
                          ),
                    Expanded(
                      child: !kIsWeb
                          ? Checkbox(
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
                            )
                          : const SizedBox(
                              width: 0,
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: PicosInkWellButton(
                  disabled: _sendDisabled,
                  onTap: _submitHandler,
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
