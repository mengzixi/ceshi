import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:spagreen/src/style/theme.dart';
import 'package:spagreen/src/utils/ad_helper.dart';
import 'package:spagreen/src/utils/app_tags.dart';
import '../utils/localization_helper.dart' as helper;
import 'package:spagreen/src/widgets/history_widget_without_login.dart';

class MeetingHistoryWithoutLogin extends StatefulWidget {
  const MeetingHistoryWithoutLogin({Key? key}) : super(key: key);

  @override
  _MeetingHistoryWithoutLoginState createState() =>
      _MeetingHistoryWithoutLoginState();
}

class _MeetingHistoryWithoutLoginState
    extends State<MeetingHistoryWithoutLogin> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
            size: AdSize.banner,
            adUnitId: AdHelper.bannerAdId,
            listener: BannerAdListener(
              onAdLoaded: (ad) {
                setState(() {
                  _bannerAd = ad as BannerAd;
                });
              },
              onAdFailedToLoad: (ad, error) {
                debugPrint('Failed to load a banner ad: ${error.message}');
                ad.dispose();
              },
            ),
            request: const AdRequest())
        .load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 60.0),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            helper.getTranslated(
                                context, AppTags.titleMeetingHistory)!,
                            style: CustomTheme.screenTitle,
                          ),
                          Text(
                            helper.getTranslated(
                                context, AppTags.allMeetingHistory)!,
                            style: CustomTheme.displayTextOne,
                          )
                        ],
                      )),
                  SizedBox(height: 20.0),
                  HistoryWidgetWithoutLogin(),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _bannerAd != null
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : SizedBox(),
    );
  }
}
