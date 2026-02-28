import 'package:vedaverse/features/review/domain/entities/review_entity.dart';

class ReviewApiModel {
  final String? reviewId;
  final String? userId;
  final String? bookId;
  final String? bookTitle;

  final String title;
  final String comment;
  final double rating;

  final String? username;
  final String? profilePicture;
  final DateTime? createdAt;

  ReviewApiModel({
    this.reviewId,
    this.userId,
    this.bookId,
    this.bookTitle,
    required this.title,
    required this.comment,
    required this.rating,
    this.username,
    this.profilePicture,
    this.createdAt,
  });

  /// info: From Json
  factory ReviewApiModel.fromJson(Map<String, dynamic> json) {
    return ReviewApiModel(
      reviewId: json["_id"],

      title: json["title"],
      comment: json["comment"],
      rating: (json["rating"] as num).toDouble(),

      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,

      userId: json["userId"] is Map ? json["userId"]["_id"] : json["userId"],

      username: json["userId"] is Map ? json["userId"]["username"] : null,

      profilePicture: json["userId"] is Map
          ? json["userId"]["profilePicture"]
          : null,

      bookId: json["bookId"] is Map ? json["bookId"]["_id"] : json["bookId"],

      bookTitle: json["bookId"] is Map ? json["bookId"]["title"] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "comment": comment, "rating": rating};
  }

  // info: From Entity
  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      reviewId: entity.reviewId,
      userId: entity.userId,
      bookId: entity.bookId,
      bookTitle: entity.bookTitle,
      title: entity.title,
      comment: entity.comment,
      rating: entity.rating,
      username: entity.username,
      profilePicture: entity.profilePicture,
      createdAt: entity.createdAt,
    );
  }

  // info: To Entity
  ReviewEntity toEntity() {
    return ReviewEntity(
      reviewId: reviewId,
      userId: userId,
      bookId: bookId,
      bookTitle: bookTitle,
      title: title,
      comment: comment,
      rating: rating,
      username: username,
      profilePicture: profilePicture,
      createdAt: createdAt,
    );
  }

  // info:  To Entity List
  static List<ReviewEntity> toEntityList(List<ReviewApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
