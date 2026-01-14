import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:vedaverse/core/constants/hive_table_constant.dart';
import 'package:vedaverse/features/genre/domain/entities/genre_entity.dart';

// hack: dart run build_runner build -d
part 'genre_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.genreTypeId)
class GenreHiveModel extends HiveObject {
  @HiveField(0)
  final String? genreId;

  @HiveField(1)
  final String genreTitle;

  GenreHiveModel({String? genreId, required this.genreTitle})
    : genreId = genreId ?? Uuid().v4();

  //info: to Entity
  GenreEntity toEntity() {
    return GenreEntity(genreId: genreId, genreTitle: genreTitle);
  }

  // info: from entity
  factory GenreHiveModel.fromEntity(GenreEntity entity) {
    return GenreHiveModel(genreTitle: entity.genreTitle);
  }

  // info: to entity list
  static List<GenreEntity> toEntityList(List<GenreHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
