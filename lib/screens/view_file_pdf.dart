import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutterapp/model/BorrowBookResponse.dart';
import 'package:flutterapp/network/rest_api_call.dart';
import 'package:flutterapp/screens/NoInternetConnection.dart';
import 'package:flutterapp/screens/error_view_screeen.dart';
import 'package:flutterapp/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterapp/app_localizations.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import 'package:flip_widget/flip_widget.dart';




class ViewFilePDF extends StatefulWidget {
  final BorrowBookData? bookData;


  ViewFilePDF({this.bookData});

  @override
  State<ViewFilePDF> createState() => _ViewFilePDFState();
}

class _ViewFilePDFState extends State<ViewFilePDF> {

  late String _pdfPath = "";
  late PDFViewController _pdfViewController;
  @override
  void initState() {
    super.initState();
    // downloadFileFromServer();
  }


    downloadFileFromServer() async {
    await isNetworkAvailable().then((bool) async {
      if (bool) {
        appStore.setLoading(true);
        await getVietJetFileBook(widget.bookData!.bookID).then((res) async {
        final bytes = res.bodyBytes;
        print(bytes);
        final directory = await getExternalStorageDirectory();
        final pdfPath = '${directory!.path}/${widget.bookData!.bookInfo!.title}.pdf';
        final file = File("/storage/emulated/0/Android/data/com.iqonic.bookkart/files/2_Higher Engineering Mathematics.aes");
        // await file.writeAsBytes(bytes);
        final encryptPath = await encryptFile(pdfPath);
        print(pdfPath);
        print(encryptPath);
        final encrypt = File(encryptPath);
        // await encrypt.writeAsBytes(bytes);
        await file.delete();
        }).catchError((onError) {
          appStore.setLoading(false);
          log(onError.toString());
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookData!.bookInfo!.title!, style: primaryTextStyle(size: 20)).center(widthFactor: 1.2),
      ),
      body: PDFView(
              filePath: "/storage/emulated/0/Android/data/com.iqonic.bookkart/files/2_Higher Engineering Mathematics.pdf",
              autoSpacing: true,
              enableSwipe: true,
              pageSnap: true,
              swipeHorizontal: true,
              onViewCreated: (PDFViewController vc) {
                _pdfViewController = vc;
              },
              onPageChanged: (page, total) => {
                print('page change: $page/$total'),
                appStore.setPage(page)
              },
              defaultPage: appStore.page!,
            ),
    );
  }
}
