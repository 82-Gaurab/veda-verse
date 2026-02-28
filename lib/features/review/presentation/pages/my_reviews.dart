import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/theme_extensions.dart';
import 'package:vedaverse/features/review/presentation/state/review_state.dart';
import 'package:vedaverse/features/review/presentation/view_model/review_view_model.dart';
import 'package:vedaverse/features/review/presentation/widgets/my_review_card.dart';

class MyReviews extends ConsumerStatefulWidget {
  const MyReviews({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyReviewsState();
}

class _MyReviewsState extends ConsumerState<MyReviews> {
  void _navigateBack() => Navigator.of(context).pop();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(reviewViewModelProvider.notifier).getMyReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewViewModelProvider);
    final reviews = reviewState.myReviews;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: context.softShadow,
            ),
            child: Icon(Icons.arrow_back, color: context.textPrimary, size: 20),
          ),
          onPressed: _navigateBack,
        ),
      ),
      body: SafeArea(
        child: reviewState.status == ReviewStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : reviews.isEmpty
            ? const Text("No Review found")
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return MyReviewCard(review: reviews[index]);
                },
              ),
      ),
    );
  }
}
