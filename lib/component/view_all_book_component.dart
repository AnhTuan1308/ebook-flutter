import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/Strings.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ViewAllBookComponent extends StatefulWidget {
  static String tag = '/ViewAllBookComponent';
  final DashboardBookInfo? bookData;
  // final String? categoryName;

  ViewAllBookComponent({this.bookData});

  @override
  ViewAllBookComponentState createState() => ViewAllBookComponentState();
}

class ViewAllBookComponentState extends State<ViewAllBookComponent> {
  bool mIsFreeBook = false;
  bool mIsSalePrice = false;

  @override
  void initState() {
    super.initState();
    // init();
  }

  // init() async {
  //   getBookPrice();
  // }

  // Future<void> getBookPrice() async {
  //   if ((widget.bookData!.price.toString().isEmpty || widget.bookData!.price.toString() == "0") &&
  //           (widget.bookData!.salePrice.toString().isEmpty || widget.bookData!.salePrice.toString() == "0") &&
  //           widget.bookData!.regularPrice.toString().isEmpty ||
  //       widget.bookData!.regularPrice.toString() == "0") {
  //     // if((widget.bookData!.price == "" && widget.bookData!.price!="0") || (widget.bookData!.salePrice == "" && widget.bookData!.salePrice != "0") ||(widget.bookData!.regularPrice == "" && widget.bookData!.regularPrice != "0")){
  //     mIsFreeBook = true;
  //   } else {
  //     mIsFreeBook = false;
  //   }
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    var language = "";
    switch(widget.bookData!.language) {
      case "vi" : {
        language = "Vietnamese";
        break;
      }
      case "en": {
        language = "English";
        break;
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          child: CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: Container(height: 100, width: 80, child: bookLoaderWidget),
            ),
            imageUrl: widget.bookData!.thumbnailUrl.validate(),
            fit: BoxFit.cover,
            height: 120,
            width: 90,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bookData!.title.validate(), style: boldTextStyle()),
            8.height,
            Html(
              data: language,
              style: {
                "body": Style(fontSize: FontSize(15), color: appStore.appTextPrimaryColor, margin: Margins.zero, padding: EdgeInsets.zero),
              },
            ).paddingLeft(5),
            8.height,
                        Container(
                      width: 85,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(30)),
                      child: Text(
                          "${widget.bookData!.authors![0].fullName}",
                              style: primaryTextStyle(color: white,),maxLines: 1,textAlign: TextAlign.center,
              ),
              ),
            8.height,
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(widget.bookData!.publishYear!.toString(), style: boldTextStyle()).visible(widget.bookData!.publishYear!.toString().isNotEmpty),
            //     16.width.visible(widget.bookData!.publishYear!.toString().isNotEmpty),
            //   ],
            // ).visible(widget.bookData!.publishYear!.toString().isNotEmpty || widget.bookData!.publishYear!.toString().isNotEmpty).paddingLeft(5)
          ],
        ).expand()
      ],
    );
  }
}
