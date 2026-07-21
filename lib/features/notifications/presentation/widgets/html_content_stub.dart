import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';

Widget buildHtmlContent(String html, double maxWidth) {
  return Html(
    data: html,
    extensions: const [TableHtmlExtension()],
    style: {
      'body': Style(fontSize: FontSize(15), margin: Margins.zero, padding: HtmlPaddings.zero),
      'img':  Style(width: Width(maxWidth)),
      'table': Style(border: Border.all(color: Color(0xFFDDDDDD))),
      'td': Style(padding: HtmlPaddings.all(6), border: Border.all(color: Color(0xFFDDDDDD))),
      'th': Style(padding: HtmlPaddings.all(6), fontWeight: FontWeight.bold, border: Border.all(color: Color(0xFFDDDDDD))),
    },
  );
}
