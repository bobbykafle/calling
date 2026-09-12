import 'package:connectcall/screen/onboard/profile/bloc/profile_bloc.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_event.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_state.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/utils/custom_textfiled.dart';
import 'package:connectcall/utils/photo_picker.dart';
import 'package:connectcall/widgets/app_container.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_button.dart';
import 'package:connectcall/widgets/app_error.dart';
import 'package:connectcall/widgets/app_header.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EditProfileScreen extends HookWidget {
  const EditProfileScreen({super.key, required this.userProfile});

  final dynamic userProfile;

  @override
  Widget build(BuildContext context) {
    final fullNameController = useTextEditingController(text: userProfile.name);
    final emailController = useTextEditingController(text: userProfile.email); 

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          AppTErrorNotification.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading;
        final profileBloc = context.read<ProfileBloc>();

        return AuthScaffold(
          appHeader: CustomHeader(title: 'Edit Profile'),
          header: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfilePhotoPicker(
                  initialPhotoUrl: userProfile.photoUrl,
                  uploadPhoto: profileBloc.profileRepository.uploadProfilePhoto,
                  onUploaded: (url) {
                    profileBloc.add(
                      EditProfileSubmitted(
                        name: fullNameController.text.trim(),
                        email: emailController.text.trim(), 
                        photoUrl: url,
                      ),
                    );
                  },
                  onError: (message) {
                    if (context.mounted) {
                      AppTErrorNotification.show(context, message: message);
                    }
                  },
                ),
                const VSpace(2),
                Text(
                  'Update your name and email',
                  style: context.bodySSB.copyWith(color: context.onSurface),
                ),
              ],
            ),
          ),
          body: CustomAuthContainer(
            children: [
              DecoratedTextField(
                aboveText: 'Full Name',
                hintText: 'Jane Doe',
                textCapitalization: TextCapitalization.words,
                prefixIcon: const Icon(CupertinoIcons.person_fill),
                textInputAction: TextInputAction.next,
                controller: fullNameController,
              ),
              const VSpace(2),
              DecoratedTextField(
                aboveText: 'Email', 
                hintText: 'you@example.com',
                inputType: TextInputType.emailAddress,
                prefixIcon: const Icon(CupertinoIcons.mail_solid), 
                textInputAction: TextInputAction.done,
                controller: emailController, 
              ),
              const VSpace(1),
              CustomButton(
                text: 'Save Changes',
                isLoading: isLoading,
                icon: CupertinoIcons.checkmark_circle_fill,
                suffixIcon: Icon(CupertinoIcons.sparkles, size: 18, color: context.white),
                onPressed: isLoading
                    ? null
                    : () {
                        profileBloc.add(
                          EditProfileSubmitted(
                            name: fullNameController.text.trim(),
                            email: emailController.text.trim(), 
                          ),
                        );
                        Navigator.pop(context);
                      },
              ),
            ],
          ),
        );
      },
    );
  }
}