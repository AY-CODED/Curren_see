import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CSHeader extends StatelessWidget {
  final String title;
  final String? eyebrow;
  final Widget? leading;
  final List<Widget>? actions;
  final bool large;

  const CSHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.leading,
    this.actions,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 14, 22, large ? 4 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              if (!large)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (eyebrow != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            eyebrow!.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.98,
                              color: AppColors.gold,
                            ),
                          ),
                        ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          letterSpacing: -0.4,
                          color: AppColors.ink,
                          height: 1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              else
                const Spacer(),
              if (actions != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!
                      .map((a) => Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: a,
                          ))
                      .toList(),
                ),
            ],
          ),
          if (large) ...[
            const SizedBox(height: 18),
            if (eyebrow != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  eyebrow!.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.98,
                    color: AppColors.gold,
                  ),
                ),
              ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 38,
                letterSpacing: -0.95,
                color: AppColors.ink,
                height: 1,
              ),
            ),
            const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class IconBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool badge;

  const IconBtn({
    super.key,
    required this.child,
    this.onTap,
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface,
          border: Border.all(color: AppColors.hairline),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            IconTheme(
              data: const IconThemeData(color: AppColors.ink2, size: 18),
              child: child,
            ),
            if (badge)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bg, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
