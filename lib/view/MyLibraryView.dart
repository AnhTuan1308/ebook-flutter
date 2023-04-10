import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/free_book_item_component.dart';
import 'package:flutterapp/component/free_book_list_component.dart';
import 'package:flutterapp/component/purchase_book_list_component.dart';
import 'package:flutterapp/model/BookPurchaseResponse.dart';
import 'package:flutterapp/model/OfflineBookList.dart';
import 'package:flutterapp/model/BorrowBookResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/screens/my_cart_screen.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/config.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/database_helper.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutterapp/model/BorrowRequestResponse.dart';


import '../main.dart';

class MyLibraryView extends StatefulWidget {
  @override
  _MyLibraryViewState createState() => _MyLibraryViewState();
}

class _MyLibraryViewState extends State<MyLibraryView> {
  bool mIsLoading = false;
  // var mOrderList = <BookPurchaseResponse>[];
  // var mBookList = <BorrowBookData>[];
  int? _sliding = 0;
  // final dbHelper = DatabaseHelper.instance;
  // var listRequest = <BorrowRequestData>[];
  String status = "Pending";
  String statusbook = "Ongoing";
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await getMyBooks();
    await getBooksRequests();
    // await fetchData(context);
    // LiveStream().on(REFRESH_LIST, (p0) async {
    //   fetchData(context);
    //   await getBookmarkBooks();
    // });
    // LiveStream().on(REFRESH_LIBRARY_DATA, (p0) async {
      // await fetchData(context);
      // await await getMyBooks();
      // await getBooksRequests();
    // }
    // );
  }


  // Future<void> fetchData(context) async {
  //   List<OfflineBookList>? books = await (dbHelper.queryAllRows(appStore.userId));

  //   if (books!.isNotEmpty) {
  //     downloadedList.clear();
  //     downloadedList.addAll(books);

  //     setState(() {});
  //   } else {
  //     setState(() {
  //       downloadedList.clear();
  //     });
  //   }
  // }

  // /remove book
  // Future<void> remove(OfflineBookList task) async {
  //   Future.forEach(task.offlineBook, (OfflineBook e) async {
  //     if (File(e.filePath!).existsSync()) {
  //       await dbHelper.delete(e.filePath!);
  //       await File(e.filePath!).delete();
  //       await fetchData(context);
  //     } else {
  //       log("book not exits");
  //     }
  //   });
  // }

      Future<void> cancelRequest(id) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await postVietJetCancelRequest(id).then((res) async {
        setState(() {
           getBooksRequests();
          });
        }).catchError((onError) {
          log(onError.toString());
          setState(() {
           getBooksRequests();
          });
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }



        Future<void> cancelRequestExtend(id) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await postVietJetCancelRequestExtend(id).catchError((onError) {
          log(onError.toString());
          setState(() {
           getBooksRequestsExtend();
          });
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

    Future getBooksRequestsExtend() async {
    setState(() {
      mIsLoading = true;
    });

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getVietJetBorrowRequestExtendRestAPI().then((res) async {
        listExtendRequest.clear();
        ExtensionsResponse response = ExtensionsResponse.fromJson(res);
        listExtendRequest = response.data!;
          setState(() {
            mIsLoading = false;
          });
        }
        ).catchError((onError) {
          setState(() {
            mIsLoading = false;
          });
          log(onError.toString());
          if (getBoolAsync(TOKEN_EXPIRED) == true) {
            getMyBooks();
          } else {
            ErrorViewScreen(message: onError.toString()).launch(context);
          }
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }




      Future<void> returnBook(id , note) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        var notebook = {"note" : note};
        await postVietJetReturnBook(id,notebook).then((res) async {
          setState(() {
           getMyBooks();
          });
        }).catchError((onError) {
          setState(() {
           getMyBooks();
          });
          log(onError.toString());
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

        Future<void> extendBook(id , note) async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        var notebook = {"note" : note};
        print(notebook);
        await postVietJetExtendBook(id,notebook).then((res) async {
          setState(() {
            getBooksRequestsExtend();
          });
        }).catchError((onError) {
          log(onError.toString());
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        NoInternetConnection().launch(context);
      }
    });
  }

  Future getMyBooks() async {
    setState(() {
      mIsLoading = true;
    });

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getVietJetBorrowBookRestAPI(appStore.VietJetuserId, statusbook).then((res) async {
            mBookList.clear();
            BorrowBookResponse response = BorrowBookResponse.fromJson(res);
            mBookList = response.data!;
          setValue(LIBRARY_DATA, response);
          appStore.token;
          setState(() {
            mBookList;
            mIsLoading = false;
          });
        }
        ).catchError((onError) {
          setState(() {
            mIsLoading = false;
          });
          log(onError.toString());
          // if (getBoolAsync(TOKEN_EXPIRED) == true) {
          //   getMyBooks();
          // } else {
            ErrorViewScreen(message: onError.toString()).launch(context);
          // }
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }


  


    Future getBooksRequests() async {
    setState(() {
      mIsLoading = true;
    });

    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getVietJetBorrowRequestRestAPI(appStore.VietJetuserId, status).then((res) async {
            listRequest.clear();
            BorrowRequestResponse response = BorrowRequestResponse.fromJson(res);
            listRequest = response.data!;
          setState(() {
            mIsLoading = false;
          });
        }
        ).catchError((onError) {
          setState(() {
            mIsLoading = false;
          });
          log(onError.toString());
          // if (getBoolAsync(TOKEN_EXPIRED) == true) {
          //   getMyBooks();
          // } else {
            ErrorViewScreen(message: onError.toString()).launch(context);
          // }
        });
      } else {
        appStore.setLoading(false);
        NoInternetConnection().launch(context);
      }
    });
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: PRIMARY_COLOR,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    alignment: Alignment.center,
                    onPressed: () async {
                      MyCartScreen(isExtend: true,
                                    onCancelExtned: (id) {
                                      cancelRequestExtend(id);
                                        },
                        ).launch(context);

                    },
                    icon: Icon(Icons.change_circle, color: Colors.white,size: 33,),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 3),
                    decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: redColor),
                    child: Text(
                      listExtendRequest.length.toString(),
                      style: primaryTextStyle(size: 12, color: white),
                    ).paddingAll(4),
                  )
                ],
              ),
              onPressed: () async {
                if (appStore.isLoggedIn) {
                  MyCartScreen(isExtend: true, 
                        onCancelExtned: (id) {
                            cancelRequestExtend(id);
                        },
                        ).launch(context);
                }
              },
            ).visible(appStore.isLoggedIn)
            ,
          backgroundColor: appStore.scaffoldBackground,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: Container(
              width: context.width(),
              padding: EdgeInsets.all(16.0),
              child: CupertinoSlidingSegmentedControl(
                children: {
                  0: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      keyString(context, "lbl_my_books")!,
                      style: primaryTextStyle(color: _sliding == 0 ? PRIMARY_COLOR : appStore.appTextPrimaryColor),
                    ),
                  ),
                  1: InkWell(
                    child: Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      keyString(context, "lbl_my_request")!,
                      style: primaryTextStyle(color: _sliding == 1 ? PRIMARY_COLOR : appStore.appTextPrimaryColor),
                    ),
                  ),
                  ),
                },
                groupValue: _sliding,
                onValueChanged: (dynamic newValue) {
                  setState(() {
                    _sliding = newValue;
                  });
                },
              ),
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              (!mIsLoading)
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        if (_sliding == 0) PurchaseBookListComponent(mBookList: mBookList,
                        onReturnBook: (id, note) {
                          returnBook(id, note);
                        },
                        onExtendBook: (id, note) {
                          extendBook(id, note);
                        },
                        ),
                        if (_sliding == 1)
                          FreeBookListComponent(
                            listRequest: listRequest,
                            onCancelRequest: (id){
                              cancelRequest(id);
                            },
                          ),
                      ],
                    )
                  : appLoaderWidget.center().visible(mIsLoading),
            ],
          ),
        ),
      ),
    );
  }
}
