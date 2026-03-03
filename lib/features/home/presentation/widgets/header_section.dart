import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/routes/app_routes.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/core/api/api_endpoints.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/cart/presentation/pages/cart_screen.dart';

class HeaderSection extends ConsumerStatefulWidget {
  const HeaderSection({super.key});

  @override
  ConsumerState<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<HeaderSection> {
  @override
  Widget build(BuildContext context) {
    final userSession = ref.watch(userSessionServiceProvider);
    final profilePicture = userSession.getUserProfileImage();
    final username = userSession.getUsername();
    final String fullUrl = "${ApiEndpoints.baseUrl}$profilePicture";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.network(
                fullUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,

                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;

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
                  return Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, $username!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Welcome Back",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => AppRoutes.push(context, const CartScreen()),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        ),
      ],
    );
  }
}
