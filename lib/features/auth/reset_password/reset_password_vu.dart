import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_vm.dart';
import 'package:dev_once_app/features/auth/otp/otp_vm.dart';
import 'package:dev_once_app/features/auth/login/login_vu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final vm = context.read<ResetPasswordVm>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                AppAssets.do_,
                height: screenHeight * 0.25,              
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  Text(
                    'CREATE',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -0.7,
                      height: 0
                    ),
                  ),
                  Text(
                    'PASSWORD',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                      letterSpacing: -0.7,
                      height: 0
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.01),
                  Stack(
                    children: [
                      Container(
                        height: 2,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: Container(
                          height: 2,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.09),
                  Text(
                    'Set a new password to log in.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.025),
                  AppTextField(
                    placeholder: 'New Password',
                    prefixSvg: AppAssets.lock,
                    isPassword: true,
                    textInputAction: TextInputAction.next,
                    onSaved: vm.onPasswordSaved,
                    validator: vm.onPasswordValidate,
                  ),
              
                  SizedBox(height: screenHeight * 0.04),
                  AppTextField(
                    placeholder: 'Confirm Password',
                    prefixSvg: AppAssets.lock,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onSubmit(),
                    onSaved: vm.onConfirmPasswordSaved,
                    validator: vm.onConfirmPasswordValidate,
                  ),
              
                  SizedBox(height: screenHeight * 0.06),
                  ElevatedButton(
                    onPressed: context.watch<ResetPasswordVm>().isBusy ? null : _onSubmit,
                    child: context.watch<ResetPasswordVm>().isBusy ? LoadingWidget(): const Text('Reset'),
                  ),
              
                  SizedBox(height: screenHeight * 0.07),
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      letterSpacing: 0
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.01),
                  const _Bullet(text: 'Use at least one uppercase and lowercase letter.'),
                  const _Bullet(text: 'Include at least one number or symbol.'),
                  const _Bullet(text: 'Make it at least 8 characters long.'),
                  const _Bullet(text: 'Ensure that both fields match.'),
                  const _Bullet(text: 'Do not include spaces or the "|" character.'),
                ],
              ),
                    ),
            ),
          ],
        ),
      ));
  }

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
          const Text('•  ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.grey)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.grey, letterSpacing: 0),
            ),
          ),
        ],
      ),
    );
  }
}
