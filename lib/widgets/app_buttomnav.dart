import 'package:connectcall/utils/build_context.dart';
import 'package:flutter/cupertino.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<({IconData icon, String label})> _navItems = [
    (icon: CupertinoIcons.house_fill, label: 'Home'),
    (icon: CupertinoIcons.person, label: 'Contact'),
    (icon: CupertinoIcons.square_grid_2x2, label: 'Calls'),
    (icon: CupertinoIcons.gear, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final activeColor = context.primary;
    final inactiveColor = context.onSurface.withOpacity(0.6);
    final navBarBgColor = context.surface;

    return Container(
      color: context.surface,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final itemWidth = totalWidth / _navItems.length;

          const bubbleSize = 60.0;

          final leftOffset =
              (itemWidth * currentIndex) +
              (itemWidth - bubbleSize) / 2;

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 65,
                decoration: BoxDecoration(
                  color: navBarBgColor,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: context.onSurface.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: context.primaryBlue.withOpacity(0.06),
                  ),
                ),
                child: Row(
                  children: List.generate(
                    _navItems.length,
                    (index) {
                      final item = _navItems[index];
                      final isSelected = currentIndex == index;

                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedOpacity(
                                duration: const Duration(
                                  milliseconds: 200,
                                ),
                                opacity: isSelected ? 0.0 : 1.0,
                                child: Icon(
                                  item.icon,
                                  color: inactiveColor,
                                  size: 24,
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                item.label,
                                style: TextStyle(
                                  color: isSelected
                                      ? activeColor
                                      : inactiveColor,
                                  fontSize: 11,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Floating selected icon
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutBack,
                left: leftOffset,
                bottom: 12,
                child: IgnorePointer(
                  child: Container(
                    width: bubbleSize,
                    height: bubbleSize,
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: navBarBgColor,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: activeColor.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _navItems[currentIndex].icon,
                      color: context.onPrimary,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}