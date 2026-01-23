import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/core/config/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inset.BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          inset.BoxShadow(
            inset: true,
            offset: const Offset(0, 0),
            blurRadius: 75,
            spreadRadius: 5,
            color: Color.fromRGBO(196, 196, 196, 0.2),
          ),
          inset.BoxShadow(
            inset: true,
            offset: const Offset(0, 0),
            blurRadius: 100,
            spreadRadius: 50,
            color: Color.fromRGBO(96, 68, 144, 0.3),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          title,
          style: AppTextStyles.robotoMedium18.copyWith(color: AppColors.white),
        ),
        leading: leading,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
