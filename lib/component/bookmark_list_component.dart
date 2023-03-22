import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/BookmarkResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class BookMarkListComponent extends StatefulWidget {
  static String tag = '/BookmarkBookList';
  final DashboardBookInfo? bookData;
  final Color? borderColor;
  final Function? onRemoveBookmark;
  BookMarkListComponent(this.bookData, {this.onRemoveBookmark,this.borderColor});

  @override
  BookMarkListComponentState createState() => BookMarkListComponentState();
}

class BookMarkListComponentState extends State<BookMarkListComponent> {
  bool mIsFreeBook = false;
  bool mIsSalePrice = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // getBookPrice();
  }

  // Future getBookPrice() async {
  //   if (widget.bookData!.price == "" && widget.bookData!.salePrice == "" && widget.bookData!.regularPrice == "") {
  //   if ((widget.bookData!.price.toString().isEmpty || widget.bookData!.price.toString() == "0") &&
  //           (widget.bookData!.salePrice.toString().isEmpty || widget.bookData!.salePrice.toString() == "0") &&
  //           widget.bookData!.regularPrice.toString().isEmpty ||
  //       widget.bookData!.regularPrice.toString() == "0") {
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
        Container(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.bookData!.title.validate(), style: boldTextStyle(size: 16,weight: FontWeight.bold),maxLines: 1,),
              8.height,
              Container(
                      width: 80,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(30)),
                      child: Text(
                          "${widget.bookData!.authors![0].fullName.toString()}",
                              style: primaryTextStyle(color: white,),maxLines: 1,textAlign: TextAlign.center,
                          ),
              ),
              10.height,
              Text("${widget.bookData!.publishYear.toString()}", style: boldTextStyle(size: 14,weight: FontWeight.bold),maxLines: 1,).paddingLeft(5),

            ],
          ),
        ),
                Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.delete, color: Colors.red),
              ),
              onTap: () {
                widget.onRemoveBookmark!.call(widget.bookData!.id);
                setState(() {

                });
              },
            ).center(heightFactor: 2.5,widthFactor: 2.5),
          ],
        ),
      ],
    );
  }
}
