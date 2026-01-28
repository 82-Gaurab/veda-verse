import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/app/theme/theme_extensions.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/dashboard/presentation/widgets/menu_item.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
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
              Navigator.pop(dialogContext);
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Profile"),
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.onboarding1Secondary,
                              width: 2,
                            ),
                            color: Colors.transparent,
                          ),
                          child: CircleAvatar(
                            // backgroundImage: AssetImage("assets/images/logo.png"),
                            radius: 90,
                            child: Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 17,
                          right: 7,
                          child: GestureDetector(
                            onTap: () {
                              _showLogoutDialog(context);
                            },
                            child: Card(
                              color: AppColors.onboarding1Secondary,
                              shape: CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text("Name", style: TextStyle(fontSize: 20)),
                    Text("Email@email.com", style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),

              SizedBox(height: 20),

              MenuItem(
                icon: Icons.person_outline_rounded,
                title: "Manage Profile",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.lock_outline_rounded,
                title: "Password & Security",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.notifications_none_rounded,
                title: "Notifications",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.newspaper_outlined,
                title: "About Us",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.format_color_fill_outlined,
                title: "Theme",
                onTap: () {},
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.logout,
                iconColor: Colors.red,
                title: "Log Out",
                titleColor: Colors.red,
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
