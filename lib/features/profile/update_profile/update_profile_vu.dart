import 'package:dev_once_app/core/constants/relationships.dart';
import 'package:dev_once_app/core/utils/app_validators.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/core/widgets/app_background.dart';

import 'update_profile_vm.dart';

class UpdateProfileVu extends StatefulWidget {
  const UpdateProfileVu({super.key});

  @override
  State<UpdateProfileVu> createState() => _UpdateProfileVuState();
}

class _UpdateProfileVuState extends State<UpdateProfileVu> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<UpdateProfileVm>().get();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UpdateProfileVm>();

    return Scaffold(
      body: AppBackground(
        title: 'Update Profile',
        headerFraction: 0.30,
        topCornerRadius: 30,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: avatarIcon,
        child: vm.isLoading
          ? Center(child: LoadingWidget(size: 30, color: AppColors.primary))
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 40,
                children: [
                  // Primary info
                  AppTextField(
                    inputLabel: 'Email*',
                    initialValue: vm.details.email,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: context.read<UpdateProfileVm>().onEmailSaved,
                    validator: context.read<UpdateProfileVm>().onEmailValidate,
                  ),
                  AppTextField(
                    inputLabel: 'Mobile No',
                    initialValue: vm.details.mobile,
                    keyboardType: TextInputType.phone,
                    onSaved: context.read<UpdateProfileVm>().onMobileSaved,
                    inputFormatters: [mobileNumberFormatter],
                  ),
                  AppTextField(
                    inputLabel: 'Address',
                    initialValue: vm.details.address,
                    onSaved: context.read<UpdateProfileVm>().onAddressSaved,
                  ),

                  Center(
                    child: Text(
                      'Details of Next of Kin',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),

                  // Kin details
                  AppTextField(
                    inputLabel: 'Next of Kin Name*',
                    initialValue: vm.details.nokName,
                    onSaved: context.read<UpdateProfileVm>().onNokNameSaved,
                    validator: context.read<UpdateProfileVm>().onNokNameValidate,
                    inputFormatters: [onlyAlphabetsFormatter],
                  ),
                  AppTextField(
                    inputLabel: 'Mobile of Kin Mobile*',
                    initialValue: vm.details.nokPhone,
                    keyboardType: TextInputType.phone,
                    onSaved: context.read<UpdateProfileVm>().onNokMobileSaved,
                    validator: context.read<UpdateProfileVm>().onNokMobileValidate,
                    inputFormatters: [mobileNumberFormatter],
                  ),
                  AppTextField(
                    inputLabel: 'Next of Kin CNIC*',
                    initialValue: vm.details.nokCnic,
                    keyboardType: TextInputType.number,
                    onSaved: context.read<UpdateProfileVm>().onNokCnicSaved,
                    validator: context.read<UpdateProfileVm>().onNokCnicValidate,
                    inputFormatters: [CNICInputFormatter()],
                  ),
                  // const SizedBox(height: 30),
                  DropdownButtonFormField<String>(
                    initialValue: vm.relation ?? vm.details.nokRelation,
                    items: relationships,
                    onChanged: context.read<UpdateProfileVm>().onRelationChanged,
                    validator: context.read<UpdateProfileVm>().onRelationValidate,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Relation with Next of Kin*',
                      filled: true,
                      fillColor: Color(0xFFF3F3F3),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: AppColors.primary, width: 1.4),
                      ),
                    ),
                  ),

                  // const SizedBox(height: 28),
                  SizedBox(
                    height: 56,
                    child: Consumer<UpdateProfileVm>(
                      builder: (context, vm, _) => ElevatedButton(
                        onPressed: vm.isBusy ? null : _onUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        child: vm.isBusy
                            ? const LoadingWidget()
                            : const Text('Update'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Future<void> _onUpdate() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState!.save();
    final resp = await context.read<UpdateProfileVm>().update();
    if (!mounted) return;
    if (resp.success) {
      SnackbarService.showSuccessSnack(context, 'Profile updated successfully.');
    } else {
      SnackbarService.showErrorSnack(context, resp.message ?? 'Unable to update profile.');
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

final roundedBottomLeft = Transform.rotate(
  angle: 3.14159,
  child: SvgPicture.asset(
    AppAssets.authRoundedShapesVertical,
    width: 120,
    height: 120,
    fit: BoxFit.contain,
  ),
);

final avatarIcon = SvgPicture.asset(
  AppAssets.mobileIcon,
  fit: BoxFit.contain,
);

