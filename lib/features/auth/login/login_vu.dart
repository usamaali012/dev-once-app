import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/core/widgets/app_snackbar.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vu.dart';
import 'package:dev_once_app/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginVm(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();

  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _userFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _submitted = false;
  bool _userTouched = false;
  bool _passTouched = false;

  @override
  void initState() {
    super.initState();
    _userFocus.addListener(() {
      if (_userFocus.hasFocus) {
        setState(() => _userTouched = true);
      }
    });
    _passFocus.addListener(() {
      if (_passFocus.hasFocus) {
        setState(() => _passTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    _userFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  String? _validateUser(String? v) {
    // Show error only if user has interacted with this field OR form was submitted
    if (!_userTouched && !_submitted) return null;
    if (v == null || v.trim().isEmpty) return 'User ID is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _validatePass(String? v) {
    if (!_passTouched && !_submitted) return null;
    if (v == null || v.isEmpty) return 'Password is required';
    // if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  Future<void> _onLogin() async {
    FocusScope.of(context).unfocus();

    setState(() => _submitted = true); // allow all errors to show on submit
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      return;
    }

    final vm = context.read<LoginVm>();
    if (vm.loading) return;

    final res = await vm.login(
      username: _userCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;

    if (res.success) {
      showAppSnackBar(
        context,
        title: 'Login Successful',
        message: 'You are now signed in.',
        type: ContentType.success,
      );
      // Navigator.pushReplacement(...);
    } else {
      showAppSnackBar(
        context,
        title: 'Login Failed',
        message: res.message ?? 'Something went wrong. Please try again.',
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
        child: Form(
          key: _formKey,
          // Keep the whole form from autovalidating everything up front.
          // We control visibility via touched + submitted flags.
          autovalidateMode: AutovalidateMode.disabled,
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
                controller: _userCtrl,
                placeholder: 'User ID',
                prefixSvg: AppAssets.user,
                textInputAction: TextInputAction.next,
                focusNode: _userFocus,
                validator: _validateUser,
                onChanged: (_) {
                  if (!_userTouched) setState(() => _userTouched = true);
                },
              ),

              const SizedBox(height: 40),

              // PASSWORD (required; validate after touch or submit)
              AppTextField(
                controller: _passCtrl,
                placeholder: 'Password',
                prefixSvg: AppAssets.lock,
                isPassword: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onLogin(),
                focusNode: _passFocus,
                validator: _validatePass,
                onChanged: (_) {
                  if (!_passTouched) setState(() => _passTouched = true);
                },
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
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

              // BUTTON: only this rebuilds on loading
              SizedBox(
                height: 56,
                child: Selector<LoginVm, bool>(
                  selector: (_, vm) => vm.loading,
                  builder: (context, loading, _) {
                    return ElevatedButton(
                      onPressed: loading ? null : _onLogin,
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
                      child: loading
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
}
