import 'dart:io';
import 'package:connectcall/screen/onboard/profile/bloc/profile_bloc.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_event.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_state.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/utils/custom_textfiled.dart';
import 'package:connectcall/widgets/app_container.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_button.dart';
import 'package:connectcall/widgets/app_error.dart';
import 'package:connectcall/widgets/app_header.dart';

import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends HookWidget {
  const EditProfileScreen({super.key, required this.userProfile});

  final dynamic userProfile; 

  @override
  Widget build(BuildContext context) {
    final fullNameController = useTextEditingController(text: userProfile.name);
    final phoneController = useTextEditingController(text: userProfile.phone);

  
    final localPhotoPath = useState<String?>(null);
    final uploadedPhotoUrl = useState<String?>(userProfile.photoUrl);
    final isUploadingPhoto = useState(false);

    Future<void> pickAndUploadPhoto() async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;

      localPhotoPath.value = picked.path; 
      isUploadingPhoto.value = true;
      try {
        final url = await context
            .read<ProfileBloc>()
            .profileRepository 
            .uploadProfilePhoto(File(picked.path));
        uploadedPhotoUrl.value = url;
        if (context.mounted) {
          context.read<ProfileBloc>().add(
                EditProfileSubmitted(name: fullNameController.text.trim(), photoUrl: url),
              );
        }
      } catch (_) {
        if (context.mounted) {
          AppTErrorNotification.show(context, message: 'Could not upload photo. Try again.');
        }
      } finally {
        isUploadingPhoto.value = false;
      }
    }

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          AppTErrorNotification.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is ProfileLoading;

        return AuthScaffold(
           appHeader: CustomHeader(title: 'Edit Profile'),
          header: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: isUploadingPhoto.value ? null : pickAndUploadPhoto,
                  child: Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.lightBlue,
                          image: (localPhotoPath.value ?? uploadedPhotoUrl.value)?.isNotEmpty == true
                              ? DecorationImage(
                                  image: localPhotoPath.value != null
                                      ? FileImage(File(localPhotoPath.value!))
                                      : NetworkImage(uploadedPhotoUrl.value!) as ImageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: (localPhotoPath.value == null && (uploadedPhotoUrl.value?.isEmpty ?? true))
                            ? Icon(CupertinoIcons.person_fill, color: context.primaryBlue, size: 36)
                            : null,
                      ),
                      if (isUploadingPhoto.value)
                        const Positioned.fill(
                          child: Center(child: CupertinoActivityIndicator()),
                        ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(CupertinoIcons.camera_fill, color: context.primaryBlue, size: 20),
                      ),
                    ],
                  ),
                ),
                const VSpace(2),
                
              
                Text(
                  'Update your name and phone number',
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
                hintText: '+977 98XXXXXXXX',
                inputType: TextInputType.phone,
                prefixIcon: const Icon(CupertinoIcons.phone_fill),
                textInputAction: TextInputAction.done,
                controller: phoneController,
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
                        context.read<ProfileBloc>().add(
                              EditProfileSubmitted(
                                name: fullNameController.text.trim(),
                              
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