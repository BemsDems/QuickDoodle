import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/core/config/app_text_styles.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.nameTextField,
    required this.hintText,
    this.obscureText = false,
    required this.textEditingController,

    this.onChanged,
    this.validator,
  });

  final String nameTextField;
  final String hintText;
  final bool obscureText;
  final TextEditingController textEditingController;
  final void Function(String)? onChanged;

  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: inset.BoxDecoration(
        border: Border.all(color: AppColors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          inset.BoxShadow(
            inset: true,
            offset: const Offset(0, 0),
            blurRadius: 40,
            spreadRadius: 0,
            color: Color.fromRGBO(227, 227, 227, 0.20),
          ),
        ],
        image: DecorationImage(
          image: AssetImage("assets/images/gradient.png"),
          fit: BoxFit.cover,
          opacity: 0.5,
          colorFilter: ColorFilter.mode(
            AppColors.bg.withValues(alpha: 0.8),
            BlendMode.darken,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              nameTextField,
              style: AppTextStyles.robotoRegular13.copyWith(
                color: AppColors.grey,
              ),
            ),
          ),
          TextFormField(
            controller: textEditingController,
            obscureText: obscureText,
            obscuringCharacter: '*',
            onChanged: onChanged,
            validator: validator,
            style: AppTextStyles.robotoRegular15.copyWith(
              color: AppColors.white,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: AppTextStyles.robotoRegular15.copyWith(
                color: AppColors.grey,
              ),
              contentPadding: EdgeInsets.only(top: 10, bottom: 2),
              constraints: BoxConstraints(),
              errorStyle: AppTextStyles.robotoRegular13.copyWith(
                color: const Color(0xFFFFA6A6).withValues(alpha: 1),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFFA6A6).withValues(alpha: 0.8),
                  width: 1,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFFA6A6).withValues(alpha: 0.8),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
