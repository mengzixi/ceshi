import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spagreen/src/models/get_config_model.dart';
import 'package:spagreen/src/services/database_service.dart';
import 'app.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await DatabaseService().initHiveDatabase();
  //await Repository().getAppConfig();
  runApp(MyApp());
}

String? getAppId(AdsConfig adsConfig) {
  if (Platform.isIOS) {
    print(adsConfig.admobAppId);
    return adsConfig.admobAppId;
  } else if (Platform.isAndroid) {
    return adsConfig.admobAppId;
  }
  return null;
}
