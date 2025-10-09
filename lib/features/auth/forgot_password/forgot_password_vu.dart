import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vm.dart';
import 'package:dev_once_app/features/auth/otp/otp_vu.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ForgotPasswordVu extends StatefulWidget {
  const ForgotPasswordVu({super.key});

  @override
  State<ForgotPasswordVu> createState() => _ForgotPasswordVuState();
}

class _ForgotPasswordVuState extends State<ForgotPasswordVu> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        title: 'Forgot\nPassword',
        headerFraction: 0.30,
        topCornerRadius: 30,
        showBackButton: true,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: null,
        child: Form(
          key: _formKey,
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
                placeholder: 'User ID',
                prefixSvg: AppAssets.user,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.username],
                onFieldSubmitted: (_) => _onSend(),
                onSaved: context.read<ForgotPasswordVm>().onUsernameSaved,
                validator: context.read<ForgotPasswordVm>().onUsernameValidate,
              ),
              const SizedBox(height: 45),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: context.pop,
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
                      child: Consumer<ForgotPasswordVm>(
                        builder: (context, vm, _) {
                          return ElevatedButton(
                            onPressed: vm.isBusy ? null : _onSend,
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
                            child: vm.isBusy ? LoadingWidget() : const Text('Send'),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
    fit: BoxFit.contain,
  );

  Future<void> _onSend() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    final resp = await context.read<ForgotPasswordVm>().submit();

    if (resp.success) {
      // ignore: use_build_context_synchronously
      context.push(const OtpScreen());
    } else {
      // ignore: use_build_context_synchronously
      SnackbarService.showErrorSnack(context, resp.message!);
    }
  }
}
