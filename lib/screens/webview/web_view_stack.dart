import 'package:doctorfriend/components/callback.dart';
import 'package:doctorfriend/data/constants.dart';
import 'package:doctorfriend/services/traslation/traslation.dart';
import 'package:doctorfriend/utils/app_routes_util.dart';
import 'package:doctorfriend/utils/tools_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

String script = "window.fromFlutter('Hello ReactJS')";

class WebViewStack extends StatefulWidget {
  final bool isSite;

  const WebViewStack({
    super.key,
    this.isSite = true,
  }); // Modify

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;

  late final WebViewController _controller;
  final cookieManager = WebViewCookieManager();
  FocusNode myFocusNode = FocusNode();
  late Map<String, dynamic> _traslation;

  bool _error = false;
  String _errorString = "";

  Future<void> requestCameraPermission() async {
    final status = await Permission.microphone.request();
    // print(status);
    if (status == PermissionStatus.granted) {
      // Permission granted.
    } else if (status == PermissionStatus.denied) {
      // Permission denied.
    } else if (status == PermissionStatus.permanentlyDenied) {
      // Permission permanently denied.
      // openAppSettings();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _traslation = Translations.of(context).translate('weview');
  }

  @override
  void initState() {
    super.initState();
    final String url = widget.isSite ? "$site/" : "$site/platform/df";

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (WebViewPermissionRequest request) {
        request.platform.grant();
        request.grant();
      },
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() => loadingPercentage = 0),
          onProgress: (progress) =>
              setState(() => loadingPercentage = progress),
          onWebResourceError: (error) {
            final errorType = error.errorType;
            if (errorType == WebResourceErrorType.badUrl ||
                errorType == WebResourceErrorType.timeout ||
                errorType == WebResourceErrorType.hostLookup) {
              setState(() {
                _error = true;
                _errorString = error.description;
              });
            }
          },
          onNavigationRequest: (request) async {
            if (request.url.contains('br.com.doctorfriend.profissional')) {
              context.push(AppRoutesUtil.login);
              return NavigationDecision.prevent;
            }

            if (request.url.contains('apps.apple.com/us/app/doctor-friend')) {
              context.push(AppRoutesUtil.login);
              return NavigationDecision.prevent;
            }

            if (!request.url.contains('doctorfriend.com.br')) {
              ToolsUtil.launchURL(context, urlString: request.url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onPageFinished: (url) async {
            setState(
              () {
                loadingPercentage = 100;
                _controller.runJavaScript(script);

                // _controller.runJavaScript(Javascript.functions());
              },
            );
            await requestCameraPermission();
            // await _controller.runJavaScript(
            //     "navigator.mediaDevices.getUserMedia({ audio: true });");
            // _controller.setMediaPlaybackRequiresUserGesture(false);
          },
        ),
      )
      //     onMessageReceived: _setButtonAmount)
      // ..setUserAgent(
      //     "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36")
      ..loadRequest(
        Uri.parse(url),
        // headers: {'Accept-Language': 'pt-BR'},
      );

    // if (_controller.platform is AndroidWebViewController) {
    //   AndroidWebViewController.enableDebugging(true);
    //   (_controller.platform as AndroidWebViewController)
    //       .setMediaPlaybackRequiresUserGesture(true);
    // }
    // _onListCookies();
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  // Future<void> _onListCookies() async {
  //   final String cookies = await _controller
  //       .runJavaScriptReturningResult('document.cookie') as String;
  //   if (!mounted) return;
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(cookies.isNotEmpty ? cookies : 'There are no cookies.'),
  //     ),
  //   );
  // }

  Future<bool> _browserBack(pop) async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return Future.value(false);
    } else {
      final bool res = await Callback.confirm(
          context: context, content: _traslation["on_out"]);
      if (res) {
        context.pop();
        // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // _onListCookies(_controller);
    return PopScope(
      onPopInvoked: (pop) => _browserBack(pop),
      canPop: false,
      child: _error
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _traslation["error_connection"]
                        .replaceAll("{error}", _errorString),
                  ),
                  Text(_traslation["error_connection"]),
                  ElevatedButton(
                    onPressed: () {
                      _controller.reload();
                      setState(() => _error = false);
                    },
                    child: Text(_traslation["try_again"]),
                  ),
                  TextButton(
                    onPressed: () {
                      _controller.goBack();
                      setState(() => _error = false);
                    },
                    child: Text(_traslation["go_back"]),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                WebViewWidget(
                  controller: _controller,
                ),
                if (loadingPercentage < 100)
                  LinearProgressIndicator(
                    value: loadingPercentage / 100.0,
                  ),
                if (loadingPercentage < 100)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(.5),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
              ],
            ),
    );
  }
}
