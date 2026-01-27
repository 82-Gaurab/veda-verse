import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;

  static const String compIpAddress = "192.168.100.8";

  static const String portPath = "4000/api/v1";

  //Info: Base URL
  static String get baseUrl {
    if (isPhysicalDevice) {
      return "http://$compIpAddress:$portPath";
    }
    if (kIsWeb) {
      return "http://localhost:$portPath";
    } else if (Platform.isAndroid) {
      // info: for android
      return "http://10.0.2.2:$portPath";
    } else if (Platform.isIOS) {
      return "http://localhost:$portPath";
    } else {
      return "http://localhost:$portPath";
    }
  }

  // Note: For physical device use computer IP: "http:/102.168.x.x:5000/api/v1"

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Hack: ========== Batch Endpoints ===========
  static const String genre = "/genre";
  static String genreById(String id) => '/genre/$id';

  // Hack: ========== User Endpoints ===========
  // static const String users = "/users";
  static const String userLogin = "/auth/login";
  static const String userRegister = "/auth/register";
  static const String userUploadPhoto = "/auth/upload-image";
  // static String userById(String id) => '/users/$id';
  // static String userPhoto(String id) => "/users/$id/photo";
}
