import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class AuthorListComponent extends StatelessWidget {
  final Author? authorDetails;
  final Color? bgColor;

  AuthorListComponent(this.authorDetails, this.bgColor);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(6),
              border: Border.all(color: bgColor!, width: 3),
              backgroundColor: bgColor!,
            ),
            child: CachedNetworkImage(
              placeholder: (context, url) => Center(child: bookLoaderWidget),
              width: 70,
              height: 70,
              imageUrl: "https://secure.gravatar.com/avatar/4e838b59bfff152199fcc9bc3b4aa02e?s=96&d=mm&r=g",
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(6)),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authorDetails!.fullName.toString(),
              textAlign: TextAlign.start,
              style: boldTextStyle(color: appStore.appTextPrimaryColor, size: 18),
            ),
            Text(
              authorDetails!.fullName.toString(),
              textAlign: TextAlign.start,
              maxLines: 1,
              style: secondaryTextStyle(color: appStore.textSecondaryColor),
            ),
          ],
        ),
      ],
    ).paddingAll(8);
  }
}
