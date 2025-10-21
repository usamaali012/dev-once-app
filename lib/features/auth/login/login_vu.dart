import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
// import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vu.dart';
import 'package:dev_once_app/features/auth/login/login_vm.dart';
// import 'package:dev_once_app/features/dashboard/dashboard_vu.dart';
// import 'package:dev_once_app/features/profile/caution/caution_vu.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final vm = context.watch<LoginVm>();
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
                  SizedBox(height: screenHeight * 0.13),
                  Text(
                    'ACCESS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: -0.7,
                      height: 0
                    ),
                  ),
                  Text(
                    'ACCOUNT',
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
                    'Enter your User ID and password \n to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                
                  SizedBox(height: screenHeight * 0.03),
                  AppTextField(
                    placeholder: 'User ID',
                    prefixSvg: AppAssets.user,
                    textInputAction: TextInputAction.next,
                    onSaved: context.read<LoginVm>().onUsernameSaved,
                    validator: context.read<LoginVm>().onUsernameValidate,
                  ),

                  SizedBox(height: screenHeight * 0.04),
                  AppTextField(
                    placeholder: 'Password',
                    prefixSvg: AppAssets.lock,
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onLogin(),
                    onSaved: context.read<LoginVm>().onPasswordSaved,
                    validator: context.read<LoginVm>().onPasswordValidate,
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () { 
                        // context.push(ForgotPasswordVu());
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                  ElevatedButton(
                    onPressed: vm.isBusy ? null : _onLogin, 
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
                  ),
                  
                  SizedBox(height: screenHeight * 0.055 ),
                  Column(
                    children: [
                      Icon(Icons.fingerprint, size: 52, color: Color(0xFF636E7C)),
                      SizedBox(height: screenHeight * 0.025),
                      Divider(
                        thickness: 1,
                        color: AppColors.grey,
                        indent: 100,
                        endIndent: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 18,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ]
              ),
            ),
            )
          ],
        ),
      )
    );
  }

  Future<void> _onLogin() async {
    if(_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final resp = await context.read<LoginVm>().login();

      if(resp.success) {
        if (resp.message == 'caution') {
          // ignore: use_build_context_synchronously
          // context.pushReplacement(CautionScreen());
        } else {
          // ignore: use_build_context_synchronously
          // context.pushReplacement(DashboardVu());
        }
        
      } else {
        // ignore: use_build_context_synchronously
        SnackbarService.showErrorSnack(context, resp.message!);
      }
    }
  }
}
