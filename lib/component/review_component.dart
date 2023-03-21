import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/ReviewResponse.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutterapp/model/DashboardResponse.dart';


class ReviewComponent extends StatefulWidget {
  static String tag = '/ReviewComponent';
  final Comments? reviewData;

  ReviewComponent({this.reviewData});

  @override
  ReviewComponentState createState() => ReviewComponentState();
}

class ReviewComponentState extends State<ReviewComponent> {
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
    return GestureDetector(
      child: Container(
        decoration: boxDecorationWithRoundedCorners(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(36),
            ),
            backgroundColor: appStore.isDarkModeOn ? appStore.appColorPrimaryLightColor! : Colors.white),
        padding: EdgeInsets.all(16), 
        margin: EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.reviewData!.commenterUsername.toString(),
              textAlign: TextAlign.left,
              style: boldTextStyle(size: 14),
            ),
            4.height,
            Text(
              widget.reviewData!.text!.toString(),
              textAlign: TextAlign.justify,
              maxLines: 6,
              style: secondaryTextStyle(),
            ),
            4.height,
            Text(
            reviewConvertDate(widget.reviewData!.commentedAt),
            textAlign: TextAlign.right,
            style: TextStyle(color: appStore.textSecondaryColor, fontSize: 14, fontWeight: FontWeight.normal, height: 1),
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RatingBar.builder(
                  allowHalfRating: true,
                  ignoreGestures: true,
                  initialRating: (widget.reviewData!.rating.toString() == "") ? 00.00 : double.parse(widget.reviewData!.rating.toString()),
                  minRating: 1,
                  itemSize: 15.0,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (double value) {},
                ),
                8.width,
                Text(
                  reviewConvertDate(widget.reviewData!.commentedAt),
                  style: secondaryTextStyle(),
                ),
              ],
            ),
            4.height,
          ],
        ),
      ),
    );
  }
}
