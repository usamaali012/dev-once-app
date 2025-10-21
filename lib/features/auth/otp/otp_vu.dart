import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vm.dart';
import 'package:dev_once_app/features/auth/otp/otp_vm.dart';
import 'package:dev_once_app/features/auth/reset_password/reset_password_vu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _digits = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<OtpVm>();
      vm.clearDigits();
      vm.startTimer();
    });
  }

  @override
  void dispose() {
    for (final c in _digits) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    // stop VM timer when leaving screen
    context.read<OtpVm>().stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final vm = context.watch<OtpVm>();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                SizedBox(height: screenHeight * 0.13),
                Text(
                  'ENTER',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: -0.7,
                    height: 0
                  ),
                ),
                Text(
                  'OTP CODE',
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
                  'Please enter the 6-digit code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.025),
                _OtpFields(
                  controllers: _digits,
                  nodes: _nodes,
                  onChanged: _onChanged,
                ),
                
                SizedBox(height: screenHeight * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive 6-digit code?",
                      style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                      ),
                    ),
                    const SizedBox(width: 6),
                    Consumer<OtpVm>(
                      builder: (context, vm, _) => Text(
                        _formatTime(vm.secondsLeft),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: ElevatedButton(
                    onPressed: vm.canResend ? _onResend : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      backgroundColor: AppColors.primary,
                      shape: const StadiumBorder(),
                      textStyle: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    child: vm.isResendBusy ? LoadingWidget() : const Text('Resend OTP'),
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.02),
                
                ElevatedButton(
                  onPressed: context.watch<OtpVm>().canVerify ? _onVerify : null,
                  child: vm.isBusy ? LoadingWidget() : const Text('Verify'),
                ),
              ],
            ),
          ),
        ],
      )
    )
  );
}

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _onChanged(int idx, String value) {
    if (value.length == 1 && idx < _nodes.length - 1) {
      _nodes[idx + 1].requestFocus();
    } else if (value.isEmpty && idx > 0) {
      _nodes[idx - 1].requestFocus();
    }
    context.read<OtpVm>().setDigit(idx, value);
  }

  void _clearInputs() {
    for (final c in _digits) {
      if (c.text.isNotEmpty) c.clear();
    }
  }

  Future<void> _onResend() async {
    final username = context.read<ForgotPasswordVm>().username;
    if (username == null || username.isEmpty) {
      SnackbarService.showWarningSnack(context, 'Missing username. Go back and try again.');
      return;
    }

    final resp = await context.read<OtpVm>().resendOtp(username);
    if (resp.success) {
      _clearInputs();
      // ignore: use_build_context_synchronously
      SnackbarService.showSuccessSnack(context, 'A new code has been sent.');
    } else {
      // ignore: use_build_context_synchronously
      SnackbarService.showErrorSnack(context, resp.message!);
    }
  }

  Future<void> _onVerify() async {
    final vm = context.read<OtpVm>();
    final code = vm.code;
    if (code.length != 6) {
      SnackbarService.showWarningSnack(context, 'Please enter the 6-digit code.');
      return;
    }

    final userId = context.read<ForgotPasswordVm>().userId;
    if (!userId.existAndNotEmpty) {
      SnackbarService.showWarningSnack(context, 'Missing verification info. Go back and try again.');
      return;
    }

    final resp = await vm.verifyOtp(userId: userId!, code: code);

    if (!mounted) return;
    if (resp.success) {
      SnackbarService.showSuccessSnack(context, 'OTP verified successfully.');
      context.push(ResetPasswordScreen());
    } else {
      SnackbarService.showErrorSnack(context, resp.message!);
    }
  }
}

class _OtpFields extends StatelessWidget {
  const _OtpFields({
    required this.controllers,
    required this.nodes,
    required this.onChanged,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> nodes;
  final void Function(int index, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    const radius = 12.0;

    InputDecoration decorationFor(int i) => const InputDecoration(
      isDense: false,
      counterText: '',
      filled: false,
      contentPadding: EdgeInsets.symmetric(vertical: 20),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = controllers.length;
        final sidePadding = constraints.maxWidth * 0.06; // 6% horizontal padding
        final usable = constraints.maxWidth - (sidePadding * 2);
        final gap = usable * 0.04;
        final boxWidth = (usable - gap * (count - 1)) / count;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(count, (i) {
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : gap),
                child: Container(
                  width: boxWidth,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08), // 8% black
                        blurRadius: 4, // Blur 4
                        spreadRadius: 0,
                        offset: Offset(0, 4), // X:0, Y:4
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controllers[i],
                    focusNode: nodes[i],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction:
                        i == count - 1 ? TextInputAction.done : TextInputAction.next,
                    maxLength: 1,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: decorationFor(i),
                    onChanged: (v) => onChanged(i, v),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
