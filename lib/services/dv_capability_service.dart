import 'package:flutter/services.dart';

class DvCapabilityService {
  static const _channel = MethodChannel('com.jelzy/exo_player');

  static bool _initialized = false;
  static bool dvProfile7Supported = false;
  static bool dvProfile8Supported = false;
  static bool conversionAvailable = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      final result = await _channel.invokeMethod<Map>('getDvCapabilities');
      if (result != null) {
        dvProfile7Supported = result['dvProfile7'] as bool? ?? false;
        dvProfile8Supported = result['dvProfile8'] as bool? ?? false;
        conversionAvailable = result['conversionAvailable'] as bool? ?? false;
      }
    } catch (e) {
      // Not on Android or ExoPlayer not available — no DV support
    }
    _initialized = true;
  }

  static bool get supportsDolbyVision => dvProfile7Supported || dvProfile8Supported;

  static List<String> get supportedVideoCodecs {
    final codecs = ['h264', 'hevc', 'vp9'];
    if (supportsDolbyVision) {
      codecs.addAll(['dvhe', 'dvh1']);
    }
    return codecs;
  }
}
