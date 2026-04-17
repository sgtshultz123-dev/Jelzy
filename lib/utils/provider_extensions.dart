import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/jellyfin_client.dart';
import '../i18n/strings.g.dart';
import '../models/media_library.dart';
import '../models/media_metadata.dart';
import '../models/user_profile_preferences.dart';
import '../providers/hidden_libraries_provider.dart';
import '../providers/multi_server_provider.dart';
import '../providers/user_profile_provider.dart';
import 'app_logger.dart';

extension ProviderExtensions on BuildContext {
  UserProfileProvider get userProfile => Provider.of<UserProfileProvider>(this, listen: false);

  HiddenLibrariesProvider get hiddenLibraries => Provider.of<HiddenLibrariesProvider>(this, listen: false);

  // Direct profile settings access (nullable)
  UserProfilePreferences? get profileSettings => userProfile.profileSettings;

  /// Get JellyfinClient for a specific server ID
  /// Throws an exception if no client is available for the given serverId
  JellyfinClient getClientForServer(String serverId) {
    final multiServerProvider = Provider.of<MultiServerProvider>(this, listen: false);

    final serverClient = multiServerProvider.getClientForServer(serverId);

    if (serverClient == null) {
      appLogger.e('No client found for server $serverId');
      throw Exception(t.errors.noClientAvailable);
    }

    return serverClient;
  }

  /// Get JellyfinClient for a specific server ID, or null if unavailable.
  JellyfinClient? tryGetClientForServer(String? serverId) {
    if (serverId == null) return null;
    final multiServerProvider = Provider.of<MultiServerProvider>(this, listen: false);
    return multiServerProvider.getClientForServer(serverId);
  }

  /// Get JellyfinClient for a library
  /// Throws an exception if no client is available
  JellyfinClient getClientForLibrary(MediaLibrary library) {
    // If library doesn't have a serverId, fall back to first available server
    if (library.serverId == null) {
      final multiServerProvider = Provider.of<MultiServerProvider>(this, listen: false);
      final serverId = multiServerProvider.onlineServerIds.firstOrNull;
      if (serverId == null) {
        throw Exception(t.errors.noClientAvailable);
      }
      return getClientForServer(serverId);
    }
    return getClientForServer(library.serverId!);
  }

  /// Get JellyfinClient for metadata, with fallback to first available server
  /// Throws an exception if no servers are available
  JellyfinClient getClientForMetadata(MediaMetadata metadata) {
    if (metadata.serverId != null) {
      return getClientForServer(metadata.serverId!);
    }
    return getFirstAvailableClient();
  }

  /// Get JellyfinClient for metadata, or null if offline mode or no serverId
  /// Use this for screens that support offline mode
  JellyfinClient? getClientForMetadataOrNull(MediaMetadata metadata, {bool isOffline = false}) {
    if (isOffline || metadata.serverId == null) {
      return null;
    }
    return tryGetClientForServer(metadata.serverId);
  }

  /// Get the first available client from connected servers
  /// Throws an exception if no servers are available
  JellyfinClient getFirstAvailableClient() {
    final multiServerProvider = Provider.of<MultiServerProvider>(this, listen: false);
    final serverId = multiServerProvider.onlineServerIds.firstOrNull;
    if (serverId == null) {
      throw Exception(t.errors.noClientAvailable);
    }
    return getClientForServer(serverId);
  }

  /// Get the first available client, or null if no servers are connected
  JellyfinClient? tryGetFirstAvailableClient() {
    final multiServerProvider = Provider.of<MultiServerProvider>(this, listen: false);
    final serverId = multiServerProvider.onlineServerIds.firstOrNull;
    if (serverId == null) return null;
    return multiServerProvider.getClientForServer(serverId);
  }

  /// Get client for a serverId with fallback to first available server
  /// Useful for items that might not have a serverId
  JellyfinClient getClientWithFallback(String? serverId) {
    if (serverId != null) {
      return getClientForServer(serverId);
    }
    return getFirstAvailableClient();
  }
}
