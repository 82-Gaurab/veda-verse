import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

final shakeServiceProvider = Provider<ShakeService>((ref) {
  final service = ShakeService();
  ref.onDispose(service.stop);
  return service;
});

class ShakeService {
  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShakeTime;

  void start(Future<void> Function() onShake) {
    _subscription = accelerometerEventStream().listen((event) async {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (magnitude > 10) {
        print("Magnitude: $magnitude");
        final now = DateTime.now();

        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > const Duration(seconds: 2)) {
          _lastShakeTime = now;

          try {
            await onShake();
          } catch (e, stack) {
            print("Shake callback error: $e");
            print("$stack");
          }
        }
      }
    });
  }

  void stop() {
    _subscription?.cancel();
  }
}
