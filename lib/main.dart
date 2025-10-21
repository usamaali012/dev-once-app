import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vm.dart';
import 'package:dev_once_app/features/auth/otp/otp_vm.dart';
import 'package:dev_once_app/features/dashboard/dashboard_vm.dart';
import 'package:dev_once_app/features/profile/caution/caution_vm.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_vm.dart';
import 'package:dev_once_app/features/profile/update_bank_details/update_bank_details_vm.dart';
import 'package:dev_once_app/features/profile/update_profile/update_profile_vm.dart';
import 'package:dev_once_app/features/profile/view_profile/view_profile_vm.dart';
import 'package:dev_once_app/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:provider/provider.dart';

import 'core/constants/assets.dart';
import 'core/theme/app_colors.dart';
import 'features/auth/login/login_vu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DevOnceApp());
}

class DevOnceApp extends StatelessWidget {
  const DevOnceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginVm()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordVm()),
        ChangeNotifierProvider(create: (_) => OtpVm()),
        ChangeNotifierProvider(create: (_) => ResetPasswordVm()),
        ChangeNotifierProvider(create: (_) => CautionVm()..get()),
        ChangeNotifierProvider(create: (_) => UpdateBankDetailsVm()..get()),
        ChangeNotifierProvider(create: (_) => UpdateProfileVm()..get()),
        ChangeNotifierProvider(create: (_) => ViewProfileVm()..get()),
        ChangeNotifierProvider(create: (_) => DashboardVm()..get()),
      ],
      child: MaterialApp(
        title: 'Dev Once',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: AppFonts.supreme,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontSize: 16,
                fontFamily: AppFonts.supreme,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.grey,
              side: BorderSide(color: AppColors.grey),
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0,
                color: Color(0xFF848484)
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ),
        home: const _HomeLauncher(),
      ),
    );
  }
}

class _HomeLauncher extends StatelessWidget {
  const _HomeLauncher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev Once')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push(LoginVu());
          },
          child: const Text('Go to Login'),
        ),
      ),
    );
  }
}
