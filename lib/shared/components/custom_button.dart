import 'package:flutter/material.dart';
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/core/config/app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final bool enabled;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: enabled ? onPressed : null,
      clipBehavior: Clip.antiAlias,
      style:
          ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: AppColors.grey,
            disabledForegroundColor: AppColors.greyDark,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.grey;
              }
              if (states.contains(WidgetState.pressed)) {
                return AppColors.graysWhite.withValues(alpha: 0.14);
              }
              if (states.contains(WidgetState.hovered)) {
                return AppColors.graysWhite.withValues(alpha: 0.08);
              }
              return null;
            }),
          ),
      child: Text(title, style: AppTextStyles.robotoMedium18),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 500,
        minHeight: 50,
        maxHeight: 50,
      ),
      child: SizedBox(
        width: double.infinity,
        child: onPressed == null
            ? button
            : DecoratedBox(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  gradient: backgroundColor == null
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(137, 36, 231, 1),
                            Color.fromRGBO(106, 70, 249, 1),
                          ],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    elevatedButtonTheme: ElevatedButtonThemeData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: textColor ?? AppColors.white,
                      ),
                    ),
                  ),
                  child: button,
                ),
              ),
      ),
    );
  }
}
