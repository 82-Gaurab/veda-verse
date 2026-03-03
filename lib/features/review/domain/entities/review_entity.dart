import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
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

  const ReviewEntity({
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

  @override
  List<Object?> get props => [
    reviewId,
    userId,
    bookId,
    bookTitle,
    title,
    comment,
    rating,
    username,
    profilePicture,
    createdAt,
  ];
}
