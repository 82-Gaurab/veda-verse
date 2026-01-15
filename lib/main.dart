import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedaverse/app/app.dart';
import 'package:vedaverse/core/services/hive/hive_service.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  final sharedPref = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferenceProvider.overrideWithValue(sharedPref)],
      child: MyApp(),
    ),
  );
}
