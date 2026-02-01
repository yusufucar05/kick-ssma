import 'package:flutter/material.dart';
import 'package:desktop_webview_window/desktop_webview_window.dart';

class KickWebViewPanel extends StatefulWidget {
  final VoidCallback onClose;

  const KickWebViewPanel({super.key, required this.onClose});

  @override
  State<KickWebViewPanel> createState() => _KickWebViewPanelState();
}

class _KickWebViewPanelState extends State<KickWebViewPanel> {
  Webview? webview;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    webview = await WebviewWindow.create(
      configuration: const CreateConfiguration(
        windowHeight: 800,
        windowWidth: 500,
        title: "Kick Yayın Ayarları",
      ),
    );

    webview!
      ..launch("https://www.youtube.com/@zynoxus")
      ..setBrightness(Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      child: Column(
        children: [
          Container(
            height: 48,
            color: Colors.black,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    webview?.close();
                    widget.onClose();
                  },
                ),
                const Text(
                  'Kick Yayın Ayarları',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Kick paneli ayrı pencere olarak açıldı",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
