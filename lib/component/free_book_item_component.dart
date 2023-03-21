import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/OfflineBookList.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutterapp/model/BorrowRequestResponse.dart';
import 'package:flutterapp/app_localizations.dart';


class FreeBookItemComponent extends StatefulWidget {
  static String tag = '/FreeBookItemComponent';
  final BorrowRequestData? requestDetail;
  final Color? bgColor;
  final Function? onCancelRequest;
  final bool? isHistory;
  final bool? isExtend;
  FreeBookItemComponent({this.requestDetail, this.bgColor,this.onCancelRequest,this.isHistory = false,this.isExtend});

  @override
  FreeBookItemComponentState createState() => FreeBookItemComponentState();
}

class FreeBookItemComponentState extends State<FreeBookItemComponent> {
  @override
  void initState() {
    super.initState();
    // init();
  }

  // init() async {
  //   //
  // }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Color color = Colors.grey;
    if(widget.requestDetail!.status == "Approved"){
        color = Colors.green;
    }else if(widget.requestDetail!.status == "Rejected" || widget.requestDetail!.status == "Canceled"){
        color = Colors.red;
    }
    else if(widget.requestDetail!.status == "Ongoing" ){
        color = Colors.blue;
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
                imageUrl: widget.requestDetail!.bookInfo!.thumbnailUrl!.validate(),
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
            Container(
              width: 307,
              child: Text('${widget.requestDetail!.bookInfo!.title!.validate()}', style: primaryTextStyle(size: 20,weight: FontWeight.bold), overflow: TextOverflow.ellipsis,maxLines: 1)
              ),
              8.height,
              Text(
            reviewConvertDate(widget.requestDetail!.createdAt),
            textAlign: TextAlign.right,
            style: TextStyle(color: appStore.textSecondaryColor, fontSize: 15, fontWeight: FontWeight.normal, height: 1),
          ),
            8.height,
            Row(
              children: [
                8.height,
                Container(
                    width: 70,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
                    child: Text(
                        '${widget.requestDetail!.status}',
                            style: primaryTextStyle(color: white,),maxLines: 1
                        ),
                  ),
                32.width,
              ],
            ),
          ],
        ),
          InkWell(
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.delete, color: Colors.red),
              ),
              onTap: () {
                widget.onCancelRequest!.call(widget.requestDetail!.id);
              },
            ).center(heightFactor: 2.5).visible(widget.requestDetail!.status == "Pending").visible(!widget.isHistory!),
                      InkWell(
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: boxDecorationDefault(shape: BoxShape.circle, color: Colors.white),
                child: Icon(Icons.delete, color: Colors.red),
              ),
              onTap: () {
                widget.onCancelRequest!.call(widget.requestDetail!.id);
              },
            ).center(heightFactor: 2.5).visible(widget.isExtend!),
      ],
    ).paddingAll(10);
  }
}
