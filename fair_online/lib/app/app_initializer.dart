import 'package:fair_online/app/app_config.dart';
import 'package:fair_online/editor/core/dependencies.dart';
import 'package:fair_online/editor/core/keys.dart';
import 'package:fair_online/editor/modules/dartservices_module.dart';
import 'package:fair_online/editor/services/dartservices.dart';
import 'package:fair_online/utils/sp_util.dart';
import 'package:http/browser_client.dart';

class AppInitializer {
  void init() {
    Dependencies.setGlobalInstance(Dependencies());
    _initDartServices();
    //初始化web按键监听
    deps[Keys] = Keys();
  }

  void _initDartServices() {
    final client = SanitizingBrowserClient();
    deps[BrowserClient] = client;
    deps[DartservicesApi] =
        DartservicesApi(client, rootUrl: AppConfig.apiBaseUrl);
  }

  static bool hasVisited() {
    var hasVisited = SPUtil.getBool('hasVisited');
    if (hasVisited ?? false) {
      return true;
    } else {
      SPUtil.setBool('hasVisited', true);
      return false;
    }
  }
}
