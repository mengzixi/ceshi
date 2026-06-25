import 'dart:async';
import 'dart:math';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:spagreen/constants.dart';
import 'package:spagreen/src/models/get_config_model.dart';
import 'package:spagreen/src/models/meeting_mode.dart';
import 'package:spagreen/src/server/repository.dart';
import 'package:spagreen/src/services/authentication_service.dart';
import 'package:spagreen/src/style/theme.dart';
import 'package:spagreen/src/utils/app_tags.dart';
import 'package:spagreen/src/utils/edit_text_utils.dart';
import '../services/database_service.dart';
import '../utils/ad_helper.dart';
import '../utils/localization_helper.dart' as helper;
import 'package:spagreen/src/utils/jitsi_meet_utils.dart';
import 'package:spagreen/src/utils/loadingIndicator.dart';
import '../../config.dart';
import '../button_widget.dart';
import '../utils/validators.dart';
import 'edit_and_send_invitation_btn.dart';

class HostMeetingCard extends StatefulWidget {
  @override
  _HostMettingCardState createState() => _HostMettingCardState();
}

class _HostMettingCardState extends State<HostMeetingCard> {
  TextEditingController meetingTitleController = new TextEditingController();
  MeetingModel? hostMeetingResponse;
  PackageInfo _packageInfo = PackageInfo(
      appName: 'AppName', buildNumber: '', packageName: '', version: '');
  var _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'; //all characters
  Random _rnd = Random();
  String? randomMeetingCode; //meeting room
  bool isLoading = false;
  String? joinWebUrl;
  String? meetingPrefix;
  String? linkMessage;
  InterstitialAd? _interstitialAd;
  final JitsiMeet _jitsiMeet = JitsiMeet();

  //!previous
//  @override
//   void initState() {
//     _initPackageInfo();
//      AppConfig? appConfig = DatabaseService().getConfigData()?.appConfig;
//     meetingPrefix = appConfig
//         ?.meetingPrefix;
//     randomMeetingCode = meetingPrefix! + getRandomString(9);
//     JitsiMeet.addListener(JitsiMeetingListener(
//         onConferenceWillJoin: JitsiMeetUtils().onConferenceWillJoin,
//         onConferenceJoined: JitsiMeetUtils().onConferenceJoined,
//         onConferenceTerminated: JitsiMeetUtils().onConferenceTerminated,
//         onError: JitsiMeetUtils().onError));

//     _loadInterstitialAd();
//     super.initState();
//   }
  //!Changes
  @override
  void initState() {
    super.initState();
    _initPackageInfo();

    AppConfig? appConfig = DatabaseService().getConfigData()?.appConfig;
    meetingPrefix = appConfig?.meetingPrefix;
    randomMeetingCode = meetingPrefix! + getRandomString(9);
    //joinMeeting();
    _loadInterstitialAd();
  }

  Future<void> joinMeeting() async {
    await _jitsiMeet.join(JitsiMeetConferenceOptions(
      room: randomMeetingCode!, //!if its room not working then use serverUrl
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
      },
      featureFlags: {
        "welcomepage.enabled": false,
      },
    ));
  }

  void _loadInterstitialAd() {
    _interstitialAd = null;
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                hostMeetingFunction();
                _loadInterstitialAd();
              },
            );
            setState(() {
              _interstitialAd = ad;
            });
          },
          onAdFailedToLoad: (error) =>
              debugPrint('Failed to load an interstitial ad: ${error.message}'),
        ));
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  //Regerating Random Meeting Code
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    // JitsiMeet.removeAllListeners();//!previous
    _jitsiMeet.closeChat(); //!Changes
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    joinWebUrl = "${Config.baseUrl}room/$randomMeetingCode";
    double screnWidth = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        joinMeetingCard(screnWidth, authService),
        if (isLoading) spinkit,
      ],
    );
  }

  Widget joinMeetingCard(double screnWidth, AuthService authService) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 40, bottom: 50, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    helper.getTranslated(context, AppTags.createAMeeting)!,
                    style: CustomTheme.displayTextBoldPrimaryColor,
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    height: 48.0,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                      border: Border.all(color: CustomTheme.lightColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Image.asset('assets/images/common/hash.png',
                                  scale: 3.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  randomMeetingCode!,
                                  style: CustomTheme.textFieldTitle,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                Clipboard.setData(new ClipboardData(
                                        text: randomMeetingCode!))
                                    .then((_) {
                                  showShortToast(helper.getTranslated(
                                      context, AppTags.meetingIDcopied)!);
                                });
                                //FlutterClipboard.copy(randomMeetingCode ?? "");
                              },
                              child: Icon(
                                Icons.content_copy,
                                color: CustomTheme.primaryColor,
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  /* user meeting title textField */
                  EditTextUtils().getCustomEditTextField(
                    hintValue: helper.getTranslated(
                        context, AppTags.meetingTitleOptional),
                    controller: meetingTitleController,
                    prefixWidget: Image.asset(
                      'assets/images/common/person.png',
                      scale: 3,
                    ),
                    keyboardType: TextInputType.text,
                    style: CustomTheme.textFieldTitle,
                  ),
                  SizedBox(height: 15.0),
                  sendInvitation(
                    context: context,
                    title:
                        helper.getTranslated(context, AppTags.sendInvitation)!,
                    meetingCode: linkMessage,
                  ),
                  SizedBox(height: 15.0),
                  GestureDetector(
                      onTap: () async {
                        if (_interstitialAd != null &&
                            _rnd.nextInt(100).isEven) {
                          printLog(
                              "-----host meeting button: ad not null, ready to show interstital ad.");
                          //after interstitialAd close joninMeetingFunction will be called from handleAdMobEvent
                          _interstitialAd?.show();
                        } else {
                          // If interstitialAd has not loaded due to any reason simply load hostMeeting Function
                          hostMeetingFunction();
                          printLog(
                              "-----host meeting button: ad null, ready to start a meeting.");
                        }
                      },
                      child: HelpMe().submitButton(
                        screnWidth,
                        helper.getTranslated(context, AppTags.createJoinNow)!,
                      ))
                ],
              ),
            ),
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: CustomTheme.boxShadow,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  hostMeetingFunction() async {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    String meetingTitle = meetingTitleController.value.text;
    String? userId =
        authService.getUser() != null ? authService.getUser()!.userId : "0";
    //0 is default user id when app is free mode
    hostMeetingResponse = await Repository().hostMeeting(
        meetingCode: randomMeetingCode,
        userId: userId,
        meetingTitle: meetingTitle);
    printLog("------host meeting response: ${hostMeetingResponse!.message}");
    setState(() {
      isLoading = false;
    });
    if (hostMeetingResponse != null)
      JitsiMeetUtils().hostMeeting(
          roomCode: randomMeetingCode!, meetingTitle: meetingTitle);
  }
}
