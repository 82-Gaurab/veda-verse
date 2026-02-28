import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:vedaverse/app/theme/theme_notifier.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'app_navigator_key.dart';

class SensorManagerDetector extends ConsumerStatefulWidget {
  final Widget child;

  const SensorManagerDetector({super.key, required this.child});

  @override
  ConsumerState<SensorManagerDetector> createState() =>
      _SensorManagerDetectorState();
}

class _SensorManagerDetectorState extends ConsumerState<SensorManagerDetector> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Shake detection
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _isShaking = false;
  DateTime? _lastShakeTime;

  // Proximity detection
  StreamSubscription<int>? _proximitySubscription;
  bool _lastIsNear = false;

  @override
  void initState() {
    super.initState();
    _initShakeDetection();
    _initProximityDetection();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _proximitySubscription?.cancel();
    super.dispose();
  }

  // ---------------- Shake Detection ----------------
  void _initShakeDetection() {
    _accelerometerSubscription = SensorsPlatform.instance
        .accelerometerEventStream()
        .listen((event) {
          // Calculate acceleration magnitude
          final double magnitude = sqrt(
            event.x * event.x + event.y * event.y + event.z * event.z,
          );

          // print("Magnitude: $magnitude");
          final now = DateTime.now();

          if (magnitude > 20) {
            // print("magnitude cross threshold: $magnitude");
            if (_lastShakeTime == null ||
                now.difference(_lastShakeTime!).inMilliseconds > 1000) {
              _lastShakeTime = now;

              if (!_isShaking) {
                _isShaking = true;
                _handleShake();
                Future.delayed(const Duration(seconds: 1), () {
                  _isShaking = false;
                });
              }
            }
          }
        });
  }

  void _handleShake() async {
    debugPrint("Shake detected! Logging out...");
    try {
      final userSessionService = ref.read(userSessionServiceProvider);
      final isLoggedIn = userSessionService.isLoggedIn();
      if (!isLoggedIn) return;

      await userSessionService.clearSession();

      // debugPrint("Check Mounted");
      appNavigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );

      // debugPrint("Logout completed");
    } catch (e) {
      debugPrint("Error during logout: $e");
    }
  }

  // ---------------- Proximity Detection ----------------
  void _initProximityDetection() {
    _proximitySubscription = ProximitySensor.events.listen((int event) {
      final bool isNear = event == 1;

      print("Event $event");
      // Only trigger if the sensor state changed
      if (isNear && !_lastIsNear) {
        _lastIsNear = true;

        if (mounted) {
          final themeNotifier = ref.read(themeModeProvider.notifier);
          final state = ref.read(themeModeProvider);

          // Flip theme opposite of current state
          if (state == ThemeMode.light) {
            themeNotifier.setDark();
            debugPrint("Proximity NEAR → Theme set to DARK");
          } else {
            themeNotifier.setLight();
            debugPrint("Proximity NEAR → Theme set to LIGHT");
          }
        }
      }
      // Update _lastIsNear when sensor goes FAR, but do NOT toggle theme
      else if (!isNear && _lastIsNear) {
        _lastIsNear = false;
        debugPrint("Proximity FAR → ready for next NEAR");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child; // simple wrapper
  }
}
