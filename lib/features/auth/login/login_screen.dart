import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doIcon = SvgPicture.asset(
      AppAssets.authDo,
      width: 40,
      height: 40,
      fit: BoxFit.contain,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );

    final roundedTopRight = SvgPicture.asset(
      AppAssets.authRoundedShapesVertical,
      fit: BoxFit.contain,
    );

    final mobileIcon = SvgPicture.asset(
      AppAssets.mobileIcon,
      fit: BoxFit.contain,
    );

    final roundedBottomLeft = Transform.rotate(
      angle: 3.14159,
      child: SvgPicture.asset(
        AppAssets.authRoundedShapesVertical,
        width: 120,
        height: 120,
        fit: BoxFit.contain,
      ),
    );

    return Scaffold(
      body: AuthBackground(
        title: 'Login to your\nAccount',
        headerFraction: 0.30,
        topCornerRadius: 30,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        bottomLeftDecoration: roundedBottomLeft,
        overlapGraphic: mobileIcon,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your User ID and password to continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Color(0xFF808A93),
                  ),
            ),
            const SizedBox(height: 24),
            const AppTextField(
              placeholder: 'User ID',
              prefixIcon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            const AppTextField(
              placeholder: 'Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: AppColors.grey,
                ),
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                child: const Text('Login'),
              ),
            ),
            const SizedBox(height: 24),
            Column(
              children: const [
                Icon(Icons.fingerprint, size: 42, color: AppColors.secondary),
                SizedBox(height: 12),
                Divider(
                  thickness: 1.2,
                  color: AppColors.primary,
                  indent: 120,
                  endIndent: 120,
                ),
                SizedBox(height: 12),
                Text('Privacy Policy'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
