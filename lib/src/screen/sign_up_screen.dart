import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:spagreen/src/utils/app_tags.dart';
import '../services/database_service.dart';
import '../utils/localization_helper.dart' as helper;
import 'package:spagreen/src/bloc/auth/registration_bloc.dart';
import 'package:spagreen/src/bloc/auth/registration_event.dart';
import 'package:spagreen/src/bloc/auth/registration_state.dart';
import 'package:spagreen/src/models/get_config_model.dart';
import 'package:spagreen/src/models/user_model.dart';
import 'package:spagreen/src/services/authentication_service.dart';
import 'package:spagreen/src/style/theme.dart';
import 'package:spagreen/src/utils/edit_text_utils.dart';
import 'package:spagreen/src/utils/loadingIndicator.dart';
import 'package:spagreen/src/utils/validators.dart';
import 'package:spagreen/src/widgets/google_fb_phone_btn.dart';
import 'package:spagreen/src/widgets/signup_submit_btn.dart';
import '../../config.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  static final String route = '/SignUpScreen';
  SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() {
    return _SignUpScreenState();
  }
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _signUpFormkey = GlobalKey<FormState>();
  TextEditingController loginNameController = new TextEditingController();
  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();
  late bool _isRegistered;
  late Bloc bloc;
  late Bloc firebaseAuthBloc;
  bool? isMandatoryLogin = false;
  bool isLoading = false;
  //FacebookLogin facebookSignIn = new FacebookLogin();
  late AppConfig? appConfig;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<RegistrationBloc>(context);
    _isRegistered = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    ///read user data from phone(flutter hive box)
    _isRegistered = authService.getUser() != null ? true : false;
    //final configService = Provider.of<GetConfigService>(context);
    appConfig = DatabaseService().getConfigData()?.appConfig;
    isMandatoryLogin = appConfig != null ? appConfig!.mandatoryLogin : false;

    return new Scaffold(
      key: _scaffoldKey,
      body: _isRegistered ? MainScreen() : _renderRegisterWidget(authService),
    );
  }

  Widget _renderRegisterWidget(authService) {
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationStateCompleted) {
          isLoading = false;
          AuthUser? user = state.getUser;
          if (user == null) {
            //print("user is null");
            bloc.add(RegistrationFailed());
          } else {
            authService.updateUser(user);
          }
          if (authService.getUser() != null) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MainScreen()),
                (Route<dynamic> route) => false);
          }
        }
      },
      child: BlocBuilder<RegistrationBloc, RegistrationState>(
        builder: (context, state) {
          return SingleChildScrollView(
              child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            CustomTheme.primaryColor,
                            CustomTheme.primaryColorDark
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 75.0),
                        child: Image.asset(
                          'assets/images/common/logo.png',
                          scale: 5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 23.0),
                        child: Column(
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 30.0),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    boxShadow: CustomTheme.boxShadow,
                                    color: Colors.white,
                                  ),
                                  width: 300.0,
                                  height: 400,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20.0),
                                      Text(
                                        helper.getTranslated(
                                            context, AppTags.signup)!,
                                        style:
                                            CustomTheme.displayTextBoldColoured,
                                      ),
                                      Container(
                                          width: 60,
                                          height: 2,
                                          color: CustomTheme.primaryColor),
                                      SizedBox(height: 15),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0,
                                        ),
                                        child: Form(
                                          key: _signUpFormkey,
                                          child: Column(
                                            children: <Widget>[
                                              EditTextUtils()
                                                  .getCustomEditTextField(
                                                      hintValue:
                                                          helper.getTranslated(
                                                              context,
                                                              AppTags.name),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          loginNameController,
                                                      prefixWidget: Image.asset(
                                                        'assets/images/common/person.png',
                                                        height: 45.0,
                                                        width: 45.0,
                                                        scale: 3.5,
                                                      ),
                                                      style: CustomTheme
                                                          .textFieldTitle,
                                                      validator: (value) {
                                                        return validateNotEmpty(
                                                            value);
                                                      }),
                                              SizedBox(height: 10),
                                              EditTextUtils()
                                                  .getCustomEditTextField(
                                                      hintValue:
                                                          helper.getTranslated(
                                                              context,
                                                              AppTags
                                                                  .emailAddress),
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      controller:
                                                          loginEmailController,
                                                      prefixWidget: Image.asset(
                                                        'assets/images/common/email.png',
                                                        scale: 3.5,
                                                        height: 45.0,
                                                        width: 45.0,
                                                      ),
                                                      style: CustomTheme
                                                          .textFieldTitle,
                                                      validator: (value) {
                                                        return validateEmail(
                                                            value);
                                                      }),
                                              SizedBox(height: 10),
                                              EditTextUtils()
                                                  .getCustomEditTextField(
                                                      hintValue:
                                                          helper.getTranslated(
                                                              context,
                                                              AppTags.password),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      controller:
                                                          loginPasswordController,
                                                      prefixWidget: Image.asset(
                                                        'assets/images/authImage/password.png',
                                                        scale: 3.5,
                                                        height: 45.0,
                                                        width: 45.0,
                                                      ),
                                                      style: CustomTheme
                                                          .textFieldTitle,
                                                      obscureValue: true,
                                                      validator: (value) {
                                                        return validateMinLength(
                                                            value);
                                                      }),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            helper.getTranslated(context,
                                                AppTags.alReadyHaveAccount)!,
                                            style: CustomTheme.smallTextStyle,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                    context, LoginPage.route);
                                              },
                                              child: Text(
                                                helper.getTranslated(context,
                                                    AppTags.logInHere)!,
                                                style: CustomTheme
                                                    .smallTextStyleColoredUnderLine,
                                              )),
                                        ],
                                      ),
                                      Text(
                                        helper.getTranslated(
                                            context, AppTags.byPressingSubmit)!,
                                        style: CustomTheme.smallTextStyle,
                                      ),
                                      !isMandatoryLogin!
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  helper.getTranslated(context,
                                                      AppTags.backText)!,
                                                  style: CustomTheme
                                                      .smallTextStyleColored,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_signUpFormkey.currentState!
                                        .validate()) {
                                      isLoading = true;
                                      AuthUser user = AuthUser(
                                          name: loginNameController.text,
                                          email: loginEmailController.text);
                                      // Registration started bloc
                                      bloc.add(RegistrationStarted());
                                      bloc.add(RegistrationCompleting(
                                          user: user,
                                          password:
                                              loginPasswordController.text));
                                    }
                                  },
                                  child: signupSubmitButton(
                                      iconPath: 'login_submit'),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            ////google ,fb and phon auth button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[],
                            ),
                            SizedBox(height: 50.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isLoading) spinkit,
            ],
          ));
        },
      ),
    );
  }
}
