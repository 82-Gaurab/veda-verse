import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/review/presentation/state/review_state.dart';
import 'package:vedaverse/features/review/presentation/view_model/review_view_model.dart';

class ReviewForm extends ConsumerStatefulWidget {
  final String bookId;

  const ReviewForm({super.key, required this.bookId});

  @override
  ConsumerState<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends ConsumerState<ReviewForm> {
  final _titleController = TextEditingController();
  final _commentController = TextEditingController();
  double _rating = 3.0;

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_titleController.text.trim().isEmpty ||
        _commentController.text.trim().isEmpty) {
      SnackbarUtils.showError(context, "All fields are required");
      return;
    }

    await ref
        .read(reviewViewModelProvider.notifier)
        .createReview(
          bookId: widget.bookId,
          title: _titleController.text.trim(),
          comment: _commentController.text.trim(),
          rating: _rating,
        );

    final state = ref.read(reviewViewModelProvider);

    if (state.status == ReviewStatus.loaded) {
      SnackbarUtils.showSuccess(context, "Review posted successfully");

      _titleController.clear();
      _commentController.clear();
      setState(() => _rating = 3.0);

      // Refresh reviews
      await ref
          .read(reviewViewModelProvider.notifier)
          .getBookReview(bookId: widget.bookId);
    } else if (state.status == ReviewStatus.error) {
      SnackbarUtils.showError(
        context,
        state.errorMessage ?? "Failed to post review",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reviewState = ref.watch(reviewViewModelProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: theme.cardColor, // uses light/dark card color
        borderRadius: BorderRadius.circular(20),
        boxShadow: theme.brightness == Brightness.dark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Write a Review",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          /// Title Field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Review title",
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// Comment Field
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Write your review...",
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),

          /// Rating Slider
          Text("Rating", style: theme.textTheme.bodyMedium),
          Slider(
            value: _rating,
            min: 1,
            max: 5,
            divisions: 8,
            label: _rating.toString(),
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() => _rating = value);
            },
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: reviewState.status == ReviewStatus.loading
                  ? null
                  : _submitReview,
              child: reviewState.status == ReviewStatus.loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      "Post Review",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
