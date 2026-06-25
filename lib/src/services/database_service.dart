import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/get_config_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  Future initHiveDatabase() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDirectory.path);
    Hive.registerAdapter(ConfigModelAdapter());
    Hive.registerAdapter(AppConfigAdapter());
    Hive.registerAdapter(AdsConfigAdapter());
    Hive.registerAdapter(AuthUserAdapter());
    await Hive.openBox<ConfigModel>('_config_box');
    await Hive.openBox<AppConfig>('_app_config_box');
    await Hive.openBox<AdsConfig>('_ads_config_box');
    await Hive.openBox<AuthUser>('user');
    await Hive.openBox('seenBox');
    await Hive.openBox("languageCode");
    await Hive.openBox("language");
  }

  void saveConfigData(ConfigModel model) {
    var box = Hive.box<ConfigModel>('_config_box');
    box.put('_config_box', model);
  }

  ConfigModel? getConfigData() {
    var box = Hive.box<ConfigModel>('_config_box');
    var value = box.get('_config_box');
    return value;
  }

  bool isMandatoryLogin() {
    ConfigModel? configModel = getConfigData();
    bool value = configModel != null
        ? configModel.appConfig?.mandatoryLogin == true
        : false;
    return value;
  }
}
