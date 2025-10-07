import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_snackbar.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_vm.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_model.dart';
import 'package:dev_once_app/features/auth/login/login_vu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String userId;
  final String username;
  final String token; // reset token from verify-otp
  const ResetPasswordScreen({
    super.key,
    required this.userId,
    required this.username,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    final p1 = _passCtrl.text;
    final p2 = _confirmCtrl.text;
    if (p1.isEmpty || p2.isEmpty) return 'Please fill in both fields';
    if (p1.contains(' ') || p1.contains('|')) return 'Password cannot contain spaces or |';
    if (p1.length < 8) return 'Password must be at least 8 characters';
    final hasUpper = p1.contains(RegExp(r'[A-Z]'));
    final hasLower = p1.contains(RegExp(r'[a-z]'));
    final hasNumOrSym = p1.contains(RegExp(r'[0-9!@#\$%^&*(),.?":{}|<>_+\-]'));
    if (!hasUpper || !hasLower) return 'Use at least one uppercase and lowercase letter';
    if (!hasNumOrSym) return 'Include at least one number or symbol';
    if (p1 != p2) return 'Passwords do not match';
    return null;
  }

  Future<void> _onSubmit() async {
    if (_submitting) return;
    final error = _validate();
    if (error != null) {
      showAppSnackBar(
        context,
        title: 'Invalid Password',
        message: error,
        type: ContentType.warning,
      );
      return;
    }

    setState(() => _submitting = true);
    final vm = ResetPasswordVm();
    final req = ResetPasswordRequest(token: widget.token, newPassword: _passCtrl.text);
    final res = await vm.submit(req);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (res.success) {
      showAppSnackBar(
        context,
        title: 'Password Updated',
        message: 'Your password has been reset successfully.',
        type: ContentType.success,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginVu()),
          (route) => false,
        );
      });
    } else {
      showAppSnackBar(
        context,
        title: 'Reset Failed',
        message: res.message ?? 'Unable to reset password. Please try again.',
        type: ContentType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final doIcon = SvgPicture.asset(
      AppAssets.authDo,
      width: 40,
      height: 40,
      fit: BoxFit.contain,
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );

    final roundedTopRight =
        SvgPicture.asset(AppAssets.authRoundedShapesVertical, fit: BoxFit.contain);

    final cardGraphic = SvgPicture.asset(AppAssets.mobileIcon, fit: BoxFit.contain);

    return Scaffold(
      body: AuthBackground(
        title: 'Create New\nPassword',
        headerFraction: 0.30,
        topCornerRadius: 30,
        showBackButton: true,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: cardGraphic,
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
              controller: _passCtrl,
              placeholder: 'New Password',
              prefixSvg: AppAssets.lock,
              isPassword: true,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.newPassword],
            ),

            const SizedBox(height: 40),

            AppTextField(
              controller: _confirmCtrl,
              placeholder: 'Confirm Password',
              prefixSvg: AppAssets.lock,
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => _onSubmit(),
            ),

            const SizedBox(height: 60),

            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _submitting ? null : _onSubmit,
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
                child: _submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Reset'),
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
    );
  }
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
