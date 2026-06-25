import 'package:hive/hive.dart';
part 'get_config_model.g.dart';


@HiveType(typeId: 0)
class ConfigModel extends HiveObject{
  @HiveField(0)
   AppConfig? appConfig;
  @HiveField(1)
   AdsConfig? adsConfig;

  ConfigModel({this.appConfig, this.adsConfig});

 factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
        appConfig : json['app_config'] != null
            ? new AppConfig.fromJson(json['app_config'])
            : null,
        adsConfig : json['ads_config'] != null
        ? new AdsConfig.fromJson(json['ads_config'])
       : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appConfig != null) {
      data['app_config'] = this.appConfig?.toJson();
    }
    if (this.adsConfig != null) {
      data['ads_config'] = this.adsConfig?.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 1)
class AppConfig extends HiveObject{
  @HiveField(0)
  String? appName;
  @HiveField(1)
  String? appMode;
  @HiveField(2)
  String? jitsiServer;
  @HiveField(3)
  String? meetingPrefix;
  @HiveField(4)
  bool? mandatoryLogin;
  @HiveField(5)
  bool? allowUnauthorizedMeetingCode;
  AppConfig(
      {this.appName,
        this.appMode,
        this.jitsiServer,
        this.meetingPrefix,
        this.mandatoryLogin,
        this.allowUnauthorizedMeetingCode});

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['app_name'],
      appMode: json['app_mode'],
      jitsiServer: json['jitsi_server'],
      meetingPrefix: json['meeting_prefix'],
      mandatoryLogin: json['mandatory_login'],
      allowUnauthorizedMeetingCode: json['allow_unauthorized_meeting_code'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_name'] = this.appName;
    data['app_mode'] = this.appMode;
    data['jitsi_server'] = this.jitsiServer;
    data['meeting_prefix'] = this.meetingPrefix;
    data['mandatory_login'] = this.mandatoryLogin;
    data['allow_unauthorized_meeting_code'] = this.allowUnauthorizedMeetingCode;
    return data;
  }
}

@HiveType(typeId: 2)
class AdsConfig extends HiveObject{
  @HiveField(0)
  bool? adsEnable;
  @HiveField(1)
  String? mobileAdsNetwork;
  @HiveField(2)
  String? admobAppId;
  @HiveField(3)
  String? admobBannerAdsId;
  @HiveField(4)
  String? admobInterstitialAdsId;

  AdsConfig(
      {this.adsEnable,
        this.mobileAdsNetwork,
        this.admobAppId,
        this.admobBannerAdsId,
        this.admobInterstitialAdsId});

  factory AdsConfig.fromJson(Map<String, dynamic> json) {
    return AdsConfig(
      adsEnable :json['ads_enable'],
      mobileAdsNetwork:json['mobile_ads_network'],
      admobAppId: json['admob_app_id'],
      admobBannerAdsId: json['admob_banner_ads_id'],
      admobInterstitialAdsId : json['admob_interstitial_ads_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ads_enable'] = this.adsEnable;
    data['mobile_ads_network'] = this.mobileAdsNetwork;
    data['admob_app_id'] = this.admobAppId;
    data['admob_banner_ads_id'] = this.admobBannerAdsId;
    data['admob_interstitial_ads_id'] = this.admobInterstitialAdsId;
    return data;
  }
}



