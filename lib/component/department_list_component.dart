import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/model/DepartmentResponse.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class DepartmentListComponent extends StatelessWidget {
  final DepartmentData? departmentdetail;
  final Color? bgColor;

  DepartmentListComponent({this.departmentdetail, this.bgColor});

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
              imageUrl: "https://w7.pngwing.com/pngs/44/599/png-transparent-building-computer-icons-library-school-building-icon-emblem-text-logo.png",
              fit: BoxFit.cover,
            ).cornerRadiusWithClipRRect(6)),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              departmentdetail!.code.toString(),
              textAlign: TextAlign.start,
              style: boldTextStyle(color: appStore.appTextPrimaryColor, size: 18),
            ),
            8.height,
            Text(
              departmentdetail!.name.toString(),
              textAlign: TextAlign.start,
              maxLines: 1,
              style: secondaryTextStyle(color: appStore.textSecondaryColor,size: 18),
            ),
          ],
        ),
      ],
    ).paddingAll(8);
  }
}
