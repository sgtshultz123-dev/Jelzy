// gamepad_service.dart — stubbed out (universal_gamepad not in pubspec)

import 'package:flutter/widgets.dart';

/// Stub gamepad service. universal_gamepad is not available in jelzy.
class GamepadService {
  static GamepadService? _instance;

  /// Callback to switch InputModeTracker to keyboard mode.
  static VoidCallback? onGamepadInput;

  /// Callback for L1 bumper press (previous tab).
  static VoidCallback? onL1Pressed;

  /// Callback for R1 bumper press (next tab).
  static VoidCallback? onR1Pressed;

  GamepadService._();

  static GamepadService get instance {
    _instance ??= GamepadService._();
    return _instance!;
  }

  void start() {}

  void stop() {}
}
