import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:ssma/features/presets/models/stream_preset.dart';

class KickWebViewService {
  static Webview? _webview;

  static Future<void> openKickDashboard() async {
    _webview = await WebviewWindow.create(
      configuration: const CreateConfiguration(
        title: "Kick Dashboard",
        windowHeight: 800,
        windowWidth: 1200,
      ),
    );

    _webview?.launch("https://www.youtube.com/@zynoxus");
  }

  static Future<void> applyPresetToKick(StreamPreset preset) async {
    if (_webview == null) return;

    String safeTitle = preset.title.replaceAll("'", "\\'");
    String safeCategory = preset.categoryName.replaceAll("'", "\\'");

    String jsCode =
        """
      (function() {
        var inputs = document.querySelectorAll('input');
        inputs.forEach(input => {
          if(input.name === 'title') {
            input.value = '$safeTitle';
            input.dispatchEvent(new Event('input', { bubbles: true }));
          }
          if(input.placeholder && input.placeholder.includes('Category')) {
            input.value = '$safeCategory';
            input.dispatchEvent(new Event('input', { bubbles: true }));
          }
        });
      })();
    """;

    await _webview?.evaluateJavaScript(jsCode);
  }
}
