import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vedaverse/app/routes/app_routes.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/core/services/storage/user_session_service.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/auth/presentation/pages/password_screen.dart';
import 'package:vedaverse/features/auth/presentation/pages/update_screen.dart';
import 'package:vedaverse/features/auth/presentation/state/auth_state.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/order/presentation/pages/my_orders.dart';
import 'package:vedaverse/features/profile/presentation/widgets/menu_item.dart';
import 'package:vedaverse/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:vedaverse/features/review/presentation/pages/my_reviews.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedMedia = [];

  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.camera,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                "Open Camera",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.image,
                color: Theme.of(context).iconTheme.color,
              ),
              title: Text(
                "Choose from Gallery",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _getUserPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }
    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Give Permission"),
        content: const Text("To use this feature, go to permission settings"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(onPressed: () {}, child: const Text("Open Settings")),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _getUserPermission(Permission.camera);
    if (!hasPermission) {
      _showPermissionDeniedDialog();
      return;
    }

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(photo);
      });
      _handleProfileUpload(photo);
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final hasPermission = await _getUserPermission(Permission.photos);
      if (!hasPermission) {
        _showPermissionDeniedDialog();
        return;
      }

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(image);
        });
        _handleProfileUpload(image);
      }
    } catch (e) {
      debugPrint("Gallery error : $e");
      if (mounted) {
        SnackbarUtils.showError(context, "Gallery not accessed");
      }
    }
  }

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
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref.read(authViewModelProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
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

  Future<void> _handleProfileUpload(XFile image) async {
    final userSession = ref.read(userSessionServiceProvider);

    ref
        .read(authViewModelProvider.notifier)
        .updateUser(
          firstName: "${userSession.getUserFirstName()}",
          lastName: "${userSession.getUserLastName()}",
          username: "${userSession.getUsername()}",
          email: "${userSession.getUserEmail()}",
          profilePicture: File(image.path),
        );
  }

  @override
  Widget build(BuildContext context) {
    final userSession = ref.watch(userSessionServiceProvider);
    final profilePictureUrl = userSession.getUserProfileImage();

    ref.listen(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(context, next.errorMessage ?? "Update Failed");
      } else if (next.status == AuthStatus.loaded) {
        SnackbarUtils.showSuccess(context, "Successfully updated Profile");
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ProfileAvatar(
                          imageUrl: profilePictureUrl,
                          onEditTap: _pickMedia,
                        ),
                        Positioned(
                          bottom: 17,
                          right: 7,
                          child: GestureDetector(
                            onTap: _pickMedia,
                            child: Card(
                              color: AppColors.onboarding1Secondary,
                              shape: const CircleBorder(),
                              child: const Padding(
                                padding: EdgeInsets.all(7.0),
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
                    const SizedBox(height: 5),
                    Text(
                      "${userSession.getUserFirstName()} ${userSession.getUserLastName()}",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    Text(
                      userSession.getUserEmail() ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu Items
              MenuItem(
                icon: Icons.person_outline_rounded,
                title: "Manage Profile",
                onTap: () => AppRoutes.push(context, UpdateScreen()),
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.lock_outline_rounded,
                title: "Password & Security",
                onTap: () => AppRoutes.push(context, PasswordScreen()),
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.history,
                title: "Order History",
                onTap: () => AppRoutes.push(context, MyOrders()),
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.newspaper_outlined,
                title: "My Reviews",
                onTap: () => AppRoutes.push(context, MyReviews()),
              ),
              const SizedBox(height: 12),
              MenuItem(
                icon: Icons.logout,
                iconColor: Theme.of(context).colorScheme.error,
                title: "Log Out",
                titleColor: Theme.of(context).colorScheme.error,
                onTap: () => _showLogoutDialog(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
