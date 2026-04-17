/// Represents a Jellyfin Timer (individual scheduled recording).
class ScheduledRecording {
  final String? key;
  final String title;
  final String? overview;
  final String? channelId;
  final String? channelName;
  final String? seriesTimerId;
  final String? programId;
  final String? status;
  final DateTime? startTime;
  final DateTime? endTime;
  final int prePaddingSeconds;
  final int postPaddingSeconds;

  /// For episodes
  final String? seriesName;
  final int? seasonNumber;
  final int? episodeNumber;

  ScheduledRecording({
    this.key,
    required this.title,
    this.overview,
    this.channelId,
    this.channelName,
    this.seriesTimerId,
    this.programId,
    this.status,
    this.startTime,
    this.endTime,
    this.prePaddingSeconds = 0,
    this.postPaddingSeconds = 0,
    this.seriesName,
    this.seasonNumber,
    this.episodeNumber,
  });

  factory ScheduledRecording.fromJellyfinJson(Map<String, dynamic> json) {
    final startStr = json['StartDate'] as String?;
    final endStr = json['EndDate'] as String?;

    return ScheduledRecording(
      key: json['Id'] as String?,
      title: json['Name'] as String? ?? 'Unknown',
      overview: json['Overview'] as String?,
      channelId: json['ChannelId'] as String?,
      channelName: json['ChannelName'] as String?,
      seriesTimerId: json['SeriesTimerId'] as String?,
      programId: json['ProgramId'] as String?,
      status: json['Status'] as String?,
      startTime: startStr != null ? DateTime.tryParse(startStr) : null,
      endTime: endStr != null ? DateTime.tryParse(endStr) : null,
      prePaddingSeconds: (json['PrePaddingSeconds'] as num?)?.toInt() ?? 0,
      postPaddingSeconds: (json['PostPaddingSeconds'] as num?)?.toInt() ?? 0,
      seriesName: json['SeriesName'] as String?,
      seasonNumber: (json['SeasonNumber'] as num?)?.toInt(),
      episodeNumber: (json['EpisodeNumber'] as num?)?.toInt(),
    );
  }

  int get durationMinutes {
    if (startTime == null || endTime == null) return 0;
    return endTime!.difference(startTime!).inMinutes;
  }

  String get displayTitle {
    if (seriesName != null && episodeNumber != null) {
      final se = seasonNumber != null ? 'S${seasonNumber}E$episodeNumber' : 'E$episodeNumber';
      return '$seriesName - $se - $title';
    }
    return title;
  }

  /// Whether this timer is part of a series timer rule
  bool get isSeriesTimer => seriesTimerId != null && seriesTimerId!.isNotEmpty;
}
