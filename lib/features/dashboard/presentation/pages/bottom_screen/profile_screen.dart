import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vedaverse/app/theme/app_colors.dart';
import 'package:vedaverse/app/theme/theme_extensions.dart';
import 'package:vedaverse/common/my_snack_bar.dart';
import 'package:vedaverse/features/auth/presentation/pages/login_screen.dart';
import 'package:vedaverse/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:vedaverse/features/dashboard/presentation/widgets/menu_item.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedMedia = []; // info: store selected images, videos

  //info: code for dialogBox : show dialog for menu
  Future<void> _pickMedia() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text("Open Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text("Choose from Gallery"),
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

  //info: ask permission from user
  Future<bool> _getUserPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }

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

  // info: Function to show permission popup dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Give Permission"),
        content: Text("To use this feature go in permission setting"),
        actions: [
          TextButton(onPressed: () {}, child: Text("Cancel")),
          TextButton(onPressed: () {}, child: Text("Open Setting")),
        ],
      ),
    );
  }

  //Info: Code for camera
  Future<void> _pickFromCamera() async {
    final hasPermission = await _getUserPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _selectedMedia.add(photo);
      });

      // info: upload image to server
      await ref
          .read(authViewModelProvider.notifier)
          .uploadPhoto(File(photo.path));
    }
  }

  //info: code for gallery
  Future<void> _pickFromGallery() async {
    try {
      final hasPermission = await _getUserPermission(Permission.storage);
      if (!hasPermission) return;
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedMedia.clear();
          _selectedMedia.add(image);
        });

        // info: upload image to server
        await ref
            .read(authViewModelProvider.notifier)
            .uploadPhoto(File(image.path));
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
                            // backgroundImage: _selectedMedia.isNotEmpty
                            //     ? FileImage(File(_selectedMedia[0].path))
                            //     : null,
                            radius: 90,

                            child: _selectedMedia.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 60,
                                    color: AppColors.primary,
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      File(_selectedMedia[0].path),
                                      width: 180,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            // child: _selectedMedia.isEmpty
                            //     ? Icon(
                            //         Icons.person_rounded,
                            //         size: 60,
                            //         color: AppColors.primary,
                            //       )
                            //     : null,
                          ),
                        ),
                        Positioned(
                          bottom: 17,
                          right: 7,
                          child: GestureDetector(
                            onTap: () {
                              _pickMedia();
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
                    SizedBox(height: 5),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
