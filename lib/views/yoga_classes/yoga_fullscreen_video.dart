import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class VimeoFullScreenPlayer extends StatefulWidget {
  final String videoId;
  const VimeoFullScreenPlayer({super.key, required this.videoId});

  @override
  State<VimeoFullScreenPlayer> createState() => _VimeoFullScreenPlayerState();
}

class _VimeoFullScreenPlayerState extends State<VimeoFullScreenPlayer> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Force device orientation to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    // Platform-specific initialization
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams();
    } else {
      params = AndroidWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(
        Uri.parse('https://player.vimeo.com/video/${widget.videoId}?autoplay=1&loop=0&muted=0&title=1&byline=0&portrait=0'),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {},
          onPageFinished: (url) {},
          onWebResourceError: (error) {
            debugPrint("Error loading video: ${error.description}");
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  void dispose() {
    // Reset orientation to portrait when closing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),

            // ⬅️ Back Button (top-left)
            Positioned(
              top: 12,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}