// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

Widget buildHtmlContent(String htmlContent, double maxWidth) {
  return _HtmlNativeView(html: htmlContent);
}

class _HtmlNativeView extends StatefulWidget {
  final String html;
  const _HtmlNativeView({required this.html});

  @override
  State<_HtmlNativeView> createState() => _HtmlNativeViewState();
}

class _HtmlNativeViewState extends State<_HtmlNativeView> {
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'html-noticia-${widget.html.hashCode}';

    try {
      ui.platformViewRegistry.registerViewFactory(_viewId, (int id) {
        final div = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.fontFamily = 'sans-serif'
          ..style.fontSize = '15px'
          ..style.lineHeight = '1.6'
          ..style.overflowY = 'auto'
          ..style.overflowX = 'auto'
          ..style.boxSizing = 'border-box';

        div.setInnerHtml(
          widget.html,
          treeSanitizer: html.NodeTreeSanitizer.trusted,
        );

        return div;
      });
    } catch (_) {
      // viewFactory ja registrada (hot reload)
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewId);
  }
}
