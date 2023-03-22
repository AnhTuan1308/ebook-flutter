import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/component/author_list_component.dart';
import 'package:flutterapp/component/department_list_component.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/model/DepartmentResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/utils/SelectedAnimationType.dart';
import 'package:flutterapp/utils/app_widget.dart';
import 'package:flutterapp/utils/constant.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'NoInternetConnection.dart';
import 'author_details.dart';
import 'error_view_screeen.dart';

class DepartmentListScreen extends StatefulWidget {
  static var tag = "/DepartmentListScreen";
  @override
  _DepartmentListScreenState createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  List<DepartmentData> mdepartmentData = [];
    bool mIsLoading = false;

  @override
  void initState() {
    super.initState();
    getDepartmentList();
  }





  ///get author list api call
  Future getDepartmentList() async {
    setState(() {
      mIsLoading = true;
    });
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        await getDepartmentListRestApi().then((res) async {
          appStore.setLoading(false);
          DepartmentResponse response = DepartmentResponse.fromJson(res);
          mdepartmentData = response.data!;
                    setState(() {
            mIsLoading = false;
          });
        }).catchError((onError) {
          appStore.setLoading(false);
          ErrorViewScreen(message: onError.toString()).launch(context);
        });
      } else {
        appStore.setLoading(false);

        NoInternetConnection().launch(context);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget main = SingleChildScrollView(
              primary: false,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    Divider(color: Colors.grey),
                    AnimationLimiter(child: ListView.builder(
                        padding: EdgeInsets.all(8),
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                      itemBuilder:  (context, index) {
                        Color bgColor = authorBorderColor[index % authorBorderColor.length];
                        return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: 600.milliseconds,
                            columnCount: 1,
                            child: SelectedAnimationType( 
                              child: DepartmentListComponent(bgColor: bgColor,departmentdetail: mdepartmentData[index],)
                                ),
                          );
                      },
                        itemCount: mdepartmentData.length.toInt(),
                        shrinkWrap: true,
                      )
                      )
                  ],
                ),
              ),
            );
    return Scaffold(
      backgroundColor: appStore.scaffoldBackground,
      appBar: appBar(context,showTitle: true, title: keyString(context, "lbl_department")),
      body: Stack(
          children: [
              (!mIsLoading) ? main : appLoaderWidget.center().visible(mIsLoading),
          ],
        ),
    );
  }
}
