import 'dart:html';

class PwaPromptService {
  static const dismissedKey = "kn-pwaDismissed";

  Stream<BeforeInstallPromptEvent> get prompt =>
      window.on["beforeinstallprompt"].cast();

  bool _dismissedCache = window.localStorage[dismissedKey] != null;
  bool get dismissed => _dismissedCache;
  set dismissed(bool value) {
    _dismissedCache = value;
    if (value) {
      window.localStorage[dismissedKey] = "f";
    } else {
      window.localStorage.remove(dismissedKey);
    }
  }
}
