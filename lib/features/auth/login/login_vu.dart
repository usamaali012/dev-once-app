import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vu.dart';
import 'package:dev_once_app/features/auth/login/login_vm.dart';
import 'package:dev_once_app/core/widgets/app_background.dart';
import 'package:dev_once_app/features/profile/caution/caution_vu.dart';
import 'package:dev_once_app/features/profile/view_profile/view_profile_vu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginVu extends StatefulWidget {
  const LoginVu({super.key});

  @override
  State<LoginVu> createState() => _LoginVuState();
}

class _LoginVuState extends State<LoginVu> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: AppBackground(
        title: 'Login to your\nAccount',
        headerFraction: 0.30,
        topCornerRadius: 30,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        bottomLeftDecoration: roundedBottomLeft,
        overlapGraphic: mobileIcon,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter your User ID and password to continue',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF808A93),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 50),

              // USERNAME (required; validate after touch or submit)
              AppTextField(
                placeholder: 'User ID',
                prefixSvg: AppAssets.user,
                textInputAction: TextInputAction.next,
                onSaved: context.read<LoginVm>().onUsernameSaved,
                validator: context.read<LoginVm>().onUsernameValidate,
              ),

              const SizedBox(height: 40),

              // PASSWORD (required; validate after touch or submit)
              AppTextField(
                placeholder: 'Password',
                prefixSvg: AppAssets.lock,
                isPassword: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onLogin(),
                onSaved: context.read<LoginVm>().onPasswordSaved,
                validator: context.read<LoginVm>().onPasswordValidate,
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () { 
                    context.push(ForgotPasswordVu());
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Forgot password?',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              SizedBox(
                height: 56,
                child: Consumer<LoginVm>(
                  builder: (context, vm, _) {
                    return ElevatedButton(
                      onPressed: vm.isBusy ? null : _onLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: vm.isBusy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Login'),
                    );
                  },
                ),
              ),

              const SizedBox(height: 50),

              const Column(
                children: [
                  Icon(Icons.fingerprint, size: 42, color: AppColors.secondary),
                  SizedBox(height: 12),
                  Divider(
                    thickness: 1.5,
                    color: AppColors.primary,
                    indent: 100,
                    endIndent: 100,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      color: Color(0xFF808A93),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
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

  Future<void> _onLogin() async {
    if(_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final resp = await context.read<LoginVm>().login();

      if(resp.success) {
        if (resp.message == 'caution') {
          // ignore: use_build_context_synchronously
          context.pushReplacement(CautionScreen());
        } else {
          // ignore: use_build_context_synchronously
          context.pushReplacement(ViewProfileVu());
        }
        
      } else {
        // ignore: use_build_context_synchronously
        SnackbarService.showErrorSnack(context, resp.message!);
      }
    }
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
}
