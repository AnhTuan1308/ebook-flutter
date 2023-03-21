import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/transaction_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/model/BorrowBookResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NoInternetConnection.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static String tag = '/TransactionHistoryScreen';

  @override
  TransactionHistoryScreenState createState() => TransactionHistoryScreenState();
}

class TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  var mBookList = <BorrowBookData>[];
  String status = "";
  @override
  void initState() {
    super.initState();
    init();

  }

  init() async {
    await getTransactionList();
  }

  Future getTransactionList() async {
    setState(() {
      appStore.setLoading(true);
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getVietJetBorrowBookRestAPI(appStore.VietJetuserId,status).then((res) async {
             mBookList.clear();
            BorrowBookResponse response = BorrowBookResponse.fromJson(res);
            mBookList = response.data!;
            print("");
            appStore.setLoading(false);
            setState(() {
        });
        }).catchError((onError) {
            appStore.setLoading(false);
          log(onError.toString());
          if (appStore.isTokenExpired) {
            getTransactionList();
          } else {
            appStore.setLoading(false);
            ErrorViewScreen(message: onError.toString()).launch(context);
          }
        });
      } else {
        appStore.setLoading(false);
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
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context, title: keyString(context, 'lbl_borrowed_history')),
      body: Observer(builder: (context) {
        return Stack(
          children: [
            ListView.builder(
                itemCount: mBookList.length,
                padding: EdgeInsets.all(16),
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  Color bgColor = bookBackgroundColor[index % bookBackgroundColor.length];
                  BorrowBookData mData = mBookList[index];
                  return TransactionComponent(bookData: mData,bgColor : bgColor).paddingBottom(16);
                }),
          ],
        );
      }),
    );
  }
}
