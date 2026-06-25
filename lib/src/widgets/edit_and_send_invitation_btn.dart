import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spagreen/src/style/theme.dart';
import 'package:spagreen/src/utils/app_tags.dart';
import '../utils/localization_helper.dart' as helper;

Widget sendInvitation({
  BuildContext? context,
  required String title,
  String? meetingCode,
  String? appName,
  String? joinWebUrl,
}) {
  return GestureDetector(
    onTap: () {
      String shareText =
          "${helper.getTranslated(context!, AppTags.joinMeetingWith)}${appName ?? ''}\n"
          "${helper.getTranslated(context, AppTags.joinFromWeb)}${joinWebUrl ?? ''}\n"
          "${helper.getTranslated(context, AppTags.joinFromApp)} ${meetingCode ?? ''}";
      Share.share(shareText);
    },
    child: Container(
      height: 45.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
        border: Border.all(color: CustomTheme.primaryColor),
      ),
      child: Center(
        child: Text(
          title,
          style: CustomTheme.subTitleTextColored,
        ),
      ),
    ),
  );
}
