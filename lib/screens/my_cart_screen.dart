import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/PaymentSheetComponent.dart';
import 'package:flutterapp/component/cart_component.dart';
import 'package:flutterapp/component/free_book_list_component.dart';
import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/BorrowRequestResponse.dart';
import 'package:flutterapp/model/LineItemModel.dart';
import 'package:flutterapp/model/MyCartResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/WebViewScreen.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NoInternetConnection.dart';
import 'book_description_screen.dart';
import 'sign_in_screen.dart';

class MyCartScreen extends StatefulWidget {
  final bool? isExtend;
  final bool? isHistory;
  Function? onCancelExtned;
  MyCartScreen({this.isExtend = false,this.isHistory = true,this.onCancelExtned});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  bool mIsLoading = false;
  var listRequest = <BorrowRequestData>[];
  var listRequestEx = <BorrowRequestData>[];
  var status = "";

//  late NavigationController controller;

  @override
  void initState() {
    init();
    super.initState();
    
  }

  Future<void> init() async {
    await getCartItem();
    await getExtendItem();
  }

  Future<void> getCartItem() async {
    setState(() {
        mIsLoading = true;
    });
  
    await getVietJetBorrowRequestRestAPI(appStore.VietJetuserId, status).then((res) {
            BorrowRequestResponse response = BorrowRequestResponse.fromJson(res);
            listRequest = response.data!;
              setState(() {

                mIsLoading = false;
          });
    }).catchError((onError) {
        setState(() {
            mIsLoading = false;
          });
    });
  }

    Future<void> getExtendItem() async {

    listRequestEx.clear();
    var count = 0;
    listExtendRequest.forEach((element)  {
          listRequestEx.add(element.request!);
          listRequestEx[count].createdAt = element.createdAt;
          listRequestEx[count].id = element.id;
          listRequestEx[count].status = element.status;
          count++;
    });
  }

  // Future webViewPayment(BuildContext context) async {
  //   placeOrder(context);
  // }

  ///WebView API
  // Future placeOrder(BuildContext context) async {
  //   myCartList.forEach((element) {
  //     var lineItem = LineItemsRequest();
  //     lineItem.product_id = element.proId;
  //     lineItem.quantity = element.quantity;
  //     lineItems.add(lineItem);

  //     setState(() {});
  //   });

  //   var request = {
  //     'currency': getStringAsync(CURRENCY_NAME),
  //     'customer_id': appStore.userId,
  //     'payment_method': "",
  //     'set_paid': false,
  //     'status': "pending",
  //     'transaction_id': "",
  //     'line_items': lineItems,
  //   };

  //   log(request);
  //   setState(() {
  //     mWebViewPayment = true;
  //   });
  //   await isNetworkAvailable().then(
  //     (bool) async {
  //       if (bool) {
  //         await bookOrderRestApi(request).then((response) {
  //           if (!mounted) return;
  //           processPaymentApi(response['id'], context);
  //         }).catchError((error) {
  //           appStore.setLoading(false);
  //           toast(error.toString());
  //         });
  //       } else {
  //         NoInternetConnection().launch(context);
  //       }
  //     },
  //   );
  // }

  // processPaymentApi(var mOrderId, BuildContext context) async {
  //   var request = {"order_id": mOrderId};
  //   checkoutURLRestApi(request).then((res) async {
  //     if (!mounted) return;
  //     setState(() {
  //       mWebViewPayment = false;
  //     });
  //     Map? results = await WebViewScreen(res['checkout_url'], "Payment", orderId: mOrderId.toString()).launch(context);
  //     if (results != null && results.containsKey('orderCompleted')) {
  //       setState(() {
  //         mWebViewPayment = true;
  //       });
  //       myCartList.forEach((element) {
  //         bookId = element.proId.toString();
  //       });
  //       appStore.removeCartCount(bookId);
  //       clearCart().then((response) {
  //         myCartList.clear();
  //         LiveStream().emit(REFRESH_LIST);
  //         mWebViewPayment = false;
  //       }).catchError((error) {
  //         mWebViewPayment = false;
  //         toast(error.toString());
  //       });
  //     } else {
  //       deleteOrder(mOrderId).then((value) => {log(value)}).catchError((error) {
  //         log(error);
  //       });
  //     }
  //   }).catchError((error) {
  //     log(error);
  //   });
  // }

  ///delete order api call
  // Future deleteOrder(orderId) async {
  //   if (!appStore.isLoggedIn) {
  //     SignInScreen().launch(context);
  //     return;
  //   }
  //   await isNetworkAvailable().then(
  //     (bool) async {
  //       if (bool) {
  //         await deleteOrderRestApi(orderId).then((res) async {}).catchError((onError) {
  //           ErrorViewScreen(
  //             message: onError.toString(),
  //           ).launch(context);
  //         });
  //       } else {
  //         NoInternetConnection().launch(context);
  //       }
  //     },
  //   );
  // }

  // Future<void> pay(BuildContext context) async {
  //   if (getStringAsync(PAYMENT_METHOD) != "native") {
  //     webViewPayment(context);
  //   } else {
  //     await showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext _context) {
  //         return PaymentSheetComponent(
  //           total.toString(),
  //           context,
  //           myCartList: myCartList,
  //           onCall: () {
  //             setState(() {
  //               getCartItem();
  //               finish(context);
  //             });
  //           },
  //         );
  //       },
  //     );
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    Widget mainView = ListView(
            shrinkWrap: true,
            children: [
              (widget.isExtend!) ?
              FreeBookListComponent(listRequest: listRequestEx,isExtend: true,onCancelRequest: (id) {
                widget.onCancelExtned!.call(id);
                setState(() {
                });
              },)
              :
              FreeBookListComponent(listRequest: listRequest,isHistory: true,)
            ],
          );
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: appStore.appBarColor,
        elevation: 0,
        title: Row(
          children: [
            (widget.isExtend!) ? 
            Text(keyString(context, 'lbl_request_extend')!, style: boldTextStyle(size: 20)) 
            :
            Text(keyString(context, 'lbl_request_library')!, style: boldTextStyle(size: 20)),
          ],
        ),
      ),
      body: Stack(
        children: [
          (!mIsLoading) ? mainView : appLoaderWidget.center().visible(mIsLoading),
        ],
      ),
    );
  }
}
