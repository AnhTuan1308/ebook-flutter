import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthorDetailsComponent extends StatefulWidget {
  static String tag = '/AuthorDetailsComponent';
  final DashboardBookInfo? bookData;
  final Color? bgColor;

  AuthorDetailsComponent({this.bookData, this.bgColor});

  @override
  AuthorDetailsComponentState createState() => AuthorDetailsComponentState();
}

class AuthorDetailsComponentState extends State<AuthorDetailsComponent> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          child: CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: Container(height: 100, width: 80, child: bookLoaderWidget),
            ),
            imageUrl: widget.bookData!.thumbnailUrl.validate(),
            fit: BoxFit.cover,
            height: 100,
            width: 80,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.bookData!.title.validate(), style: boldTextStyle()),
            4.height,
            Text( widget.bookData!.numPages!.toString()),
            8.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.bookData!.publishYear!.toString(), style: boldTextStyle()).visible(widget.bookData!.publishYear!.toString().isNotEmpty),
                16.width.visible(widget.bookData!.publishYear!.toString().isNotEmpty),
              ],
            ).visible(widget.bookData!.publishYear!.toString().isNotEmpty || widget.bookData!.publishYear!.toString().isNotEmpty)
          ],
        ).expand()
      ],
    ).paddingOnly(right: 16, top: 8, bottom: 8);
  }
}






        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(widget.bookData!.name.validate(), style: boldTextStyle()),
        //     RatingBar.builder(
        //       initialRating: widget.bookData!.ratingCount!.toDouble(),
        //       allowHalfRating: true,
        //       ignoreGestures: true,
        //       minRating: 0,
        //       itemSize: 15.0,
        //       unratedColor: Colors.grey,
        //       direction: Axis.horizontal,
        //       itemCount: 5,
        //       itemBuilder: (context, _) => Icon(
        //         Icons.star,
        //         color: Colors.amber,
        //       ),
        //       onRatingUpdate: (double value) {},
        //     ),
        //   ],
        // ),