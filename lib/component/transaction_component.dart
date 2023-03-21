import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/model/BorrowBookResponse.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class TransactionComponent extends StatefulWidget {
  static String tag = '/TransactionComponent';
  final BorrowBookData? bookData;
  final Color? bgColor;
  TransactionComponent({this.bookData, this.bgColor});

  @override
  TransactionComponentState createState() => TransactionComponentState();
}

class TransactionComponentState extends State<TransactionComponent> {
  String dateFormate = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // widget.transactionListData!.lineItems!.forEach((element) {
    //   lineItems = element;
    // });
    dateFormate = DateFormat("yMMMd").format(DateTime.parse(widget.bookData!.borrowDate!.toString()));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
        Color color = Colors.cyan.shade600;
    if(widget.bookData!.status == "Completed"){
        color = Colors.green;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(120), topRight: Radius.circular(120)),
                backgroundColor: widget.bgColor!,
              ),
              height: 40,
              width: 80,
            ),
            Container(
              height: 80,
              width: 60,
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(book_radius)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: bookLoaderWidget,
                ),
                height: 80,
                width: 60,
                imageUrl: widget.bookData!.bookInfo!.thumbnailUrl!.toString(),
                fit: BoxFit.fill,
              ),
              margin: EdgeInsets.only(bottom: 16),
            ),
          ],
        ),
        8.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.bookData!.bookInfo!.title!.validate()}', style: primaryTextStyle(size: 20,weight: FontWeight.bold),overflow: TextOverflow.ellipsis, maxLines: 1),
            8.height,
            Text(
            reviewConvertDate(widget.bookData!.returnDate),
            textAlign: TextAlign.right,
            style: TextStyle(color: appStore.textSecondaryColor, fontSize: 15, fontWeight: FontWeight.normal, height: 1),
          ),
          8.height,
          Row(
            children: [
              10.width,
              Container(
                width: 60,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: PRIMARY_COLOR, borderRadius: BorderRadius.circular(30)),
                child: Text(
                    '${widget.bookData!.borrowType}',
                        style: primaryTextStyle(color: white,),maxLines: 1
                    ),
                            ).visible(widget.bookData!.borrowType == "Digital"),
              20.width,
              Container(
                width: 60,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.amber[800], borderRadius: BorderRadius.circular(30)),
                child: Text(
                    '${widget.bookData!.borrowType}',
                        style: primaryTextStyle(color: white,),maxLines: 1
                    ),
              ).visible(widget.bookData!.borrowType == "Physical"),
              20.width,
              Container(
                width: 90,
                height: 35,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
                child: Text(
                    '${widget.bookData!.status}',
                        style: primaryTextStyle(color: white,),maxLines: 1
                    ),
              ),
            ],
          )

          ],
        ).expand(),
      ],
    ).paddingRight(16);
  }
}
