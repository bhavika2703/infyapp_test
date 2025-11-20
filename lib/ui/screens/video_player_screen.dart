// lib/ui/screens/home/vimeo_player_sheet.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VimeoPlayerSheet extends StatefulWidget {
  final String embedUrl;
  final String title;
  final String description;
  const VimeoPlayerSheet({
    required this.embedUrl,
    required this.title,
    required this.description,

    super.key,
  });

  @override
  State createState() => _VimeoPlayerSheetState();
}

class _VimeoPlayerSheetState extends State<VimeoPlayerSheet> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Create controller and allow JS
    _controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);

    // Simple responsive HTML wrapper for Vimeo iframe
    final html = '''
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>body,html{margin:0;padding:0;height:100%;} .player{position:relative;padding-top:56.25%;} iframe{position:absolute;top:0;left:0;width:100%;height:100%;}</style>
      </head>
      <body>
        <div class="player">
          <iframe src="${widget.embedUrl}" frameborder="0" allow="autoplay; fullscreen; picture-in-picture" allowfullscreen></iframe>
        </div>
      </body>
    </html>
    ''';

    _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.7;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          AppBar(
            title: Text(widget.title, overflow: TextOverflow.ellipsis),
            automaticallyImplyLeading: true,
          ),
          Expanded(child: WebViewWidget(controller: _controller)),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(widget.description, maxLines: 3, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
