import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vm.dart';
// import 'package:dev_once_app/features/auth/otp/otp_vu.dart';
// import 'package:dev_once_app/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
// import 'package:flutter_svg/flutter_svg.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final vm = context.read<ForgotPasswordVm>();
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

            
            Positioned(
              top: 25,
              left: 8,
              child: IconButton(
                tooltip: 'Back',
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: context.pop,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: screenHeight * 0.13),
                    Text(
                      'FORGOT',
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
                          width: 135,
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

                    SizedBox(height: screenHeight * 0.13),
                    Text(
                      'Enter User ID to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF808A93),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        letterSpacing: 0
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    AppTextField(
                      placeholder: 'User ID',
                      prefixSvg: AppAssets.user,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.username],
                      onFieldSubmitted: (_) => _onSend(),
                      onSaved: vm.onUsernameSaved,
                      validator: vm.onUsernameValidate,
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    
                    // Buttons are at the start of the row and not taking the full width, I need the width of the button to increase as well
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: context.pop,
                            child: Text('Back'),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.07),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: context.watch<ForgotPasswordVm>().isBusy ? null : _onSend, 
                            child: context.watch<ForgotPasswordVm>().isBusy ? LoadingWidget() : const Text('Send'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSend() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();

    final resp = await context.read<ForgotPasswordVm>().submit();

    if (resp.success) {
      // ignore: use_build_context_synchronously
      SnackbarService.showSuccessSnack(context, 'OTP sent successfully to your registered email.');
      // context.push(const OtpScreen());
    } else {
      // ignore: use_build_context_synchronously
      SnackbarService.showErrorSnack(context, resp.message!);
    }
  }
}
