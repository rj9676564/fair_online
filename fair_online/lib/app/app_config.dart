import 'dart:html' as html;
import 'dart:js_util' as js_util;

import 'package:flutter/foundation.dart';

const String _apiBaseUrlDefine = String.fromEnvironment(
  'FAIR_ONLINE_API_BASE_URL',
);

const String _debugApiBaseUrl = 'http://127.0.0.1:8082/service/';
const String _defaultReleaseApiBaseUrl = '/service/';

class AppConfig {
  static String get apiBaseUrl {
    final String fromDefine = _normalizeApiBaseUrl(_apiBaseUrlDefine);
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }

    final String fromWindow = _readWindowApiBaseUrl();
    if (fromWindow.isNotEmpty) {
      return fromWindow;
    }

    return kDebugMode ? _debugApiBaseUrl : _defaultReleaseApiBaseUrl;
  }

  static String _readWindowApiBaseUrl() {
    final Object? rawConfig = js_util.getProperty<Object?>(
      html.window,
      '__FAIR_ONLINE_CONFIG__',
    );
    if (rawConfig == null) {
      return '';
    }

    final Object? apiBaseUrl = js_util.getProperty<Object?>(
      rawConfig,
      'apiBaseUrl',
    );
    return _normalizeApiBaseUrl(apiBaseUrl?.toString() ?? '');
  }

  static String _normalizeApiBaseUrl(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    return trimmed.endsWith('/') ? trimmed : '$trimmed/';
  }
}
