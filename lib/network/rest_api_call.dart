import 'dart:convert';

import 'package:flutterapp/main.dart';
import 'package:flutterapp/model/AuthorListResponse.dart';
import 'package:flutterapp/model/DashboardResponse.dart';
import 'package:flutterapp/model/LoginResponse.dart';
import 'package:flutterapp/network/VietJetNetworkUtils.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import 'NetworkUtils.dart';

bool isSuccessful(int code) {
  return code >= 200 && code <= 206;
}

Future responseHandler(Response response, {req, isBookDetails = false, isPurchasedBook = false, isBookMarkBook = false}) async {
  if (isSuccessful(response.statusCode)) {
    if (response.body.contains("jwt_auth_no_auth_header")) {
      log("step1 here");
      // toastLong("Authorization header not found.");
      throw 'Authorization header not found.';
    } else if (response.body.contains("jwt_auth_invalid_token")) {
      // var password = getStringAsync(PASSWORD);
      var email = appStore.userEmail;

      if (email != "" && appStore.password != "") {
        var request = {"username": email, "password": appStore.password};
        await isNetworkAvailable().then((bool) async {
          if (bool) {
            await getLoginUserRestApi(request).then((res) async {
              LoginResponse response = LoginResponse.fromJson(res);

              await appStore.setToken(response.token!);
              await appStore.setLoggedIn(true);

              await appStore.setUserId(response.userId!);
              await appStore.setTokenExpired(true);

              // Call Existing api
              if (isBookDetails) {
                getBookDetailsRestApi(req);
              } else if (isPurchasedBook) {
                getPurchasedRestApi();
              } else if (isBookMarkBook) {
                getBookmarkRestApi();
              } else {
                openSignInScreen();
              }
            }).catchError((onError) {
              openSignInScreen();
            });
          } else {
            openSignInScreen();
          }
        });
      } else {
        openSignInScreen();
      }
    } else {
    if(response.body.isEmpty) {
      print("null value");
        return;
      }
      log('Body : ${response.body}');
      return jsonDecode(response.body);
    }
  } else {
    if (response.statusCode == 404) {
      if (response.body.contains("email_missing")) {
        throw 'Email Not Found';
      }
      if (response.body.contains("not_found")) {
        throw 'Current password is invalid';
      }
      if (response.body.contains("empty_wishlist")) {
        throw 'No Product Available';
      } else {
        throw 'Page Not Found';
      }
    } else if (response.statusCode == 406) {
      if (response.body.contains("code")) {
        throw response.body.contains("message");
      }
    } else if (response.statusCode == 405) {
      //toast("Error: Method Not Allowed");
      throw 'Method Not Allowed';
    } else if (response.statusCode == 500) {
      // toast("Error: Internal Server Error");
      throw 'Internal Server Error';
    } else if (response.statusCode == 501) {
      // toast("Error: Not Implemented");
      throw 'Not Implemented';
    } else if (response.statusCode == 403) {
      if (response.body.contains("jwt_auth")) {
        // toast("Invalid Credential.Try again");
        throw 'Invalid Credential.';
      } else {
        //toast("Error: Forbidden");
        throw 'Forbidden';
      }
    } else if (response.statusCode == 401) {
      
      // toast("Error: Unauthorized");
      throw 'Unauthorized';
    } else if (response.statusCode == 400) {
      return jsonDecode(response.body);
    } else if (await isJsonValid(response.body)) {
      // toast("Error: Invalid Json");
      throw 'Invalid Json';
    } else {
      throw 'Please try again later.';
    }
  }
}

openSignInScreen() async {
  // toastLong("Your token has been Expired. Please login again.");
  var pref = await getSharedPref();
  await appStore.setUserName('');
  await appStore.setToken('');
  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setDisplayName('');
  await appStore.setUserId(0);
  await appStore.setUserEmail('');
  await appStore.setAvatar('');
  await appStore.setLoggedIn(false);
  await appStore.setProfileImage('');
  // TODO Globle context here
  //SignInScreen().launch(context, isNewTask: true);
}

Future<bool> isJsonValid(json) async {
  try {
    // ignore: unnecessary_statements
    jsonDecode(json) as Map<String, dynamic>?;
    return true;
  } catch (e) {
    log(e.toString());
  }
  return false;
}

