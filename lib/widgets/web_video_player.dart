import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const WebVideoPlayer({super.key, required this.videoUrl});

  @override
  State<WebVideoPlayer> createState() => _WebVideoPlayerState();
}

class _WebVideoPlayerState extends State<WebVideoPlayer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final String html =
        '''
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body, html {
            margin: 0;
            padding: 0;
            background-color: black;
            height: 100%;
            overflow: hidden;
          }
          video {
            width: 100%;
            height: 100%;
            object-fit: contain;
            -webkit-touch-callout: none;     /* iOS Safari */
            -webkit-user-select: none;       /* Safari */
            -khtml-user-select: none;        /* Konqueror HTML */
            -moz-user-select: none;          /* Firefox */
            -ms-user-select: none;           /* Internet Explorer/Edge */
            user-select: none;               /* Non-prefixed version */
          }
        </style>
      </head>
      <body oncontextmenu="return false">
        <video controls autoplay controlsList="nodownload noplaybackrate">
          <source src="${widget.videoUrl}" type="video/mp4">
          Trình duyệt của bạn không hỗ trợ video.
        </video>
        <script>
          document.addEventListener('contextmenu', event => event.preventDefault());
        </script>
      </body>
    </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.dataFromString(
          html,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: _controller));
  }
}
