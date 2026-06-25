import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:provider/provider.dart';
import 'package:spagreen/src/models/meeting_history_model.dart';
import 'package:spagreen/src/models/meeting_mode.dart';
import 'package:spagreen/src/models/user_model.dart';
import 'package:spagreen/src/server/repository.dart';
import 'package:spagreen/src/services/authentication_service.dart';
import 'package:spagreen/src/style/theme.dart';
import 'package:spagreen/src/utils/app_tags.dart';
import 'package:spagreen/src/utils/jitsi_meet_utils.dart';
import 'package:spagreen/src/utils/loadingIndicator.dart';
import 'package:spagreen/src/widgets/meeting_history_row.dart';
import '../utils/ad_helper.dart';
import 'empty_meeting_history.dart';
import '../utils/localization_helper.dart' as helper;

class MeetingHistoryScreen extends StatefulWidget {
  //18item length per page
  static const int PAGE_SIZE = 18;
  static const int PAGE_NUMBER = 1;
  final userId;

  MeetingHistoryScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<MeetingHistoryScreen> createState() => _MeetingHistoryScreenState();
}

class _MeetingHistoryScreenState extends State<MeetingHistoryScreen> {
  MeetingModel? joinMeetingResponse;
  AuthUser? authUser;

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
    final AuthService authService = Provider.of<AuthService>(context);
    authUser = authService.getUser() != null ? authService.getUser() : null;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 60.0),
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
                      ),
                    )),
              ),
              PagewiseSliverList(
                  pageSize: MeetingHistoryScreen.PAGE_SIZE,
                  itemBuilder: this._itemBuilder,
                  pageFuture: (pageIndex) {
                    /*page number should start from 1*/
                    String pageNumber =
                        (pageIndex! * MeetingHistoryScreen.PAGE_NUMBER + 1)
                            .toString();
                    return Repository.meetingHistoryPagination(
                            widget.userId, pageNumber)
                        .then((value) => value!);
                  },
                  noItemsFoundBuilder: (context) {
                    return EmptyMeetingHistory();
                  },
                  loadingBuilder: (context) {
                    return spinkit;
                  }),
            ],
          ),
        ),
      ),
      bottomSheet: SizedBox(),
    );
  }

  Widget _itemBuilder(context, MeetingHistoryModel meetingHistoryModel, _) {
    return GestureDetector(
        onTap: () async {
          String? userId =
              authUser != null ? authUser!.userId : "0"; //defaultUserID 0
          joinMeetingResponse = await Repository().joinMeeting(
              meetingCode: meetingHistoryModel.meetingCode,
              userId: userId,
              nickName: meetingHistoryModel.nickName);
          if (joinMeetingResponse != null)
            JitsiMeetUtils().joinMeeting(
                roomCode: meetingHistoryModel.meetingCode!,
                nameText: meetingHistoryModel.nickName);
        },
        child: meetingHistoryRow(meetingHistoryModel: meetingHistoryModel));
  }
}