Future tokenValidate() async {
  return responseHandler(await APICall().tokenPostMethod("jwt-auth/v1/token/validate", requireToken: true));
}


Future getVietJetLoginUserRestApi(request) async {
  return responseHandler(await VietJetAPICall().postMethod("api/login", request));
}

Future getVietJetFileBook(id) async {
  return await VietJetAPICall().getMethodNew("api/books/$id/file", requireToken: true);
}


Future getVietJetBorrowBookRestAPI(id, status) async {
  if(status == "Ongoing") {
      return responseHandler(await VietJetAPICall().getMethodNew("api/borrows?BorrowerID=$id&Status=$status", requireToken: true));
  }
    return responseHandler(await VietJetAPICall().getMethodNew("api/borrows?BorrowerID=$id", requireToken: true));
}

Future postVietJetBorrowBookRequestRestAPI(request, note) async {
  return responseHandler(await VietJetAPICall().postMethodNew("api/borrow-requests?bookID=${request["bookID"]}&borrowType=${request["borrowType"]}",note, requireToken: true));
}

Future postVietJetReturnBook(id, note) async {
  return responseHandler(await VietJetAPICall().postMethodNew("api/borrows/$id/return",note, requireToken: true));
}

Future postVietJetExtendBook(id, note) async {
  return responseHandler(await VietJetAPICall().postMethodNew("api/extensions?borrowID=$id",note, requireToken: true));
}
Future postVietJetCancelRequest(id) async {
  var note = {};
  return responseHandler(await VietJetAPICall().postMethodNew("api/borrow-requests/$id/cancellation",note, requireToken: true));
}
Future postVietJetCancelRequestExtend(id) async {
  var note = {};
  return responseHandler(await VietJetAPICall().postMethodNew("api/extensions/$id/cancellation",note, requireToken: true));
}

Future getVietJetBorrowRequestRestAPI(id, status) async {
  if(status == "Pending"){
    return responseHandler(await VietJetAPICall().getMethodNew("api/borrow-requests?AccountID=$id&Status=$status", requireToken: true));
  }
  return responseHandler(await VietJetAPICall().getMethodNew("api/borrow-requests?AccountID=$id", requireToken: true));
}


Future getVietJetBorrowRequestExtendRestAPI() async {
  return responseHandler(await VietJetAPICall().getMethodNew("api/extensions?Status=Pending&Include=bookborrow.book", requireToken: true));
}

Future getLoginUserRestApi(request) async {
  return responseHandler(await APICall().postMethod("jwt-auth/v1/token", request));
}

Future getRegisterUserRestApi(request) async {
  return responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/customer/registration", request));
}

Future socialLoginApi(request) async {
  return responseHandler(await APICall().postMethod('iqonic-api/api/v1/customer/social_login', request));
}

Future getVietJetDashboardDataRestApi() async {
  return responseHandler(await VietJetAPICall().getMethod("api/books"));
}

Future getVietJetAuthorBookListRestApi(id) async {
  return responseHandler(await VietJetAPICall().getMethod("api/books?AuthorID=$id", requireToken: true));
}

Future getVietJetAllBookRestApi() async {
  return responseHandler(await VietJetAPICall().getMethod("api/books?OrderBy=publishYear%20desc"));
}

Future getVietJetAllBookRestApiByCategori(id) async {
  return responseHandler(await VietJetAPICall().getMethod("api/books?GenreID=$id"));
}

Future getPurchasedRestApi() async {
  return responseHandler(await APICall().getMethod("iqonic-api/api/v1/woocommerce/get-customer-orders", requireToken: true), isPurchasedBook: true);
}

Future getBookmarkRestApi() async {
  return responseHandler(await VietJetAPICall().getMethodNew("api/favorites", requireToken: true), isBookMarkBook: true);
}

Future getRemoveFromBookmarkRestApi(request) async {
  return responseHandler(await VietJetAPICall().deleteMethod('api/favorites/$request', requireToken: true));
}

Future getAddToBookmarkRestApi(request) async {
    var note = {};
  return responseHandler(await VietJetAPICall().postMethod('api/favorites?bookID=$request', note, requireToken: true));
}

Future getBookDetailsRestApi(id) async {
    return await responseHandler(await VietJetAPICall().getMethod("api/books/$id", requireToken: false), req: id, isBookDetails: true);
}


