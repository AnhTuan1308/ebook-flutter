import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/view/MyLibraryView.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutterapp/model/BorrowBookResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/Colors.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';



class PurchaseBookItemComponent extends StatefulWidget {
  static String tag = '/PurchaseBookItemComponent';
  final BorrowBookData? bookData;
  final Color? bgColor;
  final Function? onReturnBook;
  final Function? onExtendBook;

  PurchaseBookItemComponent({this.bookData, this.bgColor,this.onReturnBook,this.onExtendBook});

  @override
  PurchaseBookItemComponentState createState() => PurchaseBookItemComponentState();
}

class PurchaseBookItemComponentState extends State<PurchaseBookItemComponent> {
  @override
  void initState() {
    super.initState();

  }


    Future showDialog1(BuildContext context, status) async {
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
                  keyString(context, "lbl_write_note")!,
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
                        if(status == "extend"){
                        widget.onExtendBook!.call(widget.bookData!.id, reviewCont.text);
                        }
                        else {
                         widget.onReturnBook!.call(widget.bookData!.id,reviewCont.text);
                        }
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


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {
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
            Text('${widget.bookData!.bookInfo!.title!.validate()}', style: primaryTextStyle(size: 16,weight: FontWeight.bold), maxLines: 1),
            8.height,
            Text(
            reviewConvertDate(widget.bookData!.returnDate),
            textAlign: TextAlign.right,
            style: TextStyle(color: appStore.textSecondaryColor, fontSize: 15, fontWeight: FontWeight.normal, height: 1),
          ),
          10.height,
          Row(
            children: [
              Container(
                width: 60,
                height: 30,
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
            ],
          ) // priceWidget(currency: getStringAsync(CURRENCY_SYMBOL), price: widget.bookData!.total.validate()),
          ],

        ).expand(),
         Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: boxDecorationDefault(shape: BoxShape.rectangle, color: Colors.white),
                child: DropdownButton2(
                  customButton: Icon(Icons.more_horiz),
      items: [
         ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                  value: item,
                  child: MenuItems.buildItem(item),
                ),
              ),
              
      ],
            onChanged: (value) {
                  switch (value as MenuItem) {
                  case MenuItems.returnbook:
                  showDialog1(context,"return");
                  break;
                  case MenuItems.extend:
                  showDialog1(context,"extend");
                      break;
                  }
            },
              dropdownStyleData: DropdownStyleData(
              
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              elevation: 8,
              offset: const Offset(-85, 0),

            ),
    )
              ).center(widthFactor: 2.5,heightFactor: 2.5),
      ],
    ).paddingRight(16);
  }


}


class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}
class MenuItems {
  static const List<MenuItem> firstItems = [returnbook, extend];

  static const returnbook = MenuItem(text: 'Return', icon: Icons.delete);
  static const extend = MenuItem(text: 'Extend', icon: Icons.change_circle);

  static Widget buildItem(MenuItem item) {
    return Container(
      child: Row(
        children: [
          Icon(item.icon, color: Colors.black, size: 22),
          const SizedBox(
            width: 10,
          ),
          Text(
            item.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }


}