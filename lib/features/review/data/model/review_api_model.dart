import 'package:vedaverse/features/review/domain/entities/review_entity.dart';

class ReviewApiModel {
  final String? userId;
  final String title;
  final String comment;
  final String? username;
  final String? profilePicture;
  final double rating;

  ReviewApiModel({
    this.userId,
    required this.title,
    required this.comment,
    required this.rating,
    this.username,
    this.profilePicture,
  });

  // info: From Json
  factory ReviewApiModel.fromJson(Map<String, dynamic> json) {
    return ReviewApiModel(
      title: json["title"],
      rating: json["rating"],
      comment: json["comment"],
      userId: json["userId"]["_id"],
      username: json["userId"]["username"],
      profilePicture: json["userId"]["profilePicture"],
    );
  }

  // info: To Json
  Map<String, dynamic> toJson() {
    return {"title": title, "comment": comment, "rating": rating};
  }

  // info: from Entity
  factory ReviewApiModel.fromEntity(ReviewEntity entity) {
    return ReviewApiModel(
      title: entity.title,
      rating: entity.rating,
      comment: entity.comment,
    );
  }

  // info: To Entity
  ReviewEntity toEntity() {
    return ReviewEntity(
      title: title,
      rating: rating,
      comment: comment,
      userId: userId,
      username: username,
      profilePicture: profilePicture,
    );
  }

  // info: To Entity List
  static List<ReviewEntity> toEntityList(List<ReviewApiModel> models) {
    return models
        .map(
          (model) => ReviewEntity(
            title: model.title,
            rating: model.rating,
            comment: model.comment,
            username: model.username,
            profilePicture: model.profilePicture,
          ),
        )
        .toList();
  }
}
