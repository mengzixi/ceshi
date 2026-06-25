import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
      bottomSheet: SizedBox(),
    );
  }
}
