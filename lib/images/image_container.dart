import 'package:connectcall/images/image_link.dart';
import 'package:flutter/material.dart';

class AppImageView extends StatelessWidget {
  final AppImageType type;
  final double height;
  final double? width;
  final BoxFit fit;

  const AppImageView({
    super.key,
    required this.type,
    this.height = 140,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width ?? double.infinity,
      child: Image.asset(
        type.assetPath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Image Asset Error: $error');

          return Icon(
            Icons.broken_image_rounded,
            size: height * 0.5,
          );
        },
      ),
    );
  }
}