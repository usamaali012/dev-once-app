import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_snackbar.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_model.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vm.dart';
import 'package:dev_once_app/features/auth/otp/otp_screen.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _userCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    if (_loading) return;
    final username = _userCtrl.text.trim();
    if (username.isEmpty) {
      showAppSnackBar(
        context,
        title: 'Missing info',
        message: 'Please enter your User ID.',
        type: ContentType.warning,
      );
      return;
    }

    setState(() => _loading = true);
    final vm = ForgotPasswordVm();
    final res = await vm.submit(ForgotPasswordRequest(username: username));
    setState(() => _loading = false);

    if (res.success) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const OtpScreen()),
      );
    } else {
      showAppSnackBar(
        context,
        title: 'Request Failed',
        message: res.message ?? 'Unable to send OTP. Try again.',
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

    final roundedTopRight = SvgPicture.asset(
      AppAssets.authRoundedShapesVertical,
      fit: BoxFit.contain,
    );

    return Scaffold(
      body: AuthBackground(
        title: 'Forgot\nPassword',
        headerFraction: 0.30,
        topCornerRadius: 30,
        showBackButton: true,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 35),
            Text(
              'Enter User ID to reset your password',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF808A93),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 55),
            AppTextField(
              controller: _userCtrl,
              placeholder: 'User ID',
              prefixSvg: AppAssets.user,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.username],
              onFieldSubmitted: (_) => _onSend(),
            ),
            const SizedBox(height: 45),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFD6D6D6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        foregroundColor: AppColors.grey,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _onSend,
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
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Send'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

