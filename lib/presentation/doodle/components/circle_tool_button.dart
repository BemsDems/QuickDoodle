import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CircleToolButton extends StatelessWidget {
  const CircleToolButton({super.key, required this.asset, required this.onTap});

  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Material(
        color: const Color(0xFF2B2B2B),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Center(child: SvgPicture.asset(asset, width: 18, height: 18)),
        ),
      ),
    );
  }
}