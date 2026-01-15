import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';

class GenreApiModel {
  final String? genreId;
  final String genreTitle;

  GenreApiModel({this.genreId, required this.genreTitle});

  //info: to JSON
  Map<String, dynamic> toJson() {
    return {"genreTitle": genreTitle};
  }

  // info: from JSON
  factory GenreApiModel.fromJson(Map<String, dynamic> json) {
    return GenreApiModel(
      genreId: json["_id"] as String,
      genreTitle: json["genreTitle"] as String,
    );
  }

  // info: to Entity
  GenreEntity toEntity() {
    return GenreEntity(genreId: genreId, genreTitle: genreTitle);
  }

  //info: from Entity
  factory GenreApiModel.fromEntity(GenreEntity entity) {
    return GenreApiModel(genreTitle: entity.genreTitle);
  }

  //info: to Entity List
  static List<GenreEntity> toEntityList(List<GenreApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
