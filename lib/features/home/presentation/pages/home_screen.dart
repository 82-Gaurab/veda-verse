import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/routes/app_routes.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/books/presentation/state/book_state.dart';
import 'package:vedaverse/features/books/presentation/view_model/book_view_model.dart';
import 'package:vedaverse/features/explore/presentation/pages/explore_screen.dart';
import 'package:vedaverse/features/explore/presentation/widgets/book_card.dart';
import 'package:vedaverse/features/explore/presentation/widgets/genre_card.dart';
import 'package:vedaverse/features/genre/presentation/states/genre_state.dart';
import 'package:vedaverse/features/genre/presentation/view_model/genre_view_model.dart';
import 'package:vedaverse/features/home/presentation/widgets/header_section.dart';
import 'package:vedaverse/features/home/presentation/widgets/top_pick_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(genreViewModelProvider.notifier).getAllGenres();
      ref.read(bookViewModelProvider.notifier).getAllBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final genreState = ref.watch(genreViewModelProvider);
    final bookState = ref.watch(bookViewModelProvider);

    ref.listen(bookViewModelProvider, (previous, next) {
      if (next.status == BookStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Failed to Fetch Book Data",
        );
      }
    });

    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffF6EFE7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      borderRadius: BorderRadius.circular(media.width * 0.5),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeaderSection(),
                  SizedBox(height: media.width * 0.13),
                  Row(
                    children: const [
                      Text(
                        "Our Top Picks",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  SizedBox(
                    width: media.width,
                    height: media.width * 0.8,
                    child: CarouselSlider.builder(
                      itemCount: bookState.books.length,
                      itemBuilder:
                          (
                            BuildContext context,
                            int itemIndex,
                            int pageViewIndex,
                          ) {
                            var book = bookState.books[itemIndex];
                            return TopPicksSection(book: book);
                          },
                      options: CarouselOptions(
                        autoPlay: false,
                        aspectRatio: 1,
                        enlargeCenterPage: true,
                        viewportFraction: 0.45,
                        enlargeFactor: 0.5,
                        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        const Text(
                          "Genre",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            AppRoutes.push(context, ExploreScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 40,
                    child: genreState.status == GenreStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : genreState.genres.isEmpty
                        ? const Text("No genres found")
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: genreState.genres.map((genre) {
                              return GestureDetector(
                                onTap: () {
                                  AppRoutes.push(context, ExploreScreen());
                                },
                                child: GenreCard(title: genre.genreTitle),
                              );
                            }).toList(),
                          ),
                  ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Bestsellers",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          AppRoutes.push(context, ExploreScreen());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_forward_ios, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: bookState.status == BookStatus.loading
                        ? const Center(child: CircularProgressIndicator())
                        : bookState.books.isEmpty
                        ? const Text("No Books found")
                        : Row(
                            children: bookState.books.map((book) {
                              return Padding(
                                padding: const EdgeInsets.all(0),
                                child: BookCard(
                                  title: book.title,
                                  author: book.author,
                                  coverImg: book.coverImg,
                                  bookId: book.bookId!,
                                ),
                              );
                            }).toList(),
                          ),
                  ),

                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
