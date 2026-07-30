import 'package:flutter/material.dart';
import 'package:femcastells/features/home/data/home_service.dart';
import 'package:femcastells/global_endpoints.dart';
import '../widgets/html_content_stub.dart'
    if (dart.library.js_interop) '../widgets/html_content_web.dart';

class NoticiaDetailPage extends StatelessWidget {
  final NoticiaItem noticia;

  const NoticiaDetailPage({super.key, required this.noticia});

  String _fixImageUrls(String html) {
    // src="/path" → src="https://fp.artacho.org/path"
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: body != null
                  ? LayoutBuilder(
                      builder: (context, constraints) =>
                          buildHtmlContent(body, constraints.maxWidth),
                    )
                  : const Text('Sense contingut'),
            ),
          ),
        ],
      ),
    );
  }
}
