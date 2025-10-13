import 'package:dev_once_app/core/constants/bank_names.dart';
import 'package:dev_once_app/core/constants/relationships.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/core/widgets/app_background.dart';

import 'update_bank_details_vm.dart';

class UpdateBankDetailsVu extends StatefulWidget {
  const UpdateBankDetailsVu({super.key});

  @override
  State<UpdateBankDetailsVu> createState() => _UpdateBankDetailsVuState();
}

class _UpdateBankDetailsVuState extends State<UpdateBankDetailsVu> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<UpdateBankDetailsVm>();

    return Scaffold(
      body: AppBackground(
        title: 'Update Bank Details',
        headerFraction: 0.20,
        topCornerRadius: 30,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        // overlapGraphic: mobileIcon,
        showBackButton: true,
        child: context.watch<UpdateBankDetailsVm>().isLoading
          ? Center(
              child: LoadingWidget(size: 30, color: AppColors.primary),
            )
          : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // Fields card section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 30,
                      children: [
                        AppTextField(
                          inputLabel: 'Account Title',
                          initialValue: vm.details.accountTitle,
                          onSaved: context.read<UpdateBankDetailsVm>().onAccountTitleSaved,
                        ),
                        
                        AppTextField(
                          inputLabel: 'Account Number',
                          initialValue: vm.details.accountNumber,
                          keyboardType: TextInputType.number,
                          onSaved: context.read<UpdateBankDetailsVm>().onAccountNumberSaved,
                        ),
                        
                        AppTextField(
                          inputLabel: 'IBAN Number*',
                          initialValue: vm.details.ibanNumber,
                          onSaved: context.read<UpdateBankDetailsVm>().onIbanSaved,
                          validator: context.read<UpdateBankDetailsVm>().onIbanValidate,
                        ),
                        
                        DropdownButtonFormField<String>(
                          initialValue: vm.details.bankName,
                          items: bankNames,
                          onChanged: vm.onBankNameChanged,
                          isExpanded: true,
                          decoration: const InputDecoration(
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
                        
                        DropdownButtonFormField<String>(
                          initialValue: vm.details.ownership,
                          items: relationships,
                          onChanged: vm.onOwnershipChanged,
                          decoration: const InputDecoration(
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
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 56,
                      child: Consumer<UpdateBankDetailsVm>(
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

    final resp = await context.read<UpdateBankDetailsVm>().update();
    if (!mounted) return;
    if (resp.success) {
      SnackbarService.showSuccessSnack(context, 'Bank details updated successfully.');
    } else {
      SnackbarService.showErrorSnack(context, resp.message ?? 'Unable to update bank details.');
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
}