import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quick_doodle/core/config/app_colors.dart';
import 'package:quick_doodle/core/config/app_text_styles.dart';
import 'package:quick_doodle/core/config/navigation/app_routes.dart';
import 'package:quick_doodle/presentation/auth/controller/auth_controller.dart';
import 'package:quick_doodle/presentation/gallery/components/cached_doodle_image.dart';
import 'package:quick_doodle/presentation/gallery/provider/doodles_provider.dart';
import 'package:quick_doodle/shared/components/custom_app_bar.dart';
import 'package:quick_doodle/shared/components/custom_button.dart';
import 'package:quick_doodle/shared/components/custom_scaffold.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doodlesAsync = ref.watch(doodlesProvider);

    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Галерея',
        leading: IconButton(
          onPressed: () async {
            final isLogout = await _confirmLogout(context);
            if (isLogout) {
              ref.exists(doodlesProvider);
              ref.invalidate(doodleCacheProvider);
              await ref.read(authControllerProvider.notifier).signOut();
              Navigator.pushReplacementNamed(context, AppRoutes.signIn);
            }
          },
          icon: SvgPicture.asset('assets/icons/logout.svg'),
        ),
        actions: (doodlesAsync.value?.isNotEmpty ?? false)
            ? [
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.doodle),
                  icon: SvgPicture.asset('assets/icons/paint_roller.svg'),
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: doodlesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.robotoRegular15.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  title: 'Попробовать снова',
                  onPressed: () {
                    ref.invalidate(doodlesProvider, asReload: true);
                  },
                ),
              ],
            );
          },
          data: (items) {
            if (items.isEmpty) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  title: 'Создать',
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.doodle),
                ),
              );
            }
            return Column(
              children: [
                const SizedBox(height: 35),
                Expanded(
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                    itemBuilder: (context, index) {
                      final doodle = items[index];
                      return GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.doodle,
                          arguments: doodle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 160,
                            width: double.infinity,
                            child: CachedDoodleImage(doodle: doodle),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> _confirmLogout(BuildContext context) async {
    final style = AppTextStyles.robotoRegular15.copyWith(
      color: AppColors.white,
    );
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromRGBO(16, 18, 24, 1),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text('Выход', textAlign: TextAlign.center, style: style),
        content: Text(
          'Выйти из аккаунта?',
          textAlign: TextAlign.center,
          style: style,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: 'Отмена',
                  backgroundColor: AppColors.white,
                  textColor: AppColors.greyDark,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  title: 'Выйти',
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
