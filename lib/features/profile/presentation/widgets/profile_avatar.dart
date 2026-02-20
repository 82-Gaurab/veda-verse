import 'package:flutter/material.dart';
import 'package:vedaverse/app/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onEditTap;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.onEditTap,
  });

  bool _imageDoesNotExist(String? url) {
    return url == null || url == "default";
  }

  @override
  Widget build(BuildContext context) {
    final String fullUrl = "http://192.168.100.8:4000/api/v1$imageUrl";

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.onboarding1Secondary, width: 2),
          ),
          child: CircleAvatar(
            radius: 90,
            backgroundColor: Colors.transparent,
            child: _imageDoesNotExist(imageUrl)
                ? Icon(Icons.person_rounded, size: 60, color: AppColors.primary)
                : ClipOval(
                    child: Image.network(
                      fullUrl,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const CircularProgressIndicator();
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  ),
          ),
        ),

        // ✏ Edit Button
        Positioned(
          bottom: 17,
          right: 7,
          child: GestureDetector(
            onTap: onEditTap,
            child: Card(
              color: AppColors.onboarding1Secondary,
              shape: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(7.0),
                child: Icon(Icons.edit, color: Colors.white, size: 17),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
