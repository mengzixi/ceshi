import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spagreen/src/models/get_config_model.dart';
import 'package:spagreen/src/models/user_model.dart';
import 'package:spagreen/src/services/authentication_service.dart';
import 'package:spagreen/src/style/theme.dart';
import 'package:spagreen/src/utils/app_tags.dart';
import 'package:spagreen/src/widgets/host_meeting_card.dart';
import 'package:spagreen/src/widgets/join_meeting_card.dart';
import '../services/database_service.dart';
import '../utils/ad_helper.dart';
import '../utils/localization_helper.dart' as helper;

class MeetingScreen extends StatefulWidget {
  @override
  _MeetingScreenState createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  int _selectedIndex = 0;
  int selectedScreen = 0;
  PageController? _pageController;
  AuthUser? _authUser;
  String? appMode;
  String? userRole;
  bool? ismandatoryLogin;
  AdsConfig? adsConfig;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    appMode = DatabaseService().getConfigData()?.appConfig != null
        ? DatabaseService().getConfigData()?.appConfig?.appMode
        : "free";
    _authUser = authService.getUser() != null ? authService.getUser() : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            appMode == "academic"
                ? academicMoodSubscriberWidget()
                : generalMoodWidget(),
          ],
        ),
      ),
      bottomSheet: SizedBox(),
    );
  }

  Widget academicMoodSubscriberWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 28),
            child: Text(
              helper.getTranslated(context, AppTags.titleMeetingScreen)!,
              style: CustomTheme.screenTitle,
            ),
          ),
          /*Join meeting and Host Meeting Switch Button*/
          SizedBox(height: 10.0),
          Container(
            height: 500.0,
            child: JoinMeeting(),
          ),
        ],
      ),
    );
  }

  /*Academic Mode Widget*/
  Widget generalMoodWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60, bottom: 28),
            child: Text(
              helper.getTranslated(context, AppTags.titleMeetingScreen)!,
              style: CustomTheme.screenTitle,
            ),
          ),
          /*Join meeting and Host Meeting Switch Button*/
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              tabButton(
                0,
                helper.getTranslated(context, AppTags.joinMeeting)!,
              ),
              tabButton(
                1,
                helper.getTranslated(context, AppTags.hostMeeting)!,
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Container(
            height: 430.0,
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                /* Join Meeting and Host Meeting Widget*/
                JoinMeeting(),
                HostMeetingCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*navigate between join meeting and host meeting*/
  Widget tabButton(int btnIndex, String btnTitle) {
    return GestureDetector(
      onTap: () {
        _selectedIndex = btnIndex;
        _pageController!.animateToPage(_selectedIndex,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
        setState(() {});
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 2.3,
        decoration: BoxDecoration(
          borderRadius: btnIndex == 0
              ? BorderRadius.only(
                  topLeft: Radius.circular(6), bottomLeft: Radius.circular(5))
              : BorderRadius.only(
                  bottomRight: Radius.circular(6),
                  topRight: Radius.circular(5)),
          boxShadow:
              _selectedIndex == btnIndex ? CustomTheme.iconBoxShadow : null,
          color: _selectedIndex == btnIndex ? Colors.white : Color(0xffF0F1F6),
        ),
        child: Center(
          child: Text(
            btnTitle,
            style: TextStyle(
                fontFamily: 'Avenir',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: _selectedIndex == btnIndex
                    ? Color(0xff222222)
                    : Color(0xff5B5D80)),
          ),
        ),
      ),
    );
  }
}
