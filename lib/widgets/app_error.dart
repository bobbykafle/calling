import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/material.dart';

class AppTErrorNotification {
  static void show(
    BuildContext context, {
    required String message,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0.0,
              end: 1.0,
            ),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  -20 * (1 - value),
                ),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                color: context.error.withOpacity(0.12),

                borderRadius: BorderRadius.circular(14),

                border: Border.all(
                  color: context.error,
                  width: 1.5,
                ),

                boxShadow: [
                  BoxShadow(
                    color: context.error.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active_rounded,
                    color: context.error,
                    size: 22,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      message,
                      style: context.labelMB.copyWith(
                        color: context.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (overlayEntry.mounted) {
                        overlayEntry.remove();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: context.onSurface,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (overlayEntry.mounted) {
          overlayEntry.remove();
        }
      },
    );
  }
}