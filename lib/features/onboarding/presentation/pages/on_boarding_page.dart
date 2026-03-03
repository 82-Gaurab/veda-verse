import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/onboarding/domain/entities/on_boarding_item.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/page_indicator.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/routes/app_routes.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;

  final List<OnboardingItem> _onboardingItems = const [
    OnboardingItem(
      title: 'Discover Your Next Read',
      description:
          'Explore thousands of physical books across all genres. From bestsellers to hidden gems, find your perfect next read.',
      icon: Icons.menu_book_rounded,
      color: AppColors.onboarding1Primary,
      gradientColors: [
        AppColors.onboarding1Primary,
        AppColors.onboarding1Secondary,
      ],
    ),
    OnboardingItem(
      title: 'Easy & Secure Checkout',
      description:
          'Order your favorite books in just a few taps. Enjoy secure payments and a smooth checkout experience.',
      icon: Icons.shopping_cart_checkout_rounded,
      color: AppColors.onboarding2Primary,
      gradientColors: [
        AppColors.onboarding2Primary,
        AppColors.onboarding2Secondary,
      ],
    ),
    OnboardingItem(
      title: 'Fast Delivery to Your Door',
      description:
          'Get physical books delivered straight to your doorstep or choose convenient pickup options near you.',
      icon: Icons.local_shipping_rounded,
      color: AppColors.onboarding3Primary,
      gradientColors: [
        AppColors.onboarding3Primary,
        AppColors.onboarding3Secondary,
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _animationController
      ..reset()
      ..forward();
  }

  void _nextPage() {
    if (_currentPage < _onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      AppRoutes.pushReplacement(context, const LoginScreen());
    }
  }

  void _skipOnboarding() {
    AppRoutes.pushReplacement(context, const LoginScreen());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  colors: [Colors.grey[900]!, Colors.grey[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar with Skip Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skipOnboarding,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        backgroundColor: isDark
                            ? Colors.white12
                            : AppColors.white30,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme
                              .textTheme
                              .bodyLarge!
                              .color, // <-- updated here
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _onboardingItems.length,
                  itemBuilder: (context, index) {
                    return FadeTransition(
                      opacity: _animationController,
                      child: OnboardingContent(
                        item: _onboardingItems[index],
                        isDarkMode: isDark,
                      ),
                    );
                  },
                ),
              ),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Page Indicator
                    PageIndicator(
                      itemCount: _onboardingItems.length,
                      currentPage: _currentPage,
                      activeColor: _onboardingItems[_currentPage].color,
                    ),
                    const SizedBox(height: 32),

                    // Next/Get Started Button
                    GradientButton(
                      text: _currentPage == _onboardingItems.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _nextPage,
                      gradient: LinearGradient(
                        colors: _onboardingItems[_currentPage].gradientColors,
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
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
