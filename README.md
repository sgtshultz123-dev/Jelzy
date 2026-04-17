<h1>
  <img src="assets/jelzy.png" alt="Jelzy Logo" height="24" style="vertical-align: middle;" />
  Jelzy
</h1>

A modern Jellyfin client for desktop, mobile, and Android TV. Built with Flutter for native performance and a clean interface, with full HDR / Dolby Vision support.

> **Fork notice**: Jelzy is a fork of [edde746/plezy](https://github.com/edde746/plezy) — an excellent Plex client — adapted to talk to [Jellyfin](https://jellyfin.org) servers instead of Plex. All credit for the UI, player pipeline, and architecture belongs to the Plezy authors. Changes upstream will be merged in where applicable.

## Why a new fork?

There is already [finzy](https://github.com/dkmcgowan/finzy), which is the canonical Jellyfin fork of Plezy. Jelzy exists because finzy does not (yet) support HDR / Dolby Vision on Android TV, while Plezy does — so Jelzy started as a minimal-delta fork that keeps Plezy's HDR pipeline and only swaps the Plex API layer for Jellyfin's. If you don't care about HDR on Android TV, use finzy.

## Features

### Authentication
- Sign in with Jellyfin username / password against any Jellyfin server
- Multi-server support

### Media Browsing
- Libraries with rich metadata, collections, playlists
- Advanced search, Live TV + DVR, Watch Next integration on Android TV

### Playback
- mpv on desktop / iOS, ExoPlayer on Android (and Android TV)
- HDR10 + Dolby Vision passthrough where the device supports it
- Wide codec support (HEVC, AV1, VP9, …) with transcode fallback
- Full ASS/SSA subtitle rendering via libass
- Progress sync via Jellyfin's `PlaybackProgress` reports
- Auto-play next episode

### Downloads
- Offline playback with background download queue

## Building from source

### Prerequisites
- Flutter SDK ≥ 3.8.1
- A reachable Jellyfin server

### Setup

```bash
git clone https://github.com/fampla/jelzy.git
cd jelzy
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Android TV

```bash
# Build debug APK
flutter build apk --debug
# Install on a running Android TV emulator / device
adb install -r build/app/outputs/flutter-apk/app-debug.apk
adb shell am start -n com.jelzy.app/.MainActivity
```

## Acknowledgments

- **[Plezy](https://github.com/edde746/plezy)** by [@edde746](https://github.com/edde746) — the upstream client this fork is based on.
- **[finzy](https://github.com/dkmcgowan/finzy)** by [@dkmcgowan](https://github.com/dkmcgowan) — prior Jellyfin port of Plezy; inspiration and several dependency forks (`os_media_controls`, `wakelock_plus`).
- Built with [Flutter](https://flutter.dev).
- Playback powered by [mpv](https://mpv.io) via [MPVKit](https://github.com/mpvkit/MPVKit) and [libmpv-android](https://github.com/jarnedemeulemeester/libmpv-android), plus [AndroidX Media3 / ExoPlayer](https://developer.android.com/media/media3).
- Designed for [Jellyfin](https://jellyfin.org).

## License

Same as upstream Plezy. See [LICENSE](LICENSE).
