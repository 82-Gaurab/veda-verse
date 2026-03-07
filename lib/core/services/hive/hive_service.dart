import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vedaverse/core/constants/hive_table_constant.dart';
import 'package:vedaverse/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/books/data/models/book_hive_model.dart';
import 'package:vedaverse/features/cart/data/models/cart_hive_model.dart';
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
    await _insertGenreDummyData();
    await _insertDummyBooks();
  }

  Future<void> _insertGenreDummyData() async {
    final genreBox = Hive.box<GenreHiveModel>(HiveTableConstant.genreTable);

    if (genreBox.isNotEmpty) {
      return;
    }

    final dummyGenres = [
      GenreHiveModel(genreTitle: "Romance"),
      GenreHiveModel(genreTitle: "Drama"),
      GenreHiveModel(genreTitle: "Murder"),
      GenreHiveModel(genreTitle: "Mystery"),
      GenreHiveModel(genreTitle: "Fantasy"),
      GenreHiveModel(genreTitle: "Crime"),
    ];

    for (var genre in dummyGenres) {
      await genreBox.put(genre.genreId, genre);
    }
  }

  Future<void> _insertDummyBooks() async {
    final bookBox = Hive.box<BookHiveModel>(HiveTableConstant.bookTable);

    if (bookBox.isNotEmpty) return;

    final dummyBooks = [
      BookHiveModel(
        bookId: "69aa38bf77a915891b5897ec",
        title: "Dragon Warrior",
        author: "god",
        description:
            "This is about a warrior who fights to live life on his own terms.",
        genre: [
          "Historical Fiction",
          "Horror",
          "Self-Help",
          "Thriller",
          "Young Adult",
        ],
        publishedYear: "2019",
        price: 1000.0,
      ),

      BookHiveModel(
        bookId: "69aa1d02962f108d2f646996",
        title: "Into the Wild",
        author: "Jon Krakauer",
        description:
            "This true story follows Christopher McCandless, a young man who abandons modern life. He travels across America seeking freedom and meaning. His journey eventually leads him to the Alaskan wilderness.",
        genre: ["Adventure", "Biography"],
        publishedYear: "1996",
        price: 1280.0,
      ),

      BookHiveModel(
        bookId: "69aa1cf2962f108d2f646991",
        title: "The Book Thief",
        author: "Markus Zusak",
        description:
            "Set in Nazi Germany, the story follows a young girl named Liesel who discovers the power of books.",
        genre: ["Historical Fiction", "Young Adult"],
        publishedYear: "2005",
        price: 1400.0,
      ),

      BookHiveModel(
        bookId: "69aa1ce3962f108d2f64698c",
        title: "Rich Dad Poor Dad",
        author: "Robert Kiyosaki",
        description:
            "Lessons learned from two father figures with different views on money and financial intelligence.",
        genre: ["Business & Finance", "Self-Help"],
        publishedYear: "1997",
        price: 1340.0,
      ),

      BookHiveModel(
        bookId: "69aa1cc7962f108d2f646987",
        title: "The Girl with the Dragon Tattoo",
        author: "Stieg Larsson",
        description:
            "Journalist Mikael Blomkvist investigates a decades-old disappearance with hacker Lisbeth Salander.",
        genre: ["Mystery", "Thriller"],
        publishedYear: "2005",
        price: 1670.0,
      ),

      BookHiveModel(
        bookId: "69aa1c39962f108d2f646980",
        title: "Sapiens",
        author: "Yuval Noah Harari",
        description:
            "Explores the history of humankind from ancient ancestors to modern society.",
        genre: ["Historical Fiction", "Psychology"],
        publishedYear: "2011",
        price: 1820.0,
      ),

      BookHiveModel(
        bookId: "69aa1c2f962f108d2f64697b",
        title: "The Shining",
        author: "Stephen King",
        description:
            "Jack Torrance becomes caretaker of the haunted Overlook Hotel.",
        genre: ["Horror", "Psychology", "Thriller"],
        publishedYear: "1977",
        price: 1480.0,
      ),

      BookHiveModel(
        bookId: "69aa1c26962f108d2f646976",
        title: "Harry Potter and the Sorcerer's Stone",
        author: "J.K. Rowling",
        description:
            "Harry Potter discovers he is a wizard and begins his journey at Hogwarts.",
        genre: ["Adventure", "Fantasy", "Young Adult"],
        publishedYear: "1997",
        price: 1575.0,
      ),

      BookHiveModel(
        bookId: "69aa1c1b962f108d2f646971",
        title: "The Da Vinci Code",
        author: "Dan Brown",
        description:
            "A murder inside the Louvre leads Robert Langdon into a secret investigation.",
        genre: ["Mystery", "Thriller"],
        publishedYear: "2003",
        price: 1650.0,
      ),

      BookHiveModel(
        bookId: "69aa1c12962f108d2f64696c",
        title: "Think and Grow Rich",
        author: "Napoleon Hill",
        description:
            "Classic book exploring the mindset needed for financial success.",
        genre: ["Business & Finance", "Self-Help"],
        publishedYear: "1937",
        price: 1199.0,
      ),
    ];

    for (var book in dummyBooks) {
      await bookBox.put(book.bookId, book);
    }
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.cartTypeId)) {
      Hive.registerAdapter(CartHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.bookTypeId)) {
      Hive.registerAdapter(BookHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstant.genreTypeId)) {
      Hive.registerAdapter(GenreHiveModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    await Hive.openBox<CartHiveModel>(HiveTableConstant.cartTable);
    await Hive.openBox<BookHiveModel>(HiveTableConstant.bookTable);
    await Hive.openBox<GenreHiveModel>(HiveTableConstant.genreTable);
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

  // HiveService
  Future<bool> updateUser(AuthHiveModel user) async {
    try {
      final existingUser = _authBox.get(user.authId);

      if (existingUser == null) {
        return false;
      }

      await _authBox.put(user.authId, user);
      return true;
    } catch (e) {
      return false;
    }
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

  Future<GenreHiveModel> createGenre(GenreHiveModel genre) async {
    await _genreBox.put(genre.genreId, genre);
    return genre;
  }

  Future<void> updateGenre(GenreHiveModel genre) async {
    await _genreBox.put(genre.genreId, genre);
  }

  Future<void> deleteGenre(String genreId) async {
    await _genreBox.delete(genreId);
  }

  Future<void> deleteAllGenre() async {
    await _genreBox.clear();
  }

  // Hack: =================== Cart CRUD Operations ===========================

  Box<CartHiveModel> get _cartBox =>
      Hive.box<CartHiveModel>(HiveTableConstant.cartTable);

  // Create / Add Cart Item
  Future<bool> addOrUpdateCartItem(
    String authId,
    int quantity,
    String bookId,
    CartHiveModel cartItem,
  ) async {
    final user = _authBox.get(authId);
    if (user == null) return false;

    // Get book details
    final book = getBookById(bookId);
    if (book == null) return false; // Book not found

    // Create cart item with book details
    final cartItem = CartHiveModel(
      bookId: bookId,
      title: book.title,
      author: book.author,
      price: book.price,
      publishedYear: book.publishedYear,
      coverImg: null, // You can add cover image URL if available
      quantity: quantity,
    );

    // Initialize cart if null
    final currentCart = user.cart;

    // Check if the book already exists in the cart
    final index = currentCart.indexWhere(
      (item) => item.bookId == cartItem.bookId,
    );
    if (index != -1) {
      // Update quantity (add to existing)
      final existingItem = currentCart[index];
      final updatedItem = CartHiveModel(
        cartId: existingItem.cartId,
        bookId: existingItem.bookId,
        title: existingItem.title,
        author: existingItem.author,
        price: existingItem.price,
        publishedYear: existingItem.publishedYear,
        coverImg: existingItem.coverImg,
        quantity: existingItem.quantity + quantity, // Add to existing quantity
      );
      currentCart[index] = updatedItem;
    } else {
      // Add new item
      currentCart.add(cartItem);
    }

    // Update the user's cart in Hive
    final updatedUser = AuthHiveModel(
      authId: user.authId,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      username: user.username,
      password: user.password,
      profilePicture: user.profilePicture,
      cart: currentCart,
    );

    await _authBox.put(authId, updatedUser);
    return true;
  }

  // Get all cart items
  List<CartHiveModel> getAllCartItems() {
    return _cartBox.values.toList();
  }

  List<CartHiveModel> getCart(String authId) {
    final user = _authBox.get(authId);
    return user?.cart ?? [];
  }

  // Get cart item by id
  CartHiveModel? getCartItemById(String cartId) {
    return _cartBox.get(cartId);
  }

  // Update cart item
  Future<bool> updateCartItem(CartHiveModel cartItem) async {
    final existing = _cartBox.get(cartItem.cartId);
    if (existing == null) return false;

    await _cartBox.put(cartItem.cartId, cartItem);
    return true;
  }

  // Delete cart item
  Future<bool> deleteCartItem(String cartId) async {
    final existing = _cartBox.get(cartId);
    if (existing == null) return false;

    await _cartBox.delete(cartId);
    return true;
  }

  // Clear all cart items
  Future<void> clearCart() async {
    await _cartBox.clear();
  }

  // Hack: =================== Book CRUD Operations ===========================

  Box<BookHiveModel> get _bookBox =>
      Hive.box<BookHiveModel>(HiveTableConstant.bookTable);

  // Get all books
  List<BookHiveModel> getAllBooks() {
    return _bookBox.values.toList();
  }

  BookHiveModel? getBookById(String bookId) {
    return _bookBox.get(bookId);
  }
}
