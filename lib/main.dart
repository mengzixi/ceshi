import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCTjW8pxpdkxtKLPjPsvavcFv1AXME9F3Y",
      appId: "1:718287711641:android:369647cb0ed6ce67887708",
      messagingSenderId: "718287711641",
      projectId: "meetair-736a5",
      storageBucket: "meetair-736a5.appspot.com",
    ),
  );
  await DatabaseService().initHiveDatabase();
  //await Repository().getAppConfig();
  await MobileAds.instance.initialize();
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
