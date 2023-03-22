import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/screens/about_us_screen.dart';
import 'package:flutterapp/screens/author_list_screen.dart';
import 'package:flutterapp/screens/category_list_screen.dart';
import 'package:flutterapp/screens/change_password_screen.dart';
import 'package:flutterapp/screens/default_setting_screen.dart';
import 'package:flutterapp/screens/department_list_screen.dart';
import 'package:flutterapp/screens/edit_profile_screen.dart';
import 'package:flutterapp/screens/my_bookmark_screen.dart';
import 'package:flutterapp/screens/my_cart_screen.dart';
import 'package:flutterapp/screens/sign_in_screen.dart';
import 'package:flutterapp/screens/transaction_history_screen.dart';
import 'package:flutterapp/screens/view_file_pdf.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with SingleTickerProviderStateMixin {
  String userImage = "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g";

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    userImage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor(appStore.scaffoldBackground!);
    return SafeArea(
      child: Scaffold(
        appBar: appBar(context, title: ''),
        backgroundColor: appStore.scaffoldBackground,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Text(keyString(context, 'title_account')!, style: boldTextStyle(size: 14)).paddingOnly(right: 16, left: 16),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                leading: CircleAvatar(backgroundImage: NetworkImage(userImage), radius: context.width() * 0.07),
                title: appStore.VietJetusername.validate(),
                titleTextStyle: boldTextStyle(size: 22),
                subTitle: appStore.VietJetusername.validate(),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide).whenComplete(getUserDetails);
                },
              ).visible(appStore.isLoggedIn),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_sign_in')!,
                titleTextStyle: primaryTextStyle(size: 20),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ).visible(!appStore.isLoggedIn),
              Divider(color: Colors.grey),
              Text(keyString(context, 'lbl_mode')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8),
              Row(
                children: [
                  Text(keyString(context, 'lbl_mode')!, style: primaryTextStyle(size: 18)).expand(),
                  Switch(
                    value: appStore.isDarkModeOn,
                    activeColor: PRIMARY_COLOR,
                    activeTrackColor: PRIMARY_COLOR,
                    onChanged: (val) async {
                      appStore.toggleDarkMode(value: val);
                      await setValue(isDarkModeOnPref, val);
                    },
                  ),
                ],
              ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8).onTap(() async {
                if (getBoolAsync(isDarkModeOnPref)) {
                  appStore.toggleDarkMode(value: false);
                  await setValue(isDarkModeOnPref, false);
                } else {
                  appStore.toggleDarkMode(value: true);
                  await setValue(isDarkModeOnPref, true);
                }
              }),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_default_animation')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  DefaultSettingScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              // SettingItemWidget(
              //   padding: EdgeInsets.all(16),
              //   title: keyString(context, 'lbl_change_pwd')!,
              //   titleTextStyle: primaryTextStyle(size: 18),
              //   decoration: BoxDecoration(borderRadius: radius()),
              //   onTap: () {
              //     ChangePasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              //   },
              // ).visible(appStore.isLoggedIn && !appStore.isSocialLogin),
              Divider(color: Colors.grey),
              Text(keyString(context, 'lbl_list')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_author')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  AuthorListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_categories')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  CategoriesListScreen(isShowBack: true).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                },
              ),
                SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_department')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  DepartmentListScreen().launch(context);
                    },
              ),
              Divider(color: Colors.grey).visible(appStore.isLoggedIn),
              Text(keyString(context, 'lbl_favorite_books')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8).visible(appStore.isLoggedIn),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_my_favorite_books')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  MyBookMarkScreen().launch(context);
                },
              ).visible(appStore.isLoggedIn),
              Divider(color: Colors.grey).visible(appStore.isLoggedIn),
              Text(keyString(context, 'lbl_history')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8).visible(appStore.isLoggedIn),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_my_request_history')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  MyCartScreen(isExtend: false,).launch(context);
                },
              ).visible(appStore.isLoggedIn),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_borrowed_history')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  TransactionHistoryScreen().launch(context);
                },
              ).visible(appStore.isLoggedIn),

              Divider(color: Colors.grey),
              Text(keyString(context, 'lbl_about')!, style: boldTextStyle(size: 14)).paddingOnly(left: 16, right: 16, top: 8),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_about')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  AboutUsScreen().launch(context);
                },
              ),
              // SettingItemWidget(
              //   padding: EdgeInsets.all(16),
              //   title: keyString(context, 'lbl_view_files')!,
              //   titleTextStyle: primaryTextStyle(size: 18),
              //   decoration: BoxDecoration(borderRadius: radius()),
              //   onTap: () {
              //     ViewFilePDF(bookData: mBookList[0],).launch(context);
              //   },
              // ),
              // SettingItemWidget(
              //   padding: EdgeInsets.all(16),
              //   title: keyString(context, 'lbl_terms_conditions')!,
              //   titleTextStyle: primaryTextStyle(size: 18),
              //   decoration: BoxDecoration(borderRadius: radius()),
              //   onTap: () {
              //     commonLaunchUrl(getStringAsync(TERMS_AND_CONDITIONS));
              //   },
              // ),
              // SettingItemWidget(
              //   padding: EdgeInsets.all(16),
              //   title: keyString(context, 'llb_privacy_policy')!,
              //   titleTextStyle: primaryTextStyle(size: 18),
              //   decoration: BoxDecoration(borderRadius: radius()),
              //   onTap: () {
              //     commonLaunchUrl(getStringAsync(PRIVACY_POLICY));
              //   },
              // ),
              SettingItemWidget(
                padding: EdgeInsets.all(16),
                title: keyString(context, 'lbl_logout')!,
                titleTextStyle: primaryTextStyle(size: 18),
                decoration: BoxDecoration(borderRadius: radius()),
                onTap: () {
                  logout(context);
                },
              ).visible(appStore.isLoggedIn)
            ],
          ),
        ),
      ),
    );
  }
}
