// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

Widget buildIframeView(String url) => _IframeView(url: url);

class _IframeView extends StatefulWidget {
  final String url;
  const _IframeView({required this.url});

  @override
  State<_IframeView> createState() => _IframeViewState();
}

class _IframeViewState extends State<_IframeView> {
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'pinya-iframe-${widget.url.hashCode}';
    try {
      ui.platformViewRegistry.registerViewFactory(_viewId, (int id) {
        return html.IFrameElement()
          ..src = widget.url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewId);
}
