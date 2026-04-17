// discord_rpc_service.dart — stubbed out (dart_discord_presence not in pubspec)

import '../models/media_metadata.dart';
import 'jellyfin_client.dart';

/// Stub implementation of Discord Rich Presence service.
/// dart_discord_presence is not available in jelzy.
class DiscordRPCService {
  static DiscordRPCService? _instance;
  static DiscordRPCService get instance {
    _instance ??= DiscordRPCService._();
    return _instance!;
  }

  DiscordRPCService._();

  static bool get isAvailable => false;

  Future<void> initialize() async {}

  Future<void> setEnabled(bool enabled) async {}

  Future<void> startPlayback(MediaMetadata metadata, JellyfinClient client) async {}

  void updatePosition(Duration position) {}

  void updatePlaybackSpeed(double speed) {}

  Future<void> resumePlayback() async {}

  Future<void> pausePlayback() async {}

  Future<void> stopPlayback() async {}

  Future<void> clearPresence() async {}

  Future<void> dispose() async {}
}
