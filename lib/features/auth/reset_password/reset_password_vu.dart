import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/core/widgets/auth_background.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_vm.dart';
import 'package:dev_once_app/features/auth/otp/otp_vm.dart';
import 'package:dev_once_app/features/auth/login/login_vu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    final otpToken = context.read<OtpVm>().token;
    final resp = await context.read<ResetPasswordVm>().submit(otpToken!);

    if (!mounted) return;
    if (resp.success) {
      SnackbarService.showSuccessSnack(context, 'Your password has been reset successfully.');
      context.pushReplacement(LoginVu());
    } else {
      SnackbarService.showErrorSnack(context, resp.message ?? 'Unable to reset password. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        title: 'Create New\nPassword',
        headerFraction: 0.30,
        topCornerRadius: 30,
        showBackButton: true,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: cardGraphic,
        child: Form(
          key: _formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set a new password to log in.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),

            AppTextField(
              placeholder: 'New Password',
              prefixSvg: AppAssets.lock,
              isPassword: true,
              textInputAction: TextInputAction.next,
              onSaved: context.read<ResetPasswordVm>().onPasswordSaved,
              validator: context.read<ResetPasswordVm>().onPasswordValidate,
            ),

            const SizedBox(height: 40),

            AppTextField(
              placeholder: 'Confirm Password',
              prefixSvg: AppAssets.lock,
              isPassword: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _onSubmit(),
              onSaved: context.read<ResetPasswordVm>().onConfirmPasswordSaved,
              validator: context.read<ResetPasswordVm>().onConfirmPasswordValidate,
            ),

            const SizedBox(height: 60),

            SizedBox(
              height: 56,
              child: Consumer<ResetPasswordVm>(
                builder: (context, vm, _) {
                  return ElevatedButton(
                    onPressed: vm.isBusy ? null : _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    child: vm.isBusy ? LoadingWidget(): const Text('Reset'),
                  );
                },
              ),
            ),

            const SizedBox(height: 40),

            // Instructions
            const Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                letterSpacing: 0
              ),
            ),
            const SizedBox(height: 10),
            const _Bullet(text: 'Use at least one uppercase and lowercase letter.'),
            const _Bullet(text: 'Include at least one number or symbol.'),
            const _Bullet(text: 'Make it at least 8 characters long.'),
            const _Bullet(text: 'Ensure that both fields match.'),
            const _Bullet(text: 'Do not include spaces or the "|" character.'),
          ],
        ),
      ),
    ));
  }

  final doIcon = SvgPicture.asset(
    AppAssets.authDo,
    width: 40,
    height: 40,
    fit: BoxFit.contain,
    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
  );

  final roundedTopRight = SvgPicture.asset(
    AppAssets.authRoundedShapesVertical, 
    fit: BoxFit.contain
  );

  final cardGraphic = SvgPicture.asset(
    AppAssets.mobileIcon, fit: 
    BoxFit.contain
  );
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF626366))),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Color(0xFF626366), letterSpacing: 0),
            ),
          ),
        ],
      ),
    );
  }
}
