import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vedaverse/core/constants/hive_table_constant.dart';
import 'package:vedaverse/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/genre/data/model/genre_hive_model.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/${HiveTableConstant.dbName}";

    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Future<void> closeBoxes() async {
    await Hive.close();
  }

  // Hack: =================== Auth CRUD Operations ===========================

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

  // Register a user
  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    await _authBox.put(model.authId, model);
    return model;
  }

  // Login user
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final user = await _authBox.values.where(
      (user) => user.email == email && user.password == password,
    );

    if (user.isNotEmpty) return user.first;

    return null;
  }

  // get current user
  Future<AuthHiveModel?> getCurrentUser(String authId) async {
    return _authBox.get(authId);
  }

  // check email already exists
  Future<bool> isEmailExists(String email) async {
    final users = _authBox.values.where((user) => user.email == email);
    return users.isNotEmpty;
  }

  // logout
  Future<void> logoutUser() async {}

  // Hack: =================== Genre CRUD Operations ===========================
  Box<GenreHiveModel> get _genreBox =>
      Hive.box<GenreHiveModel>(HiveTableConstant.genreTable);

  List<GenreHiveModel> getAllGenre() {
    return _genreBox.values.toList();
  }

  GenreHiveModel? getGenreById(String genreId) {
    return _genreBox.get(genreId);
  }

  Future<GenreHiveModel> createBatch(GenreHiveModel genre) async {
    await _genreBox.put(genre.genreId, genre);
    return genre;
  }

  Future<void> updateBatch(GenreHiveModel genre) async {
    await _genreBox.put(genre.genreId, genre);
  }

  Future<void> deleteBatch(String genreId) async {
    await _genreBox.delete(genreId);
  }

  Future<void> deleteAllGenre() async {
    await _genreBox.clear();
  }
}
