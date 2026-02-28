import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = true;

  static const String compIpAddress = "192.168.100.8";

  static const String port = "4000";
  static const String apiPath = "/api/v1";

  //Info: Base URL
  static String get baseUrl {
    if (isPhysicalDevice) {
      return "http://$compIpAddress:$port$apiPath";
    }
    if (kIsWeb) {
      return "http://localhost:$port$apiPath";
    } else if (Platform.isAndroid) {
      // info: for android
      return "http://10.0.2.2:$port$apiPath";
    } else if (Platform.isIOS) {
      return "http://localhost:$port$apiPath";
    } else {
      return "http://localhost:$port$apiPath";
    }
  }

  // Note: For physical device use computer IP: "http:/102.168.x.x:5000/api/v1"

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Hack: ========== Genre Endpoints ===========
  static const String genre = "/genres/";
  static String genreById(String id) => '/genres/$id';

  // Hack: ========== Review Endpoints ===========
  static const String review = "/genres/";
  static String reviewsByBookId(String id) => '/reviews/books/$id';
  static const String myReviews = '/reviews/my-reviews/';
  static const String createReview = '/reviews/';

  // Hack: ========== Book Endpoints ===========
  static const String books = "/books/";
  static String bookById(String id) => '/books/$id';
  static String booksByGenreId(String genreId) => '/books/genre/$genreId';

  // Hack: ========== Order Endpoints ===========
  static const String orders = "/orders/";
  static String myOrders = '/orders/my-orders';

  // Hack: ========== Cart Endpoints ===========
  static const String carts = "/auth/cart";

  // Hack: ========== User Endpoints ===========
  static const String userLogin = "/auth/login";
  static const String userRegister = "/auth/register";
  static const String updateUser = "/auth/update-profile";
  static const String userUploadPhoto = "/auth/upload-image";
  static const String userPasswordResetRequest =
      "/auth/request-password-reset-otp";
  static const String userPasswordReset = "/auth/reset-password-otp";
  static const String userInfo = "/auth/me";
}
