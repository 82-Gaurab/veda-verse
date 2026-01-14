import 'package:equatable/equatable.dart';

class GenreEntity extends Equatable {
  final String? genreId;
  final String genreTitle;

  const GenreEntity({this.genreId, required this.genreTitle});

  @override
  List<Object?> get props => [genreId, genreTitle];
}
