import 'dart:io';

import 'package:spagreen/src/services/database_service.dart';

import '../models/get_config_model.dart';

class AdHelper {
  static String get bannerAdId {
    AdsConfig? adsConfig = DatabaseService().getConfigData()?.adsConfig;
    if (Platform.isAndroid) {
      return adsConfig?.admobBannerAdsId ??
          'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return adsConfig?.admobBannerAdsId ??
          'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    AdsConfig? adsConfig = DatabaseService().getConfigData()?.adsConfig;

    if (Platform.isAndroid) {
      return adsConfig?.admobInterstitialAdsId ??
          'ca-app-pub-3940256099942544/1033173712';
      
    } else if (Platform.isIOS) {
      return adsConfig?.admobInterstitialAdsId ??
          'ca-app-pub-3940256099942544/3964253750';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
