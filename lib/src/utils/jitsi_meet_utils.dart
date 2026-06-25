// //!Previous

// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:hive/hive.dart';
// // import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
// import 'package:spagreen/constants.dart';
// import 'package:spagreen/src/models/get_config_model.dart';
// import 'package:spagreen/src/services/database_service.dart';

// import '../style/theme.dart';

// class JitsiMeetUtils {
//   /*below properties for meeting*/
//   var isAudioOnly = false;
//   var isAudioMuted = true;
//   var isVideoMuted = false;
//   String? serverUrl;
//   joinMeeting({required String roomCode, String? nameText}) async {
//     //fetch serverUrl from hiveBox
//     AppConfig? appConfig = DatabaseService().getConfigData()?.appConfig;
//     if (appConfig
//                 ?.jitsiServer !=
//             null &&
//         appConfig
//                 ?.jitsiServer !=
//             "") {
//       serverUrl = appConfig
//           ?.jitsiServer;
//     }
//     try {
//       // Enable or disable any feature flag here
//       // If feature flag are not provided, default values will be used
//       // Full list of feature flags (and defaults) available in the README
//       Map<FeatureFlagEnum, bool> featureFlags = {
//         FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
//       };
//       // Here is an example, disabling features for each platform
//       if (Platform.isAndroid) {
//         // Disable ConnectionService usage on Android to avoid issues (see README)
//         featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
//       }

//       featureFlags[FeatureFlagEnum.INVITE_ENABLED] = false;

//       var options = JitsiMeetingOptions(room: roomCode)
//         ..serverURL = serverUrl
// //        ..subject = subjectText.text
//         ..userDisplayName = nameText
// //        ..userEmail = emailText.text
//         //       ..iosAppBarRGBAColor = CustomTheme.iosMeetingAppBarRGBAColor
//         ..featureFlags = featureFlags
//         ..audioOnly = isAudioOnly
//         ..audioMuted = isAudioMuted
//         ..videoMuted = isVideoMuted;

//       debugPrint("JitsiMeetingOptions: $options");
//       await JitsiMeet.joinMeeting(
//         options,
//         listener: JitsiMeetingListener(onConferenceWillJoin: (message) {
//           debugPrint("${options.room} will join with message: $message");
//         }, onConferenceJoined: (message) {
//           debugPrint("${options.room} joined with message: $message");
//         }, onConferenceTerminated: (message) {
//           debugPrint("${options.room} terminated with message: $message");
//         }),
//         // by default, plugin default constraints are used
//         //roomNameConstraints: new Map(), // to disable all constraints
//         //roomNameConstraints: customContraints, // to use your own constraint(s)
//       );
//     } catch (error) {
//       debugPrint("error: $error");
//     }
//   }

//   hostMeeting({
//     required String roomCode,
//     String? meetingTitle,
//   }) async {
//     //fetch serverUrl from hiveBox

//     AppConfig? appConfig = DatabaseService().getConfigData()?.appConfig;
//     if (appConfig?.jitsiServer != null && appConfig?.jitsiServer != "") {
//       serverUrl = appConfig?.jitsiServer;
//     }
//     try {
//       Map<FeatureFlagEnum, bool> featureFlags = {
//         FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
//         //FeatureFlagEnum.INVITE_ENABLED: false,
//       };
//       // Here is an example, disabling features for each platform
//       if (Platform.isAndroid) {
//         // Disable ConnectionService usage on Android to avoid issues (see README)
//         featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
//       } else if (Platform.isIOS) {
//         // Disable PIP on iOS as it looks weird
//         featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
//       }

//       var options = JitsiMeetingOptions(room: roomCode)
//         ..serverURL = serverUrl
//         ..subject = ""
//         ..userEmail = ""
//         ..userDisplayName = ""
//         ..iosAppBarRGBAColor = CustomTheme.iosMeetingAppBarRGBAColor
//         ..featureFlags.addAll(featureFlags)
//         ..audioOnly = isAudioOnly
//         ..audioMuted = isAudioMuted
//         ..videoMuted = isVideoMuted;

//       printLog("-----JitsiMeetingOptions: $options");
//       await JitsiMeet.joinMeeting(
//         options,
//         listener: JitsiMeetingListener(
//             onConferenceWillJoin: (message) {
//               debugPrint("${options.room} will join with message: $message");
//             },
//             onConferenceJoined: (message) {
//               debugPrint("${options.room} joined with message: $message");
//             },
//             onConferenceTerminated: (message) {
//               debugPrint("${options.room} terminated with message: $message");
//             },
//             genericListeners: [
//               JitsiGenericListener(
//                 eventName: 'readyToClose',
//                 callback: (dynamic message) {
//                   debugPrint("readyToClose callback");
//                 },
//               )
//             ]),
//         // by default, plugin default constraints are used
//         //roomNameConstraints: new Map(), // to disable all constraints
//         //roomNameConstraints: customContraints, // to use your own constraint(s)
//       );
//     } catch (error) {
//       debugPrint("error: $error");
//     }
//   }

//   void onConferenceWillJoin(message) {
//     debugPrint("_onConferenceWillJoin broadcasted with message: $message");
//   }

//   void onConferenceJoined(message) {
//     debugPrint("_onConferenceJoined broadcasted with message: $message");
//   }

