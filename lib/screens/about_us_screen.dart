import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/utils/admob_utils.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/images.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class AboutUsScreen extends StatefulWidget {
  static var tag = "/AboutUs";

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String? copyrightText = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  init() async {
    setState(() {
      if (getStringAsync(COPYRIGHT_TEXT).isNotEmpty) {
        copyrightText = getStringAsync(COPYRIGHT_TEXT);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: keyString(context, "lbl_about")),
      body: ListView(children: [
        Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(packageInfo.appName.toString(), style: boldTextStyle(color: PRIMARY_COLOR, size: 20)).center(),
          Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            decoration: boxDecoration(radius: defaultRadius),
            child: Image.asset(ic_logo),
          ).center(),
          Text(packageInfo.versionName.toString(), style: secondaryTextStyle()).center(),
          32.height,
          Text("HEXONTEAM", style: boldTextStyle(color: PRIMARY_COLOR, size: 20)).center(),
          8.height,
            Container(
            height: 180,
            width: 350,
            alignment: Alignment.center,
            decoration: boxDecoration(radius: defaultRadius),
            child:Column(
              children: [
                Container(
                alignment: Alignment.center,
                decoration: boxDecoration(radius: defaultRadius),
                child:CachedNetworkImage(
                height: 80,
                width: 80,
                placeholder: (context, url) => Center(child: bookLoaderWidget),
                imageUrl: "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g"
          ).cornerRadiusWithClipRRect(40),
          ).center(),
          Text("Văn Bá Khánh Duy", style: boldTextStyle()),
          Text("(Leader)", style: boldTextStyle(color: PRIMARY_COLOR)),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                16.width,
                InkWell(
                  onTap: () => commonLaunchUrl("https://www.facebook.com/khanhduy.vanba"),
                  child: Image.asset("ic_Fb.png", height: 35, width: 35),
                ),
                InkWell(
                  onTap: () => commonLaunchUrl('${0123123123}'),
                  child: Image.asset("ic_CallRing.png", height: 35, width: 35, color: PRIMARY_COLOR),
                ),
                16.width
              ],
            ),
              ],
            ),
          ).center().paddingAll(5),
          //   Container(
          //   height: 180,
          //   width: 350,
          //   alignment: Alignment.center,
          //   decoration: boxDecoration(radius: defaultRadius),
          //   child:Column(
          //     children: [
          //       Container(
          //       alignment: Alignment.center,
          //       decoration: boxDecoration(radius: defaultRadius),
          //       child:CachedNetworkImage(
          //       height: 80,
          //       width: 80,
          //       placeholder: (context, url) => Center(child: bookLoaderWidget),
          //       imageUrl: "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g"
          // ).cornerRadiusWithClipRRect(40),
          // ).center(),
          // Text("Nguyễn Thành Công", style: boldTextStyle()),
          // Text("(Back-End)", style: boldTextStyle(color: PRIMARY_COLOR)),
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       16.width,
          //       InkWell(
          //         onTap: () => commonLaunchUrl("https://www.facebook.com/toseetheworldistolive"),
          //         child: Image.asset("ic_Fb.png", height: 35, width: 35),
          //       ),
          //       InkWell(
          //         onTap: () => commonLaunchUrl("asdas"),
          //         child: Image.asset("ic_CallRing.png", height: 35, width: 35, color: PRIMARY_COLOR),
          //       ),
          //       16.width
          //     ],
          //   ),
          //     ],
          //   ),
          // ).center().paddingAll(5),
                      Container(
            height: 180,
            width: 350,
            alignment: Alignment.center,
            decoration: boxDecoration(radius: defaultRadius),
            child:Column(
              children: [
                Container(
                alignment: Alignment.center,
                decoration: boxDecoration(radius: defaultRadius),
                child:CachedNetworkImage(
                height: 80,
                width: 80,
                placeholder: (context, url) => Center(child: bookLoaderWidget),
                imageUrl: "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g"
          ).cornerRadiusWithClipRRect(40),
          ).center(),
          Text("Nguyễn Anh Tuấn", style: boldTextStyle()),
          Text("(Mobile)", style: boldTextStyle(color: PRIMARY_COLOR)),
                      Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                16.width,
                InkWell(
                  onTap: () => commonLaunchUrl("https://www.facebook.com/AnhTuanAT1308/"),
                  child: Image.asset("ic_Fb.png", height: 35, width: 35),
                ),
                InkWell(
                  onTap: () => commonLaunchUrl('${getStringAsync(CONTACT)}'),
                  child: Image.asset("ic_CallRing.png", height: 35, width: 35, color: PRIMARY_COLOR),
                ),
                16.width
              ],
            ),
              ],
            ),
          ).center().paddingAll(5),
             Container(
            height: 180,
            width: 350,
            alignment: Alignment.center,
            decoration: boxDecoration(radius: defaultRadius),
            child:Column(
              children: [
                Container(
                alignment: Alignment.center,
                decoration: boxDecoration(radius: defaultRadius),
                child:CachedNetworkImage(
                height: 80,
                width: 80,
                placeholder: (context, url) => Center(child: bookLoaderWidget),
                imageUrl: "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g"
          ).cornerRadiusWithClipRRect(40),
          ).center(),
          Text("Trần Vĩnh An", style: boldTextStyle()),
          Text("(Front-End)", style: boldTextStyle(color: PRIMARY_COLOR),),
                      Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                16.width,
                InkWell(
                  onTap: () => commonLaunchUrl("https://www.facebook.com/khanhduy.vanba"),
                  child: Image.asset("ic_Fb.png", height: 35, width: 35),
                ),
                InkWell(
                  onTap: () => commonLaunchUrl('${getStringAsync(CONTACT)}'),
                  child: Image.asset("ic_CallRing.png", height: 35, width: 35, color: PRIMARY_COLOR),
                ),
                16.width
              ],
            ),
              ],
            ),
          ).center().paddingAll(5),
        ],
      ).paddingAll(20),
      ],)
      // bottomNavigationBar: Container(
      //   width: context.width(),
      //   height: 180,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Text(keyString(context, 'llb_follow_us')!, style: boldTextStyle()).visible(getStringAsync(WHATSAPP).isNotEmpty),
      //       16.height,
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: <Widget>[
      //           16.width,
      //           InkWell(
      //             onTap: () => commonLaunchUrl('${getStringAsync(WHATSAPP)}'),
      //             child: Image.asset("ic_Whatsapp.png", height: 35, width: 35).paddingAll(10),
      //           ).visible(getStringAsync(WHATSAPP).isNotEmpty),
      //           InkWell(
      //             onTap: () => commonLaunchUrl(getStringAsync(INSTAGRAM)),
      //             child: Image.asset("ic_Inst.png", height: 35, width: 35).paddingAll(10),
      //           ).visible(getStringAsync(INSTAGRAM).isNotEmpty),
      //           InkWell(
      //             onTap: () => commonLaunchUrl(getStringAsync(TWITTER)),
      //             child: Image.asset("ic_Twitter.png", height: 35, width: 35).paddingAll(10),
      //           ).visible(getStringAsync(TWITTER).isNotEmpty),
      //           InkWell(
      //             onTap: () => commonLaunchUrl(getStringAsync(FACEBOOK)),
      //             child: Image.asset("ic_Fb.png", height: 35, width: 35).paddingAll(10),
      //           ).visible(getStringAsync(FACEBOOK).isNotEmpty),
      //           InkWell(
      //             onTap: () => commonLaunchUrl('${getStringAsync(CONTACT)}'),
      //             child: Image.asset("ic_CallRing.png", height: 35, width: 35, color: PRIMARY_COLOR).paddingAll(10),
      //           ).visible(getStringAsync(CONTACT).isNotEmpty),
      //           16.width
      //         ],
      //       ),
      //       Text(copyrightText!, style: secondaryTextStyle()),
      //       4.height,
      //       Container(
      //         height: AdSize.banner.height.toDouble(),
      //         child: AdWidget(
      //           ad: BannerAd(
      //             adUnitId: getBannerAdUnitId()!,
      //             size: AdSize.banner,
      //             request: AdRequest(),
      //             listener: BannerAdListener(),
      //           )..load(),
      //         ).visible(isAdsLoading == true),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
