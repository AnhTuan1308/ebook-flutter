import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/forgot_password_component.dart';
import 'package:flutterapp/model/LoginResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/mobile_number_signin_screen.dart';
import 'package:flutterapp/service/LoginService.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

import '../main.dart';
import 'NoInternetConnection.dart';
import 'dashboard_screen.dart';
import 'error_view_screeen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  final bool? isBookDescription;

  SignInScreen({this.isBookDescription = false});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  var usernameCont = TextEditingController();
  var passwordCont = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool? isRemember = false;
  var autoValidate = false;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    if (Platform.isIOS) {
      TheAppleSignIn.onCredentialRevoked!.listen((_) {
        log("Credentials revoked");
      });
    }
    var remember = getBoolAsync(REMEMBER_PASSWORD);
    if (remember) {
      var email = getStringAsync(EMAIL);
      setState(() {
        usernameCont.text = email;
        passwordCont.text = appStore.password;

      });
    }
    setState(() {
      isRemember = remember;
    });
  }

  ///login api call
  Future loginApiCall(request) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        appStore.setLoading(true);
        // await getLoginUserRestApi(request).then((res) async {
          // LoginResponse response = LoginResponse.fromJson(res);
        //   await appStore.setToken(response.token!);
        //   await appStore.setUserName(response.userNicename!);
        //   await appStore.setLastName(response.lastName!);
        //   await appStore.setUserId(response.userId!);
        //   await appStore.setUserEmail(response.userEmail!);
        //   await appStore.setAvatar(response.avatar!);
        // Real Login
        // var realrequest = {"username": "adminlib", "password": "password123@"};
        await getVietJetLoginUserRestApi(request).then((responsedata) async {
          LoginResponseData loginResponseData = LoginResponseData.fromJson(responsedata);
          LoginData data = loginResponseData.data!;
          await appStore.setVietJetUserId(data.userID!);
          await appStore.setVietJetUserName(data.username!);
          // await appStore.setVietJetFullName(data.userfullName!);
          await appStore.setVietJetSysToken(data.sysToken!);
          await appStore.setVietJetSysTokenExpires(data.sysTokenExpires!);
          await appStore.setVietJetVolToken(data.volToken!);
          await appStore.setVietJetVolTokenExpires(data.volTokenExpires!);
          await appStore.setVietJetRefreshToken(data.refreshToken!);
          await appStore.setVietJetRefreshTokenExpires(data.refreshTokenExpires!);
          await appStore.setVietJetRoles(data.roles!);
          await appStore.setVietJetPermisssions(data.permisssions!);
        // });
        // Real Login
          setValue(REMEMBER_PASSWORD, isRemember!);
          await appStore.setPassword(passwordCont.text.toString());
          if (isRemember!) {
            setValue(EMAIL, usernameCont.text.toString());
          } else {
            setValue(EMAIL, '');
          }
          await appStore.setDisplayName(data.username!);
          await appStore.setLoggedIn(true);
          appStore.setLoading(false);
          DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
        }).catchError((onError) {
          appStore.setLoading(false);

          log(onError.toString());
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        appStore.setLoading(false);

        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  void dispose() {
    setStatusBarColor(widget.isBookDescription! ? Colors.grey.shade300 : appStore.scaffoldBackground!);
    super.dispose();
  }

  Future<void> socialLogin(req) async {
    appStore.setLoading(true);
    await socialLoginApi(req).then((response) async {
      if (!mounted) return;
      await getCustomer(response['user_id']).then((res) async {
        if (!mounted) return;
        await appStore.setToken(response['token']);
        await appStore.setUserName(response['user_nicename']);
        await appStore.setFirstName(res['first_name']);
        await appStore.setLastName(res['last_name']);
        await appStore.setDisplayName(response['user_display_name']);
        await appStore.setUserId(response['user_id']);
        await appStore.setUserEmail(response['user_email']);
        await appStore.setAvatar(req['photoURL']);
        await appStore.setLoggedIn(true);
        await appStore.setSocialLogin(true);
        appStore.setLoading(false);

        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }).catchError((error) {
        appStore.setLoading(false);
        print(error.toString());
        toast(error.toString());
      });
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  ///google sign in
  // void googleSignIn() async {
  //   var service = LoginService();
  //   await service.signInWithGoogle().then((res) async {
  //     appStore.setLoading(false);
  //     await socialLogin(res);
  //   }).catchError((e) {
  //     appStore.setLoading(false);
  //     toast(e.toString());
  //   });
  // }

  // saveAppleDataWithoutEmail() async {
  //   await getSharedPref().then((pref) {
  //     var req = {
  //       'email': getStringAsync('appleEmail'),
  //       'firstName': getStringAsync('appleGivenName'),
  //       'lastName': getStringAsync('appleFamilyName'),
  //       'photoURL': '',
  //       'accessToken': '12345678',
  //       'loginType': 'apple',
  //     };
  //     socialLogin(req);
  //   });
  // }

  // saveAppleData(result) async {
  //   var req = {
  //     'email': result.credential.email,
  //     'firstName': result.credential.fullName.givenName,
  //     'lastName': result.credential.fullName.familyName,
  //     'photoURL': '',
  //     'accessToken': '12345678',
  //     'loginType': 'apple',
  //   };
  //   socialLogin(req);
  // }

  ///api data call
  // Future<void> appleLogIn() async {
  //   if (await TheAppleSignIn.isAvailable()) {
  //     final AuthorizationResult result = await TheAppleSignIn.performRequests([
  //       AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //     ]);
  //     switch (result.status) {
  //       case AuthorizationStatus.authorized:
  //         log("Result: $result"); //All the required credentials
  //         if (result.credential!.email == null) {
  //           saveAppleDataWithoutEmail();
  //         } else {
  //           saveAppleData(result);
  //         }
  //         break;
  //       case AuthorizationStatus.error:
  //         log("Sign in failed: ${result.error!.localizedDescription}");
  //         break;
  //       case AuthorizationStatus.cancelled:
  //         log('User cancelled');
  //         break;
  //     }
  //   } else {
  //     toast(keyString(context, "lbl_apple_signin_not_available")!);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [Color(0xE64268cd), Color(0xBF4268cd), Color(0xA64268cd)]),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                30.height,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    16.height,
                    Container(
                      decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(defaultRadius)),
                      child: Image.asset("main_logo.png", width: 60, height: 60, fit: BoxFit.cover),
                    ).center(),
                    16.height,
                    Text(keyString(context, 'lbl_sign_in')!, style: boldTextStyle(size: 40, color: Colors.white)).center(),
                    Text(keyString(context, 'lbl_welcome_back')!, style: secondaryTextStyle(color: Colors.white, size: 16)).center(),
                  ],
                ).paddingAll(16),
                16.height,
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: appStore.isDarkModeOn ? appStore.appColorPrimaryLightColor! : Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        80.height,
                        Container(
                          decoration: boxDecorationWithRoundedCorners(boxShadow: defaultBoxShadow()),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                                    color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white,
                                  ),
                                  child: AppTextField(
                                    controller: usernameCont,
                                    autoFocus: false,
                                    focus: userNameFocusNode,
                                    nextFocus: passwordFocusNode,
                                    textFieldType: TextFieldType.USERNAME,
                                    decoration: InputDecoration(
                                      hintText: keyString(context, "hint_enter_email"),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[200]!)), color: appStore.isDarkModeOn ? cardBackgroundBlackDark : Colors.white),
                                  child: AppTextField(
                                    controller: passwordCont,
                                    textFieldType: TextFieldType.PASSWORD,
                                    autoFocus: false,
                                    focus: passwordFocusNode,
                                    decoration: InputDecoration(
                                      hintText: keyString(context, "hint_enter_password"),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).paddingSymmetric(horizontal: 24),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                CustomTheme(
                                  child: Checkbox(
                                    focusColor: PRIMARY_COLOR,
                                    activeColor: PRIMARY_COLOR,
                                    value: isRemember,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isRemember = value;
                                      });
                                    },
                                  ),
                                ),
                                Text(keyString(context, "lbl_remember_me")!, style: secondaryTextStyle(size: 16)),
                              ],
                            ),
                          ],
                        ).paddingOnly(left: 8, right: 24),
                        42.height,
                        AppButton(
                          text: keyString(context, "lbl_sign_in"),
                          textStyle: boldTextStyle(color: Colors.white),
                          shapeBorder: RoundedRectangleBorder(borderRadius: radius(30)),
                          width: context.width() * 0.7,
                          color: PRIMARY_COLOR,
                          onTap: () {
                            // hideKeyboard(context);
                            var request = {"username": "${usernameCont.text}", "password": "${passwordCont.text}"};
                            if (!mounted) return;
                            setState(() {
                              if (_formKey.currentState!.validate()) {
                                appStore.setLoading(true);
                                loginApiCall(request);
                              } else {
                                appStore.setLoading(false);
                                setState(() {
                                  autoValidate = true;
                                });
                              }
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(keyString(context, "lbl_don_t_have_an_account")!, style: primaryTextStyle()),
                            4.width,
                            Text(keyString(context, 'lbl_contact_your_administrator')!, style: primaryTextStyle(color: PRIMARY_COLOR)),

                          ],
                        ).center(heightFactor: 6),
                      Container(
                      decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.circular(defaultRadius)),
                      child: Image.asset("main_logo.png", width: 60, height: 60, fit: BoxFit.cover),
                    ).center(),
                        Text(packageInfo.versionName.toString(), style: secondaryTextStyle(size: 15)).center(heightFactor: 1),

                      ],
                    ),
                  ),
                ).expand()
              ],
            ),
          ),
          Observer(builder: (_) => CircularProgressIndicator().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