//   void onConferenceTerminated(message) {
//     debugPrint("_onConferenceTerminated broadcasted with message: $message");
//   }

//   onError(error) {
//     debugPrint("_onError broadcasted: $error");
//   }
// }

//!Changes

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:spagreen/constants.dart';
import 'package:spagreen/src/models/get_config_model.dart';
import 'package:spagreen/src/services/database_service.dart';

class JitsiMeetUtils {
  /*below properties for meeting*/
  var isAudioOnly = false;
  var isAudioMuted = true;
  var isVideoMuted = false;
  String? serverUrl;

  // JitsiMeet instance
  JitsiMeet? jitsiMeet;

  // Initialize and setup listeners
  void _initializeJitsi() {
    jitsiMeet = JitsiMeet();
  }

  joinMeeting({required String roomCode, String? nameText}) async {
    //fetch serverUrl from hiveBox
    AppConfig? appConfig = DatabaseService().getConfigData()?.appConfig;
    String defaultServerUrl = "https://meet.jit.si"; //"https://meet.jit.si";

    if (appConfig?.jitsiServer != null && appConfig?.jitsiServer != "") {
      serverUrl = appConfig?.jitsiServer;
    } else {
      serverUrl = defaultServerUrl;
    }

    try {
      // Initialize Jitsi
      _initializeJitsi();

      // Configure feature flags (string-based)
      var featureFlags = <String, bool>{
        "welcomepage.enabled": false,
        "invite.enabled": false,
      };

      // Platform specific flags
      if (Platform.isAndroid) {
        featureFlags["call-integration.enabled"] = false;
      }

      // Configure meeting options
      var options = JitsiMeetConferenceOptions(
        room: roomCode,
        serverURL: serverUrl,
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
          "startAudioOnly": isAudioOnly,
        },
        featureFlags: featureFlags,
        userInfo: JitsiMeetUserInfo(
          displayName: nameText ?? "",
        ),
      );

      debugPrint("JitsiMeetConferenceOptions: $options");

      // Setup listeners
      var listener = JitsiMeetEventListener(
        conferenceJoined: (url) {
          debugPrint("$roomCode joined with url: $url");
        },
        conferenceWillJoin: (url) {
          debugPrint("$roomCode will join with url: $url");
        },
        conferenceTerminated: (url, error) {
          debugPrint("$roomCode terminated with url: $url, error: $error");
        },
        readyToClose: () {
          debugPrint("readyToClose callback");
          cleanUp();
        },
      );

      // Join the meeting
      await jitsiMeet!.join(options, listener);
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  hostMeeting({
    required String roomCode,
    String? meetingTitle,
  }) async {
    //fetch serverUrl from hiveBox
    AppConfig? appConfig = DatabaseService().getConfigData()?.appConfig;
    String defaultServerUrl = "https://meet.jit.si";

    if (appConfig?.jitsiServer != null && appConfig?.jitsiServer != "") {
      serverUrl = appConfig?.jitsiServer;
    } else {
      serverUrl = defaultServerUrl;
    }

    try {
      // Initialize Jitsi
      _initializeJitsi();

      // Configure feature flags (string-based)
      var featureFlags = <String, bool>{
        "welcomepage.enabled": false,
        // invite.enabled is kept true for host (commented out the disable)
      };

      // Platform specific flags
      if (Platform.isAndroid) {
        featureFlags["call-integration.enabled"] = false;
      } else if (Platform.isIOS) {
        featureFlags["pip.enabled"] = false;
      }

      // Configure meeting options
      var options = JitsiMeetConferenceOptions(
        room: roomCode,
        serverURL: serverUrl,
        configOverrides: {
          "startWithAudioMuted": isAudioMuted,
          "startWithVideoMuted": isVideoMuted,
          "startAudioOnly": isAudioOnly,
          "subject": meetingTitle ?? "",
        },
        featureFlags: featureFlags,
        userInfo: JitsiMeetUserInfo(
          displayName: "",
          email: "",
        ),
      );

      printLog("-----JitsiMeetConferenceOptions: $options");

      // Setup listeners
      var listener = JitsiMeetEventListener(
        conferenceJoined: (url) {
          debugPrint("$roomCode joined with url: $url");
        },
        conferenceWillJoin: (url) {
          debugPrint("$roomCode will join with url: $url");
        },
        conferenceTerminated: (url, error) {
          debugPrint("$roomCode terminated with url: $url, error: $error");
        },
        readyToClose: () {
          debugPrint("readyToClose callback");
          cleanUp();
        },
      );

      // Join the meeting
      await jitsiMeet?.join(options, listener);
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  void onConferenceWillJoin(String? url) {
    debugPrint("_onConferenceWillJoin broadcasted with url: $url");
  }

  void onConferenceJoined(String? url) {
    debugPrint("_onConferenceJoined broadcasted with url: $url");
  }

  void onConferenceTerminated(String? url, String? error) {
    debugPrint(
        "_onConferenceTerminated broadcasted with url: $url, error: $error");
  }

  onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  // Clean up resources
  void cleanUp() {
    jitsiMeet = null;
  }

  // Call this method when disposing the widget/screen
  void dispose() {
    cleanUp();
  }
}
