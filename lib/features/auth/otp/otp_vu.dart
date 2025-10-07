import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/services/api/api_client.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_snackbar.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_model.dart';
import 'package:dev_once_app/features/auth/forgot_password/forgot_password_vm.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OtpScreen extends StatefulWidget {
  final String userId;
  final String username;
  const OtpScreen({super.key, required this.userId, required this.username});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _digits =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _seconds = 120;
  bool _resending = false;
  bool _verifying = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    for (final c in _digits) c.dispose();
    for (final n in _nodes) n.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 120);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        if (mounted) setState(() => _seconds = 0);
      } else {
        if (mounted) setState(() => _seconds -= 1);
      }
    });
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
    setState(() {});
  }

  Future<void> _onResend() async {
    if (_resending) return;
    setState(() => _resending = true);
    final vm = ForgotPasswordVm();
    final res = await vm.submit(
      ForgotPasswordRequest(username: widget.username),
    );
    if (!mounted) return;
    setState(() => _resending = false);
    if (res.success) {
      _startTimer();
      showAppSnackBar(
        context,
        title: 'OTP Sent',
        message: 'A new code has been sent.',
        type: ContentType.success,
      );
    } else {
      showAppSnackBar(
        context,
        title: 'Failed',
        message: res.message ?? 'Unable to resend OTP.',
        type: ContentType.failure,
      );
    }
  }

  Future<void> _onVerify() async {
    if (_verifying) return;
    final code = _digits.map((e) => e.text).join();
    if (code.length != 6) {
      showAppSnackBar(
        context,
        title: 'Invalid Code',
        message: 'Please enter the 6-digit code.',
        type: ContentType.warning,
      );
      return;
    }

    setState(() => _verifying = true);
    final client = ApiClient();
    final res = await client.post<Map<String, dynamic>>(
      RequestConfig<Map<String, dynamic>>(
        endpoint: '/auth/verify-otp',
        request: {
          'user_id': widget.userId,
          'otp_code': code,
        },
      ),
    );
    if (!mounted) return;
    setState(() => _verifying = false);

    if (res.success) {
      final token =
          (res.data?['access_token'] ?? res.data?['token'])?.toString() ?? '';
      if (token.isNotEmpty) client.setAuthToken(token);
      showAppSnackBar(
        context,
        title: 'Verified',
        message: 'OTP verified successfully.',
        type: ContentType.success,
      );
    } else {
      showAppSnackBar(
        context,
        title: 'Verification Failed',
        message: res.message ?? 'Please check the code and try again.',
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
    final roundedTopRight =
        SvgPicture.asset(AppAssets.authRoundedShapesVertical, fit: BoxFit.contain);
    final mobileIcon = SvgPicture.asset(AppAssets.mobileIcon, fit: BoxFit.contain);

    return Scaffold(
      body: AuthBackground(
        title: 'Enter\nOTP Code',
        headerFraction: 0.30,
        topCornerRadius: 30,
        showBackButton: true,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: mobileIcon,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            Text(
              'Please enter the 6-digit code',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 18),
            _OtpFields(
              controllers: _digits,
              nodes: _nodes,
              onChanged: _onChanged,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive 6-digit code?",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_seconds),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Center(
              child: SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: _seconds == 0 && !_resending ? _onResend : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    backgroundColor: AppColors.primary,
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  child: _resending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Resend OTP'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _verifying ? null : _onVerify,
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
                child: _verifying
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
          ],
        ),
      ),
    );
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
    const radius = 14.0;

    InputDecoration decorationFor(int i) => InputDecoration(
          isDense: false,
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFF3F3F3),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide.none,
          ),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final count = controllers.length;
        final sidePadding = constraints.maxWidth * 0.06; // 6% horizontal padding
        final usable = constraints.maxWidth - (sidePadding * 2);
        final gap = usable * 0.02; // 2% gaps between boxes
        final boxWidth = (usable - gap * (count - 1)) / count;
        const boxHeight = 68.0; // taller boxes

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: sidePadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(count, (i) {
              return Padding(
                padding: EdgeInsets.only(left: i == 0 ? 0 : gap),
                child: SizedBox(
                  width: boxWidth,
                  height: boxHeight,
                  child: TextField(
                    controller: controllers[i],
                    focusNode: nodes[i],
                    textAlign: TextAlign.center,
                    textAlignVertical: TextAlignVertical.center,
                    style:
                        const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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

