import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'iframe_view_stub.dart'
    if (dart.library.js_interop) 'iframe_view_web.dart';

class MyWebView extends StatefulWidget {
  final String url;
  const MyWebView({required this.url, super.key});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  WebViewController? _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;

    final controller = WebViewController.fromPlatformCreationParams(
      const PlatformWebViewControllerCreationParams(),
    );
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _isLoading = false),
        onNavigationRequest: (_) => NavigationDecision.navigate,
      ))
      ..loadRequest(Uri.parse(widget.url));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return buildIframeView(widget.url);
    }
    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_isLoading)
          Container(
            color: Colors.white.withValues(alpha: 0.7),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
