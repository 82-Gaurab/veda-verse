import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:vedaverse/core/constants/hive_table_constant.dart';
import 'package:vedaverse/features/cart/domain/entities/cart_entity.dart';

part 'cart_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.cartTypeId)
class CartHiveModel extends HiveObject {
  @HiveField(0)
  final String cartId;

  @HiveField(1)
  final String bookId;

  @HiveField(2)
  final String? title;

  @HiveField(3)
  final String? author;

  @HiveField(4)
  final double? price;

  @HiveField(5)
  final String? publishedYear;

  @HiveField(6)
  final String? coverImg;

  @HiveField(7)
  final int quantity;

  CartHiveModel({
    String? cartId,
    required this.bookId,
    this.title,
    this.author,
    this.price,
    this.publishedYear,
    this.coverImg,
    required this.quantity,
  }) : cartId = cartId ?? const Uuid().v4();

  // Hive → Entity
  CartEntity toEntity() {
    return CartEntity(
      bookId: bookId,
      title: title,
      author: author,
      price: price,
      publishedYear: publishedYear,
      coverImg: coverImg,
      quantity: quantity,
    );
  }

  // Entity → Hive
  factory CartHiveModel.fromEntity(CartEntity entity) {
    return CartHiveModel(
      bookId: entity.bookId,
      title: entity.title,
      author: entity.author,
      price: entity.price,
      publishedYear: entity.publishedYear,
      coverImg: entity.coverImg,
      quantity: entity.quantity,
    );
  }
}
