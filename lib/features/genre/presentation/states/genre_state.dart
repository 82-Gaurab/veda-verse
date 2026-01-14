import 'package:equatable/equatable.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';

enum GenreStatus { initial, loading, loaded, error, created, updated, deleted }

class GenreState extends Equatable {
  final GenreStatus status;
  final List<GenreEntity> genres;
  final String? errorMessage;

  const GenreState({
    this.status = GenreStatus.initial,
    this.genres = const [],
    this.errorMessage,
  });

  GenreState copyWith({
    GenreStatus? status,
    List<GenreEntity>? genres,
    String? errorMessage,
  }) {
    return GenreState(
      status: status ?? this.status,
      genres: genres ?? this.genres,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, genres, errorMessage];
}
