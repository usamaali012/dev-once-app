import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/core/widgets/app_snackbar.dart';
import 'package:dev_once_app/features/auth/login/data/login_api.dart';
import 'package:dev_once_app/features/auth/login/data/models/login_request.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (_loading) return;
    FocusScope.of(context).unfocus();

    final username = _userCtrl.text.trim();
    final password = _passCtrl.text;
    if (username.isEmpty || password.isEmpty) {
      showAppSnackBar(
        context,
        title: 'Missing info',
        message: 'Please enter both User ID and Password.',
        type: ContentType.warning,
      );
      return;
    }

    setState(() => _loading = true);
    final api = LoginApi();
    final res = await api.login(LoginRequest(username: username, password: password));
    setState(() => _loading = false);

    if (res.success) {
      showAppSnackBar(
        context,
        title: 'Login Successful',
        message: 'You are now signed in.',
        type: ContentType.success,
      );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your User ID and password to continue',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Color(0xFF808A93),
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                  ),
            ),
            const SizedBox(height: 50),
            AppTextField(
              controller: _userCtrl,
              placeholder: 'User ID',
              prefixSvg: AppAssets.user,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
            ),
            const SizedBox(height: 40),
            AppTextField(
              controller: _passCtrl,
              placeholder: 'Password',
              prefixSvg: AppAssets.lock,
              isPassword: true,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _onLogin(),
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
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _loading ? null : _onLogin,
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
                child: _loading
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
            ),
            const SizedBox(height: 50),
            Column(
              children: const [
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
                    fontWeight: FontWeight.w400
                  )

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
