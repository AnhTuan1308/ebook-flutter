import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutterapp/adapterView/Review.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/screens/review_screen.dart';
import 'package:flutterapp/screens/sign_in_screen.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

// ignore: must_be_immutable
class AllReviewComponent extends StatefulWidget {
  DashboardBookInfo mBookDetailsData;
  bool? mIsFreeBook;
  bool? isLoginIn;
  String bookId;
  Function? onUpdate;

  AllReviewComponent(this.mBookDetailsData,this.mIsFreeBook, this.isLoginIn,this.bookId);

  @override
  AllReviewComponentState createState() => AllReviewComponentState();
}

class AllReviewComponentState extends State<AllReviewComponent> {
  final int page = 1;
  @override
  void initState() {
    super.initState();
    // showDialog1(context);
    // init();
  }

  // Future<void> init() async {
  //   var reviewData = widget.mBookDetailsData.comments!.where((element) {
  //     if (element.! == appStore.userEmail) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   });
  //   if (reviewData.length >= 1) {
  //     appStore.setReview(true);
  //   } else {
  //     appStore.setReview(false);
  //   }
  // }

  String getReviewCount() {
    if (widget.mBookDetailsData.comments != null) {
    } else {
      return "0";
    }
    return widget.mBookDetailsData.comments!.length.toString();
  }

  double getAvgReviewCount(List<Comments> comments) {
    double totalReview = 0.0;
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].rating != 0) totalReview = totalReview + comments[i].rating!.toDouble();
    }
    if (totalReview == 0.0)
      return 0.0;
    else
      return totalReview / comments.length.toDouble();
  }

  Future showDialog1(BuildContext context) async {
    var ratings = 0.0;
    var reviewCont = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: appStore.scaffoldBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)), //this right here
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  keyString(context, "lbl_how_much_do_you_love")!,
                  style: TextStyle(fontSize: mobile_font_size_large, color: appStore.appTextPrimaryColor, fontWeight: FontWeight.bold),
                ),
                8.height,
                Text(
                  keyString(context, "lbl_more_than_i_can_say")!,
                  style: TextStyle(fontSize: 18, color: appStore.textSecondaryColor),
                ),
                8.height,
                RatingBar.builder(
                  allowHalfRating: true,
                  initialRating: 0,
                  minRating: 1,
                  itemSize: 30.0,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  unratedColor: Colors.amber.withOpacity(0.3),
                  onRatingUpdate: (double value) {
                    ratings = value;
                  },
                ),
                8.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: appStore.appTextPrimaryColor),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: keyString(context, "lbl_write_review"),
                    filled: true,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    fillColor: appStore.editTextBackColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
                    ),
                  ),
                  controller: reviewCont,
                  maxLines: 3,
                  minLines: 3,
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: PRIMARY_COLOR, style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        keyString(context, "lbl_cancel")!,
                        style: TextStyle(color: PRIMARY_COLOR),
                      ),
                    ),
                    20.width,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: PRIMARY_COLOR,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      ),
                      onPressed: () {
                        postReviewApi(reviewCont.text,ratings);
                        // hideKeyboard(context);

                      },
                      child: Text(
                        keyString(context, "lbl_submit")!,
                        style: TextStyle(color: whileColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Review API
  Future postReviewApi(review,ratings) async {
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        var request = {"text":"${review}", "rating":ratings};
        await bookReviewRestApi(widget.bookId,request).then((res) async {          
          LiveStream().emit(REFRESH_REVIEW_LIST);
          appStore.setReview(true);
          finish(context);
        }
        )
        .catchError((onError) {
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(getAvgReviewCount(widget.mBookDetailsData.comments!).toString(), style: primaryTextStyle(size: 36)),
                8.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBar.builder(
                      initialRating: getAvgReviewCount(widget.mBookDetailsData.comments!),
                      allowHalfRating: true,
                      ignoreGestures: true,
                      minRating: 0,
                      itemSize: 15.0,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (double value) {},
                    ),
                    4.height,
                    Text("(" + getReviewCount() + " " + keyString(context, "lbl_reviews")! + ")", style: secondaryTextStyle()).visible(widget.mBookDetailsData != null),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PRIMARY_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () => {showDialog1(context)},
              child: Text(
                keyString(context, "lbl_add_review")!,
                style: boldTextStyle(color: whileColor, size: 14),
              ),
            ).visible(widget.isLoginIn! && !appStore.isReview),
          ],
        ).paddingSymmetric(horizontal: 16).visible(true),
        (widget.mBookDetailsData.comments!.isNotEmpty)
            ? ListView.builder(
                padding: EdgeInsets.only(left: 16, right: 16),
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if(index < page) {
                    return new GestureDetector(
                    child: Review(widget.mBookDetailsData.comments![index]),
                  );
                  } else {
                    return Text(
                    "",
                  );
                  }
                },
                itemCount: widget.mBookDetailsData.comments?.length,
                shrinkWrap: true,
              ).visible(widget.mBookDetailsData.comments!.length > 0)
            : Container(
                height: 100,
                child: Center(
                  child: Text(
                    keyString(context, "lbl_no_review_found")!,
                    style: TextStyle(
                      fontSize: 14,
                      color: appStore.textSecondaryColor,
                    ),
                  ),
                ),
              ).visible(widget.mBookDetailsData.isActive!),
        16.height,
        Align(
          alignment: Alignment.topRight,
          child: AppButton(
            padding: EdgeInsets.only(top: 4, bottom: 4),
            color: PRIMARY_COLOR,
            textStyle: boldTextStyle(color: Colors.white, size: 14),
            text: keyString(context, "lbl_view_all")!,
            onTap: () {
              ReviewScreen(widget.mBookDetailsData.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            },
          ),
        ).paddingRight(16).visible(widget.mBookDetailsData.isActive! && widget.mBookDetailsData.comments!.length > 0)
      ],
    );
  }
}
