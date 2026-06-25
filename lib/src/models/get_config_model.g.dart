// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigModelAdapter extends TypeAdapter<ConfigModel> {
  @override
  final int typeId = 0;

  @override
  ConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigModel(
      appConfig: fields[0] as AppConfig?,
      adsConfig: fields[1] as AdsConfig?,
    );
  }

  @override
  void write(BinaryWriter writer, ConfigModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.appConfig)
      ..writeByte(1)
      ..write(obj.adsConfig);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppConfigAdapter extends TypeAdapter<AppConfig> {
  @override
  final int typeId = 1;

  @override
  AppConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppConfig(
      appName: fields[0] as String?,
      appMode: fields[1] as String?,
      jitsiServer: fields[2] as String?,
      meetingPrefix: fields[3] as String?,
      mandatoryLogin: fields[4] as bool?,
      allowUnauthorizedMeetingCode: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, AppConfig obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.appName)
      ..writeByte(1)
      ..write(obj.appMode)
      ..writeByte(2)
      ..write(obj.jitsiServer)
      ..writeByte(3)
      ..write(obj.meetingPrefix)
      ..writeByte(4)
      ..write(obj.mandatoryLogin)
      ..writeByte(5)
      ..write(obj.allowUnauthorizedMeetingCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdsConfigAdapter extends TypeAdapter<AdsConfig> {
  @override
  final int typeId = 2;

  @override
  AdsConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdsConfig(
      adsEnable: fields[0] as bool?,
      mobileAdsNetwork: fields[1] as String?,
      admobAppId: fields[2] as String?,
      admobBannerAdsId: fields[3] as String?,
      admobInterstitialAdsId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AdsConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.adsEnable)
      ..writeByte(1)
      ..write(obj.mobileAdsNetwork)
      ..writeByte(2)
      ..write(obj.admobAppId)
      ..writeByte(3)
      ..write(obj.admobBannerAdsId)
      ..writeByte(4)
      ..write(obj.admobInterstitialAdsId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdsConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
