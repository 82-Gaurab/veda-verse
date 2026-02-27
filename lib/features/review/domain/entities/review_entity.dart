import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String? userId;
  final String title;
  final String comment;
  final String? username;
  final String? profilePicture;
  final double rating;

  const ReviewEntity({
    this.userId,
    required this.title,
    required this.comment,
    required this.rating,
    this.username,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    userId,
    title,
    comment,
    rating,
    username,
    profilePicture,
  ];
}
