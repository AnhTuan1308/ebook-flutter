import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/screens/author_wise_book_screen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutterapp/model/DashboardResponse.dart';


import '../app_localizations.dart';
import '../main.dart';

// ignore: must_be_immutable
class GetAuthorComponent extends StatefulWidget {
  static String tag = '/GetAuthorComponent';
  Authors? authorDetails;

  GetAuthorComponent(this.authorDetails);

  @override
  GetAuthorComponentState createState() => GetAuthorComponentState();
}

class GetAuthorComponentState extends State<GetAuthorComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => Center(
                child: bookLoaderWidget,
              ),
              width: 45,
              height: 45,
              imageUrl: "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g",
              fit: BoxFit.fill,
            ).cornerRadiusWithClipRRect(30),
            8.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.authorDetails!.fullName.toString().trim(),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  softWrap: false,
                  style: boldTextStyle(color: appStore.appTextPrimaryColor),
                ),
                Text(
                  keyString(context, "lbl_tap_to_see_author_details")!,
                  textAlign: TextAlign.start,
                  style: secondaryTextStyle(
                    color: appStore.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        Icon(
          Icons.chevron_right,
          color: appStore.iconSecondaryColor,
          size: 32.0,
          textDirection: appStore.isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
      ],
    ).paddingOnly(left: 16, right: 16).onTap(() {
      AuthorWiseBookScreen(
        "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g",
        widget.authorDetails!.fullName.toString(),
        authorDetails: widget.authorDetails!,
        isDetail: true,
      )
      .launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
    });
  }
}
