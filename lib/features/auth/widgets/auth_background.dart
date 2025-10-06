import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Reusable auth layout with responsive header and a rounded white sheet.
class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.title,
    required this.child,
    this.headerFraction = 0.30, // 30% of safe screen height
    this.topCornerRadius = 27,
    this.leading,                 // e.g., DO icon
    this.topRightDecoration,      // e.g., rounded shapes svg
    this.bottomLeftDecoration,
    this.overlapGraphic,          // e.g., phone svg overlapping the sheet
    this.showTopDivider = false,
    this.showBackButton = false,
    this.backIconColor = Colors.white,
    this.onBack,
  });

  final String title;
  final Widget child;
  final double headerFraction;
  final double topCornerRadius;
  final Widget? leading;
  final Widget? topRightDecoration;
  final Widget? bottomLeftDecoration;
  final Widget? overlapGraphic;
  final bool showTopDivider;
  final bool showBackButton;
  final Color backIconColor;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final safeHeight = size.height - mq.padding.top - mq.padding.bottom;

    final headerHeight = (safeHeight * headerFraction).clamp(180.0, 360.0);
    const sheetTopOverlap = 12.0;       // small overlap to “kiss” the header
    final overlapOffset = size.height * 0.06; // protrusion height if overlapGraphic is used
    final topSafe = mq.padding.top;      // status bar height for proper positioning

    // Always expand to the full available size so we don't depend on
    // ancestor constraints being tight (avoids partial-height scenarios).
    return SizedBox.expand(
      child: ColoredBox(                 // base layer prevents Scaffold bg showing through
        color: AppColors.secondary,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
          // 1) Teal header (positioned with explicit height)
          Positioned(
            top: topSafe,
            left: 0,
            right: 0,
            height: headerHeight,
            child: Container(
              color: AppColors.secondary,
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Leading area (bottom-left, 50% width)
                SizedBox(
                  width: size.width * 0.50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (leading != null)
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: size.width * 0.50,
                            child: FittedBox(
                              alignment: Alignment.bottomLeft,
                              fit: BoxFit.contain,
                              child: leading!,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Title + top-right decoration
                Expanded(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            title,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                      if (topRightDecoration != null)
                        Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            height: size.height * 0.10,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: topRightDecoration!,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
          // 2) Curved white sheet (hard clipped, padded)
          Positioned.fill(
            top: topSafe + headerHeight - sheetTopOverlap,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft:  Radius.circular(topCornerRadius),
                topRight: Radius.circular(topCornerRadius),
              ),
              child: Material(
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                child: SafeArea( // keep status bar safe if sheet goes to very top on tiny screens
                  top: false,
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      size.width * 0.06,
                      (overlapGraphic != null ? overlapOffset : 0) + 20,
                      size.width * 0.06,
                      size.height * 0.04,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (showTopDivider)
                          Center(
                            child: Container(
                              width: size.width * 0.36,
                              height: 2,
                              decoration: BoxDecoration(
                                color: AppColors.grey.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        child,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3) Overlap graphic (sits above the sheet, so it won't be clipped)
          if (overlapGraphic != null)
            Positioned(
              // top: topSafe + (headerHeight - sheetTopOverlap) - overlapOffset,
              top: topSafe + (headerHeight - sheetTopOverlap) - overlapOffset,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: size.width * 0.28,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: overlapGraphic!,
                  ),
                ),
              ),
            ),

          if (bottomLeftDecoration != null)
            Positioned(
              bottom: 0,
              left: 0,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  height: size.height * 0.10,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: bottomLeftDecoration,
                  ),
                ),
              ),
            ),

          if (showBackButton)
            Positioned(
              top: topSafe + 8,
              left: 8,
              child: IconButton(
                tooltip: 'Back',
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: backIconColor),
                onPressed: onBack ?? () {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) navigator.maybePop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
