import 'package:connectcall/repo/profile_repo.dart';
import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/auth/update_screen.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_bloc.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_event.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_state.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_button.dart';
import 'package:connectcall/widgets/app_header.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:connectcall/widgets/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(ProfileRepository())..add(LoadProfile()),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appHeader: const CustomHeader(title: 'profile'),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (_) => false,
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: context.error,
                  content: Text(
                    state.message,
                    style: context.labelMR.copyWith(color: context.onError),
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return Center(
              child: CircularProgressIndicator(color: context.primary),
            );
          }

          if (state is ProfileLoaded) {
            final user = state.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Profile picture
                  GestureDetector(
                    onTap: () => _goToEditProfile(context, user),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundColor: context.primary.withOpacity(0.12),
                          backgroundImage: user.photoUrl.isNotEmpty
                              ? NetworkImage(user.photoUrl)
                              : null,
                          child: user.photoUrl.isEmpty
                              ? Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : '?',
                                  style: context.headlineSL.copyWith(
                                    color: context.primary,
                                  ),
                                )
                              : null,
                        ),

                        // Camera button
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: context.primary,
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: context.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const VSpace(5),

                  // Name
                  Text(
                    user.name,
                    style: context.titleLR.copyWith(
                      color: context.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const VSpace(1),

                  // Email / phone
                  Text(
                    user.email.isNotEmpty ? user.email : user.phone,
                    style: context.bodySSB.copyWith(
                      color: context.onSurface.withOpacity(0.65),
                    ),
                  ),

                  const VSpace(2),

                  // Online status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: user.isOnline
                              ? Colors.green
                              : context.onSurface.withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user.isOnline ? 'Online' : 'Offline',
                        style: context.labelMB.copyWith(
                          color: user.isOnline
                              ? Colors.green
                              : context.onSurface.withOpacity(0.55),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  CustomButton(
                    variant: CustomButtonVariant.secondary,
                    text: "Edit Profile",
                    onPressed: () => _goToEditProfile(context, user),
                    icon: CupertinoIcons.pencil_circle,
                  ),

                  const VSpace(2),
                  CustomButton(
                    variant: CustomButtonVariant.secondary,
                    text: "Change Password",
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResetPasswordScreen(),
                      ),
                    ),
                    icon: CupertinoIcons.lock,
                  ),
                  const VSpace(2),
                  CustomButton(
                    variant: CustomButtonVariant.primary,
                    backgroundColor: context.error,
                    text: 'Logout',
                    onPressed: () => _confirmLogout(context),
                    icon: CupertinoIcons.square_arrow_right,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _goToEditProfile(BuildContext context, dynamic user) {
    final profileBloc = context.read<ProfileBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: profileBloc,
          child: EditProfileScreen(userProfile: user),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.surface,

        title: Center(
          child: Text(
            'Log out?',
            style: context.titleMR.copyWith(color: context.onSurface),
          ),
        ),

        content: Text(
          'You will need to log in again to make calls.',
          style: context.bodySSB.copyWith(
            color: context.onSurface.withOpacity(0.7),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: context.labelMB.copyWith(color: context.primary),
            ),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              context.read<ProfileBloc>().add(const LogoutRequested());
            },
            child: Text(
              'Log Out',
              style: context.labelMB.copyWith(color: context.error),
            ),
          ),
        ],
      ),
    );
  }
}
