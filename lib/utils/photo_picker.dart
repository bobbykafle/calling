import 'dart:io';
import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoPicker extends HookWidget {
  const ProfilePhotoPicker({
    super.key,
    this.initialPhotoUrl,
    this.uploadPhoto,
    this.onUploaded,
    this.onLocalPicked,
    this.onError,
    this.size = 90,
  });

  final String? initialPhotoUrl;

  final Future<String> Function(File file)? uploadPhoto;

  final void Function(String url)? onUploaded;

  final void Function(String path)? onLocalPicked; 

  final void Function(String message)? onError;

  final double size;

  @override
  Widget build(BuildContext context) {
    final localPhotoPath = useState<String?>(null);
    final uploadedPhotoUrl = useState<String?>(initialPhotoUrl);
    final isUploading = useState(false);

    Future<void> pickPhoto() async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked == null) return;

      localPhotoPath.value = picked.path;

      if (uploadPhoto == null) {
       
        onLocalPicked?.call(picked.path);
        return;
      }

    
      isUploading.value = true;
      try {
        final url = await uploadPhoto!(File(picked.path));
        uploadedPhotoUrl.value = url;
        onUploaded?.call(url);
      } catch (_) {
        onError?.call('Could not upload photo. Try again.');
      } finally {
        isUploading.value = false;
      }
    }

    final hasImage = (localPhotoPath.value ?? uploadedPhotoUrl.value)?.isNotEmpty == true;

    return GestureDetector(
      onTap: isUploading.value ? null : pickPhoto,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.lightBlue,
              image: hasImage
                  ? DecorationImage(
                      image: localPhotoPath.value != null
                          ? FileImage(File(localPhotoPath.value!))
                          : NetworkImage(uploadedPhotoUrl.value!) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !hasImage
                ? Icon(CupertinoIcons.person_fill, color: context.primaryBlue, size: size * 0.4)
                : null,
          ),
          if (isUploading.value)
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
    );
  }
}