import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fempinya3_flutter_app/features/home/data/home_service.dart';
import 'package:fempinya3_flutter_app/global_endpoints.dart';

class NoticiaDetailPage extends StatelessWidget {
  final NoticiaItem noticia;

  const NoticiaDetailPage({super.key, required this.noticia});

  String _fixImageUrls(String html) {
    // Imatges amb src relatiu → URL absoluta
    return html.replaceAllMapped(
      RegExp(r'src="(/[^"]+)"'),
      (m) => 'src="${GlobalEndpoints.apiBaseUrl}${m[1]}"',
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = noticia.body != null ? _fixImageUrls(noticia.body!) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(noticia.title, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noticia.publishedAt.substring(0, 10),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            if (noticia.labels.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: noticia.labels
                    .map((l) => Chip(
                          label: Text(l, style: const TextStyle(fontSize: 12)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 12),
            if (body != null)
              LayoutBuilder(
                builder: (context, constraints) => Html(
                  data: body,
                  style: {
                    'body': Style(
                      fontSize: FontSize(15),
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                    ),
                    'img': Style(
                      width: Width(constraints.maxWidth),
                    ),
                  },
                ),
              )
            else
              const Text('Sense contingut'),
          ],
        ),
      ),
    );
  }
}
