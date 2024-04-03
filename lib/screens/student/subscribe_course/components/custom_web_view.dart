import 'dart:async';

import 'package:flutter/material.dart';
import 'package:private_courses/components/my_navigate.dart';
import 'package:private_courses/screens/student/subscribe_course/components/status_payment.dart';
import 'package:private_courses/screens/student/subscribe_course/components/status_store_success.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String link;
  final String? name ;
  final bool isCart ;

  CustomWebView({required this.link, this.name, required this.isCart});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  bool error = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (navigationRequest) async {
            print("isCart" + widget.isCart.toString());
            print('*******************************************'+ navigationRequest.url.toString());
            if(navigationRequest.url.contains('success')){
              print('//////////////////////////////////' + navigationRequest.url.toString());
              print("isCart" + widget.isCart.toString());
              print('///////////////////////////////////' + "Redirect Success");
             widget.isCart==false? navigateTo(context, StatusPayment(isPayment: false,courseName: widget.name)):navigateTo(context, StatusPaymentSuccess());
              // Provider.of<GetLink>(context,listen: false).fetchGetList(link: navigationRequest.url).then(
              //         (value) => navigateTo(context,
              //             DoneOrder(
              //             msg: Provider.of<GetLink>(context,listen: false).list!.message.toString())));
              // print('sdsdsd ' + Provider.of<GetLink>(context,listen: false).list!.status.toString());
              return NavigationDecision.navigate;
            } else if(navigationRequest.url.contains('error')){
              print('///////////////////////////////////' + navigationRequest.url.toString());
              print('///////////////////////////////////' + "Redirect Error");
              navigateTo(context, StatusPayment(isPayment: true));

              // Provider.of<GetLink>(context,listen: false).fetchGetList(link: navigationRequest.url).then(
              //         (value) => navigateTo(context,
              //             DoneOrder(
              //             msg: Provider.of<GetLink>(context,listen: false).list!.message.toString())));
              // print('sdsdsd ' + Provider.of<GetLink>(context,listen: false).list!.status.toString());
              return NavigationDecision.navigate;
            }
            return NavigationDecision.navigate;
          },
          onProgress: (val) {
            print(val);
            print("----------------------------------------------------------------------- progress");

          },
          onPageFinished: (val) {
            print("----------------------------------------------------------------------- finished");

          },
          onWebResourceError: (val) {
            print("***********************************************************************************  onWebResourceError");
          },
          onPageStarted: (val) {
            print(val);
            print("----------------------------------------------------------------------- start");

          },
          initialUrl: widget.link,
        ),
      ),
    );
  }
}