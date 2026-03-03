import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';
import 'package:vedaverse/features/books/presentation/widgets/detail_row.dart';
import 'package:vedaverse/features/cart/presentation/state/cart_state.dart';
import 'package:vedaverse/features/cart/presentation/view_model/cart_view_model.dart';
import 'package:vedaverse/features/explore/presentation/widgets/genre_card.dart';
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

  void _showCartDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Add To Cart',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Enter Quantity",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Quantity",
                filled: true,
                fillColor:
                    theme.inputDecorationTheme.fillColor ??
                    Colors.grey.shade200,
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
            child: Text('Cancel', style: theme.textTheme.bodyMedium),
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
              SnackbarUtils.showSuccess(
                context,
                "$quantity book added to cart",
              );
              _quantityController.text = "1";
            },
            child: Text(
              'Add',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
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
    final theme = Theme.of(context);
    final bookState = ref.watch(bookViewModelProvider);
    final book = bookState.book;
    final reviewState = ref.watch(reviewViewModelProvider);
    final reviews = reviewState.bookReviews;
    final media = MediaQuery.of(context).size;

    ref.listen(bookViewModelProvider, (previous, next) {
      if (next.status == BookStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed to retrieve book data",
        );
      }
    });

    ref.listen(reviewViewModelProvider, (previous, next) {
      if (next.status == ReviewStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed to retrieve review data",
        );
      }
    });

    ref.listen(cartViewModelProvider, (previous, next) {
      if (next.status == CartStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed to add to cart",
        );
      }
    });

    final String fullUrl = "${ApiEndpoints.baseUrl}${book?.coverImg}";

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              media.width * 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.arrow_back,
                              color: theme.iconTheme.color,
                            ),
                          ),
                          SizedBox(height: media.width * 0.1),
                          Center(
                            child: Container(
                              height: media.width * 0.6,
                              width: media.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: theme.brightness == Brightness.dark
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
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
                                      (context, child, frame, wasSync) {
                                        if (wasSync) return child;
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
                                    return Image.asset(
                                      "assets/images/default-book-cover.png",
                                      width: media.width * 0.32,
                                      height: media.width * 0.50,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            book.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "by ${book.author}",
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 40),
                          // Details Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Genre",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children: book.genre!
                                      .map((g) => GenreCard(title: g))
                                      .toList(),
                                ),
                                const SizedBox(height: 20),
                                DetailRow(
                                  title: "Price",
                                  value: "Rs. ${book.price}",
                                  textColor: theme.textTheme.bodyMedium?.color,
                                ),
                                const SizedBox(height: 12),
                                DetailRow(
                                  title: "Published",
                                  value: book.publishedYear ?? "",
                                  textColor: theme.textTheme.bodyMedium?.color,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "About this book",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  book.description ??
                                      "No description available.",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    height: 1.6,
                                    color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _showCartDialog(context, theme),
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
                          ReviewForm(bookId: widget.bookId),
                          const SizedBox(height: 10),
                          Text(
                            "Reviews (${reviews.length})",
                            style: theme.textTheme.titleMedium?.copyWith(
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
