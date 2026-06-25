import 'package:flutter/material.dart';
import 'package:spagreen/src/models/privacy_policy_model.dart';
import 'package:spagreen/src/server/repository.dart';
import 'package:spagreen/src/style/theme.dart';
import 'package:spagreen/src/utils/app_tags.dart';
import 'package:spagreen/src/utils/loadingIndicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/localization_helper.dart' as helper;


class PrivacyPolicyScreen extends StatefulWidget {
  static final String route = '/PrivacyPolicyScreen';

  PrivacyPolicyScreen({
    Key? key,
  }) : super(key: key);

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  PrivacyPolicyModel? privacyPolicyModel;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPrivacyPolicy();
  }

  fetchPrivacyPolicy() async {
    privacyPolicyModel = await Repository().privacyPolicyResponse();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: CustomTheme.primaryColor,
        title: Text(helper.getTranslated(context, AppTags.privacyPolicy)!,),),
      body: privacyPolicyModel != null ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
             """ ${privacyPolicyModel!.privacyPolicyText}""",
          ),
        ),
      )
      // :Container(child: Center(
      //   child: spinkit,
      // ),),
      : WebViewWidget(
    controller: WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString(
        privacyPolicyModel?.privacyPolicyText ?? "<p>No content available</p>",
      ),
  ),


    );
  }
}
