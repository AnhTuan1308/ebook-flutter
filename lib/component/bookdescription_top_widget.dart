import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/adapterView/DownloadFilesView.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/BorrowBookResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/screens/BookDetails.dart';
import 'package:flutterapp/screens/dashboard_screen.dart';
import 'package:flutterapp/screens/view_file_pdf.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'dart:math' as math;
import 'package:nb_utils/nb_utils.dart';
import 'package:flutterapp/component/all_review_component.dart';
import 'package:flutterapp/screens/sign_in_screen.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/network/rest_api_call.dart';



import '../main.dart';

// ignore: must_be_immutable
class BookDescriptionTopWidget extends StatefulWidget {
  static String tag = '/BookDescriptionTopWidget';
  DashboardBookInfo? mBookDetailsData;
  final Color? bgColor;
  double? scrollPosition;
  bool? mIsFreeBook = false;
  List<DownloadModel>? mDownloadPaidFileArray;
  String? mBookId;
  Function? onUpdate;
  Function? onAddToCartUpdate;
  Function? onUpdateBuyNow;
  String status = "";
  BorrowBookData? bookData;

  BookDescriptionTopWidget(
      {this.mBookDetailsData, this.bgColor, this.scrollPosition, this.mIsFreeBook, this.mDownloadPaidFileArray, this.mBookId, this.onUpdate, this.onAddToCartUpdate, this.onUpdateBuyNow});

  @override
  BookDescriptionTopWidgetState createState() => BookDescriptionTopWidgetState();
}

