import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/material.dart';

enum CustomButtonVariant { primary, secondary, text }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.suffixIcon,
    this.fullWidth = true,
    this.height = 48.0,
    this.variant = CustomButtonVariant.primary,
    this.borderColor,
    this.textColor,
    this.textStyle,
    this.alignment = Alignment.center,
    this.backgroundColor,
  });

  factory CustomButton.text({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    Color? textColor,
    bool isDisabled = false,
    Alignment alignment = Alignment.center,
    TextStyle? textStyle,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return CustomButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isEnabled: !isDisabled,
      variant: CustomButtonVariant.text,
      textColor: textColor,
      alignment: alignment,
      fullWidth: false,
      textStyle: textStyle,
      icon: icon,
      suffixIcon: suffixIcon,
    );
  }

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final Widget? suffixIcon;
  final bool fullWidth;
  final double height;
  final CustomButtonVariant variant;
  final Color? borderColor;
  final Color? textColor;
  final TextStyle? textStyle;
  final Alignment alignment;
  final Color? backgroundColor;

  bool get _isInteractive => isEnabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    if (variant == CustomButtonVariant.text) {
      return _buildTextButton(context);
    }

    final isPrimary = variant == CustomButtonVariant.primary;

    final effectiveTextStyle =
        textStyle ??
        context.titleSB.copyWith(
          color: textColor ?? (isPrimary ? context.white : context.primaryBlue),
        );

    final child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: isPrimary ? context.white : context.primaryBlue,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: effectiveTextStyle.color),
                const SizedBox(width: 8),
              ],
              Text(text, style: effectiveTextStyle),
              if (suffixIcon != null) ...[
                const SizedBox(width: 8),
                suffixIcon!,
              ],
            ],
          );

    final button = SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: isPrimary
          ? ElevatedButton(
              onPressed: _isInteractive ? onPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? context.primaryBlue,
                disabledBackgroundColor: (backgroundColor ?? context.primary)
                    .withOpacity(0.4),
                foregroundColor: context.white,
                elevation: 0,
                shadowColor: context.transparentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: borderColor != null
                      ? BorderSide(color: borderColor!)
                      : BorderSide.none,
                ),
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: _isInteractive ? onPressed : null,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor ?? context.primaryBlue,
                side: BorderSide(
                  color:
                      borderColor ??
                      (_isInteractive
                          ? context.primaryBlue
                          : context.hintColor.withOpacity(0.5)),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: child,
            ),
    );

    return Align(alignment: alignment, child: button);
  }

  Widget _buildTextButton(BuildContext context) {
    final effectiveTextStyle =
        textStyle ??
        context.labelMR.copyWith(
          fontWeight: FontWeight.bold,
          color: textColor ?? context.primaryBlue,
        );

    return Align(
      alignment: alignment,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? context.primaryBlue,
          disabledForegroundColor: context.hintColor,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: _isInteractive ? onPressed : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: effectiveTextStyle.color),
              const SizedBox(width: 6),
            ],
            Text(text, style: effectiveTextStyle),
            if (suffixIcon != null) ...[const SizedBox(width: 6), suffixIcon!],
          ],
        ),
      ),
    );
  }
}
