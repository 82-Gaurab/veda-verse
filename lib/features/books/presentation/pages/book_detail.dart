import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/app/theme/theme_extensions.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';
import 'package:vedaverse/features/books/presentation/widgets/detail_row.dart';
import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';
import 'package:vedaverse/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:vedaverse/features/review/presentation/widgets/review_card.dart';
import 'package:vedaverse/features/review/presentation/state/review_state.dart';
import 'package:vedaverse/features/review/presentation/view_model/review_view_model.dart';
import 'package:vedaverse/features/review/presentation/widgets/review_form.dart';

class BookDetail extends ConsumerStatefulWidget {
  final String bookId;
  const BookDetail({super.key, required this.bookId});

  @override
  ConsumerState<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends ConsumerState<BookDetail> {
  final TextEditingController _quantityController = TextEditingController(
    text: "1",
  );

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _showCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Add To Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Quantity",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Quantity",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              final quantity =
                  int.tryParse(_quantityController.text.trim()) ?? 0;

              if (quantity <= 0) {
                SnackbarUtils.showError(context, "Quantity must be at least 1");
                return;
              }

              Navigator.pop(dialogContext);

              await ref
                  .read(cartViewModelProvider.notifier)
                  .createCart(bookId: widget.bookId, quantity: quantity);

              SnackbarUtils.showSuccess(context, "$quantity book to cart");

              _quantityController.text = "1";
            },
            child: const Text(
              'Add',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookViewModelProvider.notifier).getBookById(widget.bookId);
      ref
          .read(reviewViewModelProvider.notifier)
          .getBookReview(bookId: widget.bookId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookState = ref.watch(bookViewModelProvider);
    final book = bookState.book;
    final reviewState = ref.watch(reviewViewModelProvider);
    final reviews = reviewState.bookReviews;
    final media = MediaQuery.of(context).size;
    ref.listen(bookViewModelProvider, (previous, next) {
      if (next.status == BookStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed To Retrieve book data",
        );
      }
    });
    ref.listen(reviewViewModelProvider, (previous, next) {
      if (next.status == ReviewStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed To Retrieve review data",
        );
      }
    });
    ref.listen(cartViewModelProvider, (previous, next) {
      if (next.status == CartStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed To Upload Cart",
        );
      }
    });
    final String fullUrl = "${ApiEndpoints.baseUrl}${book?.coverImg}";

    return Scaffold(
      backgroundColor: const Color(0xffF6EFE7),
      body: SafeArea(
        child: book == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      child: Transform.scale(
                        scale: 1.5,
                        origin: Offset(0, media.width * 0.8),
                        child: Container(
                          width: media.width,
                          height: media.width,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(
                              media.width * 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// Content
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Back Button
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: media.width * 0.1),

                          Center(
                            child: Container(
                              height: media.width * 0.6,
                              width: media.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  fullUrl,
                                  fit: BoxFit.cover,

                                  frameBuilder:
                                      (
                                        context,
                                        child,
                                        frame,
                                        wasSynchronouslyLoaded,
                                      ) {
                                        if (wasSynchronouslyLoaded) {
                                          return child;
                                        }

                                        if (frame == null) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryLight,
                                            ),
                                          );
                                        }

                                        return child;
                                      },

                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.book,
                                        size: 60,
                                        color: AppColors.primary,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Book Title
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Author
                          Text(
                            "by ${book.author}",
                            style: const TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 40),

                          /// White Detail Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Genre
                                const Text(
                                  "Genre",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Wrap(
                                  spacing: 8,
                                  children: book.genre!
                                      .map(
                                        (g) => Chip(
                                          label: Text(g),
                                          backgroundColor: AppColors
                                              .primaryGreen
                                              .withValues(alpha: 0.1),
                                        ),
                                      )
                                      .toList(),
                                ),

                                const SizedBox(height: 20),

                                /// Price
                                DetailRow(
                                  title: "Price",
                                  value: "Rs. ${book.price}",
                                ),

                                const SizedBox(height: 12),

                                /// Published Year
                                DetailRow(
                                  title: "Published",
                                  value: book.publishedYear ?? "",
                                ),

                                const SizedBox(height: 20),

                                /// Description Section
                                const Text(
                                  "About this book",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  book.description ??
                                      "No description available.",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                /// Add to Cart Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryGreen,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showCartDialog(context);
                                    },
                                    child: const Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Reviews Section
                          ReviewForm(bookId: widget.bookId),
                          SizedBox(height: 10),
                          Text(
                            "Reviews (${reviews.length})",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          reviewState.status == ReviewStatus.loading
                              ? const Center(child: CircularProgressIndicator())
                              : reviews.isEmpty
                              ? const Text("No reviews yet.")
                              : Column(
                                  children: reviews
                                      .map(
                                        (review) => ReviewCard(review: review),
                                      )
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