// Future<List<DashboardBookInfo>> getBookDetailsRestApi(id) async {
//   if (appStore.isLoggedIn) {
//     Iterable it = await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-product-details", id, requireToken: true), req: id, isBookDetails: true);
//     return it.map((e) => DashboardBookInfo.fromJson(e)).toList();
//   } else {
//     Iterable it = await responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-product-details", id, requireToken: false), req: id, isBookDetails: true);
//     return it.map((e) => DashboardBookInfo.fromJson(e)).toList();
//   }
// }

Future deleteOrderRestApi(request) async {
  return responseHandler(await APICall().getMethod("wc/v3/orders/$request"));
}

Future bookOrderRestApi(request) async {
  return responseHandler(await APICall().postMethod("wc/v3/orders", request, requireToken: true));
}

Future updateOrderRestApi(request, orderId) async {
  return await responseHandler(await APICall().postMethod("wc/v3/orders/$orderId", request, requireToken: true));
}

Future checkoutURLRestApi(request) async {
  return responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-checkout-url", request, requireToken: true));
}

Future bookReviewRestApi(id,request) async {
  return responseHandler(await VietJetAPICall().postMethod("api/comments?bookID=$id", request, requireToken: true));
}

// Future bookReviewRestApi(request) async {
//   return responseHandler(await APICall().postMethod("wc/v3/products/reviews", request, requireToken: true));
// }

Future getPaidBookFileListRestApi(request) async {
  if (appStore.isLoggedIn) {
    return responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-book-downloads", request, requireToken: true));
  } else {
    return responseHandler(await APICall().postMethod("iqonic-api/api/v1/woocommerce/get-book-downloads", request, requireToken: false));
  }
}

Future getAuthorListRestApi(page, perPage) async {
  return await responseHandler(await VietJetAPICall().getMethod("api/authors?PageNumber=$page&MaxPageSize=$perPage"));
}

/*
Future<List<AuthorListResponse>> getAuthorListRestApi(page, perPage) async {
  Iterable it = await (responseHandler(await APICall().getMethod(
      "iqonic-api/api/v1/woocommerce/get-vendors?&paged=$page&number=$perPage")));
  return it.map((e) => AuthorListResponse.fromJson(e)).toList();
}
*/

Future getCatListRestApi() async {
  return responseHandler(await VietJetAPICall().getMethod("api/genres/all"));
}

Future changePassword(request) async {
  return responseHandler(await APICall().postMethod('iqonic-api/api/v1/woocommerce/change-password', request, requireToken: true));
}

Future saveProfileImage(request) async {
  return responseHandler(await APICall().postMethod('iqonic-api/api/v1/customer/save-profile-image', request, requireToken: true));
}

Future getCustomer(id) async {
  return responseHandler(await APICall().getMethod('wc/v3/customers/$id'));
}

Future updateCustomer(id, request) async {
  return responseHandler(await APICall().postMethod('wc/v3/customers/$id', request));
}

Future forgetPassword(request) async {
  // return responseHandler(await APICall().postMethod('iqonic-api/api/v1/customer/forget-password', request));
}

Future getProductReviews(id) async {
  return responseHandler(await APICall().getMethod('wc/v1/products/$id/reviews'));
}

Future getSubCategories(parent) async {
  return responseHandler(await APICall().getMethod('wc/v3/products/categories?parent=$parent'));
}

Future getStripeClientSecret(request) async {
  return responseHandler(await APICall().postMethod('store/api/v1/woocommerce/get-stripe-client-secret', request, requireToken: true));
}

Future addToCartBook(request) async {
  return responseHandler(await APICall().postMethod('iqonic-api/api/v1/cart/add-cart', request, requireToken: true));
}

Future getCartBook() async {
  return responseHandler(await APICall().getMethod('iqonic-api/api/v1/cart/get-cart', requireToken: true));
}

Future deletefromCart(request) async {
  return responseHandler(await APICall().postMethod('iqonic-api/api/v1/cart/delete-cart/', request, requireToken: true));
}

Future clearCart() async {
  return responseHandler(await APICall().getMethod('iqonic-api/api/v1/cart/clear-cart', requireToken: true));
}

// /iqonic-api/api/v1/cart/delete-cart/