class BookDescriptionTopWidgetState extends State<BookDescriptionTopWidget> {
    bool isborrow = false;
    bool isrequest = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    mBookList.forEach((element) {
      if(element.bookID == widget.mBookId.toInt()){
       isborrow = true;
       widget.bookData = element;
      }
    });
        listRequest.forEach((element) {
      if(element.bookID == widget.mBookId.toInt()){
       isrequest = true;
      }
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // void getPaidFileList(context) {
  //   if (widget.mDownloadPaidFileArray!.length > 0) {
  //     _settingModalBottomSheet(context, widget.mDownloadPaidFileArray!);
  //   } else {
  //     widget.onUpdate!.call();
  //   }
  // }

  void _settingModalBottomSheet(context, List<DownloadModel> viewFiles, {isSampleFile = false}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          primary: false,
          child: Container(
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), backgroundColor: appStore.editTextBackColor!),
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: spacing_standard_new,
                      ),
                      padding: EdgeInsets.only(right: spacing_standard),
                      child: Text(
                        keyString(context, "lbl_all_files")!,
                        style: boldTextStyle(size: 20, color: appStore.appTextPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      child: Icon(Icons.close, color: appStore.iconColor, size: 30),
                      onTap: () => {Navigator.of(context).pop()},
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: spacing_standard_new),
                  height: 2,
                  color: lightGrayColor,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return DownloadFilesView(
                        widget.mBookId!,
                        viewFiles[index],
                        widget.mBookDetailsData!.thumbnailUrl.validate(),
                        widget.mBookDetailsData!.title.validate(),
                        isSampleFile: isSampleFile,
                      );
                    },
                    itemCount: viewFiles.length,
                    shrinkWrap: true,
                  ),
                ).visible(viewFiles.isNotEmpty),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.mBookDetailsData!.title!.isNotEmpty
        ? LayoutBuilder(
            builder: (context, c) {
              final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
              final deltaExtent = settings!.maxExtent - settings.minExtent;
              final t = (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent).clamp(0.0, 1.0);
              final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
              const fadeEnd = 1.0;
              final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 325,
                    child: Opacity(
                      opacity: 1 - opacity,
                      child: Text(widget.mBookDetailsData!.title.validate(), style: boldTextStyle(),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    ).center(),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          decoration: boxDecorationWithRoundedCorners(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                            backgroundColor: widget.bgColor ?? Colors.grey,
                          ),
                          height: 70,
                          width: 140,
                        ),
                        Container(
                          height: dashboard_book_height,
                          width: dashboard_book_width,
                          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(
                              child: bookLoaderWidget,
                            ),
                            width: 100,
                            height: dashboard_book_height,
                            imageUrl: widget.mBookDetailsData!.thumbnailUrl.validate(),
                            fit: BoxFit.fill,
                          ),
                          margin: EdgeInsets.only(bottom: 16),
                        ),
                      ],
                    ).center().visible(widget.mBookDetailsData!.thumbnailUrl!.isNotEmpty),
                  ),
                  Transform.translate(
                    offset: widget.scrollPosition! <= 230 ? Offset(0, 24) : Offset(0, context.height() * 0.050),
                    child: (widget.mBookDetailsData!.isPurchased! || widget.mIsFreeBook!)
                        ? AppButton(
                            color: PRIMARY_COLOR,
                            shapeBorder: RoundedRectangleBorder(borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                            width: (widget.scrollPosition! >= 230) ? context.width() : context.width() / 1.5,
                            child: Text(
                              keyString(context, "lbl_view_files")!,
                              style: primaryTextStyle(color: white),
                              textAlign: TextAlign.center,
                            ),
                            // onTap: () {
                            //   getPaidFileList(context);
                            // },
                          )
                        : Container(
                          margin: EdgeInsets.only(top: 10),
                            width: (widget.scrollPosition! >= 230) ? context.width() : context.width() / 1.3,
                            decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: kToolbarHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                                  child: Text(
                                    myCartList.any((e) => e.proId.toString() == widget.mBookId) ? keyString(context, 'lbl_my_library')! : keyString(context, 'lbl_borrow_digital_book')!,
                                    style: primaryTextStyle(color: white),
                                    textAlign: TextAlign.center,
                                  ),
                                ).onTap(() {
                                  widget.status ="Digital";
                                  showDialog1(context, widget.status);
                                  print(context);
                                }).expand().visible(widget.mBookDetailsData!.availability!.digital! && !isborrow),
                                Container(
                                  height: 28,
                                  child: VerticalDivider(color: Colors.white, thickness: 1.5),
                                )
                                .visible(widget.mBookDetailsData!.availability!.digital! && widget.mBookDetailsData!.availability!.physical!)
                                ,
                                Container(
                                  height: kToolbarHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                                  child: Text(
                                    keyString(context, 'lbl_borrow_physical_book')!,
                                    style: primaryTextStyle(color: white),
                                  ),
                                ).onTap(() {
                                  widget.status ="Physical";
                                  showDialog1(context, widget.status);
                                  getMyBooks();
                                  print(context);
                                }).expand()
                                .visible(widget.mBookDetailsData!.availability!.physical! && !isrequest)
                                ,
                                Container(
                                  height: kToolbarHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                                  child: Text(
                                    keyString(context, 'lbl_out_of_stock')!,
                                    style: primaryTextStyle(color: white),
                                  ),
                                ).onTap(() {
                                }).expand().visible(!widget.mBookDetailsData!.availability!.digital! && !widget.mBookDetailsData!.availability!.physical!),
                              Container(
                                  height: kToolbarHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                                  child: Text(
                                    keyString(context, 'lbl_book_borrowed')!,
                                    style: primaryTextStyle(color: white),
                                  ),
                                ).expand().visible(isborrow)
                                ,
                                                              Container(
                                  height: kToolbarHeight,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.grey, borderRadius: (widget.scrollPosition! >= 230) ? BorderRadius.zero : BorderRadius.circular(30)),
                                  child: Text(
                                    keyString(context, 'lbl_book_process')!,
                                    style: primaryTextStyle(color: white),
                                  ),
                                ).expand().visible(isrequest),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          )
        : Container();
  }

  Future showDialog1(BuildContext context, String status) async {
    // var ratings = 0.0;
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
                  keyString(context, "lbl_write_some_note")!,
                  style: TextStyle(fontSize: mobile_font_size_large, color: appStore.appTextPrimaryColor, fontWeight: FontWeight.bold),
                ),
                8.height,
                TextFormField(
                  style: TextStyle(fontSize: 18, color: appStore.appTextPrimaryColor),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(26, 18, 4, 18),
                    hintText: keyString(context, "lbl_write_note"),
                    filled: true,
                    hintStyle: secondaryTextStyle(color: appStore.textSecondaryColor),
                    fillColor: appStore.editTextBackColor,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
                    ),
                    // focusedBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(10),
                    //   borderSide: BorderSide(color: appStore.editTextBackColor!, width: 0.0),
                    // ),
                  ),
                  controller: reviewCont,
                  maxLines: 3,
                  minLines: 1,
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
                        postBorrowBookRequestApi(reviewCont.text);
                        // hideKeyboard(context);
                         Navigator.pop(context);
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

  Future postBorrowBookRequestApi(note) async { 
    if (!appStore.isLoggedIn) {
      SignInScreen().launch(context);
      return;
    }
    String firstName = appStore.firstName + " " + appStore.lastName;
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        var request = {"bookID" :"${widget.mBookId}", "borrowType":"${widget.status}"};
        var noterequest = {"note" : "${note}"};
        await postVietJetBorrowBookRequestRestAPI(request,noterequest).then((res) async {
          LiveStream().emit(REFRESH_REVIEW_LIST);
          appStore.setReview(true);
          finish(context);
          setState(() {
            getMyRequests();
            getMyBooks();
          });
        }
        ).catchError((onError) {
          ErrorViewScreen(
            message: onError.toString(),
          ).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }


}




