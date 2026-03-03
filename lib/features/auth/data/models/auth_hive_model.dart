import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:vedaverse/core/constants/hive_table_constant.dart';
import 'package:vedaverse/features/auth/domain/entities/auth_entity.dart';
import 'package:vedaverse/features/cart/data/models/cart_hive_model.dart';

// INFO: dart run build_runner build -d
part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String username;

  @HiveField(5)
  final String? password;

  @HiveField(6)
  final String? profilePicture;

  @HiveField(7)
  final List<CartHiveModel> cart;

  AuthHiveModel({
    String? authId,
    required this.firstName,
    required this.email,
    required this.username,
    this.password,
    this.profilePicture,
    required this.lastName,
    List<CartHiveModel>? cart,
  }) : authId = authId ?? const Uuid().v4(),
       cart = cart ?? [];

  // Hive → Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      firstName: firstName,
      email: email,
      username: username,
      password: password,
      profilePicture: profilePicture,
      lastName: lastName,
      cart: cart.map((e) => e.toEntity()).toList(),
    );
  }

  // Entity → Hive
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      firstName: entity.firstName,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      profilePicture: entity.profilePicture,
      lastName: entity.lastName,
      cart: entity.cart.map((e) => CartHiveModel.fromEntity(e)).toList(),
    );
  }

  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
