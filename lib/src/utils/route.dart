import 'package:flutter/material.dart';
import 'package:spagreen/src/screen/login_screen.dart';
import 'package:spagreen/src/screen/sign_up_screen.dart';
import 'package:spagreen/src/screen/main_screen.dart';
import 'package:spagreen/src/widgets/privacy_policy_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      MainScreen.route: (_) => MainScreen(),
      LoginPage.route: (_) => LoginPage(),
      SignUpScreen.route: (_) => SignUpScreen(),
      PrivacyPolicyScreen.route: (_) => PrivacyPolicyScreen(),
    };
  }
}
