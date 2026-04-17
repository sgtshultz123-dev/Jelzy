import 'package:flutter/widgets.dart';

import '../models/media_metadata.dart';
import '../services/jellyfin_client.dart';
import '../utils/global_key_utils.dart';
import '../utils/provider_extensions.dart';

/// Shared helpers for screens bound to a single [MediaMetadata] item/server.
mixin ServerBoundMediaMixin<T extends StatefulWidget> on State<T> {
  MediaMetadata get serverBoundMetadata;

  bool get isServerBoundOffline => false;

  String? get serverBoundServerId => serverBoundMetadata.serverId;

  String toServerBoundGlobalKey(String ratingKey, {String? serverId}) =>
      buildGlobalKey(serverId ?? serverBoundServerId ?? '', ratingKey);

  JellyfinClient? getServerBoundClient(BuildContext context) =>
      context.getClientForMetadataOrNull(serverBoundMetadata, isOffline: isServerBoundOffline);
}
