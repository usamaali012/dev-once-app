import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_background.dart';
import 'package:dev_once_app/core/widgets/app_image_picker.dart';
// import 'package:dev_once_app/core/widgets/app_image_picker.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
// import 'widgets/profile_header_card.dart';

import 'view_profile_vm.dart';

class ViewProfileVu extends StatefulWidget {
  const ViewProfileVu({super.key});

  @override
  State<ViewProfileVu> createState() => _ViewProfileVuState();
}

class _ViewProfileVuState extends State<ViewProfileVu> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<ViewProfileVm>();

    return Scaffold(
      body: AppBackground(
        title: 'View Profile',
        headerFraction: 0.25,
        topCornerRadius: 30,
        leading: _doIcon,
        topRightDecoration: _roundedTopRight,
        overlapGraphic: ImageWidget(size: 40, url: vm.details.profileImageCompleteUrl),
        // overlapGraphic: ProfileHeaderCard(name: vm.details.name ?? '', avatarUrl: vm.details.profileImageCompleteUrl),
        showBackButton: true,
        child: context.watch<ViewProfileVm>().isBusy
            ? Center(child: LoadingWidget(size: 30, color: AppColors.primary))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 30,
                children: [
                  AppTextField(
                    inputLabel: vm.details.husbandName != null ? 'Husband Name' : 'Father Name',
                    initialValue: vm.details.husbandName ?? vm.details.fatherName,
                    readOnly: true,
                  ),
                  AppTextField(
                    inputLabel: 'Email',
                    initialValue: vm.details.email,
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppTextField(
                    inputLabel: 'Mobile',
                    initialValue: vm.details.mobile,
                    readOnly: true,
                    keyboardType: TextInputType.phone,
                  ),
                  AppTextField(
                    inputLabel: 'CNIC',
                    initialValue: vm.details.cnic,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                  ),
                  AppTextField(
                    inputLabel: 'Address',
                    initialValue: vm.details.address,
                    readOnly: true,
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

                  // Next of kin (read-only)
                  AppTextField(
                    inputLabel: 'Next of Kin Name',
                    initialValue: vm.details.nokName,
                    readOnly: true,
                  ),
                  AppTextField(
                    inputLabel: 'Mobile of Kin Mobile',
                    initialValue: vm.details.nokPhone,
                    readOnly: true,
                    keyboardType: TextInputType.phone,
                  ),
                  AppTextField(
                    inputLabel: 'Next of Kin CNIC',
                    initialValue: vm.details.nokCnic,
                    readOnly: true,
                    keyboardType: TextInputType.number,
                  ),
                  AppTextField(
                    inputLabel: 'Relation with Next of Kin',
                    initialValue: vm.details.nokRelation,
                    readOnly: true,
                  ),

                  Center(
                    child: Text(
                      'Bank Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),

                  // Bank details (read-only)
                  AppTextField(
                    inputLabel: 'Account Title',
                    initialValue: vm.details.accountTitle,
                    readOnly: true,
                  ),
                  AppTextField(
                    inputLabel: 'Account Number',
                    initialValue: vm.details.accountNumber,
                    readOnly: true,
                  ),
                  AppTextField(
                    inputLabel: 'IBAN Number',
                    initialValue: vm.details.ibanNumber,
                    readOnly: true,
                  ),
                  AppTextField(
                    inputLabel: 'Bank Name',
                    initialValue: vm.details.bankName,
                    readOnly: true,
                  ),
                  AppTextField(
                    inputLabel: 'Account Ownership',
                    initialValue: vm.details.ownership,
                    readOnly: true,
                  ),

                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

final _doIcon = SvgPicture.asset(
  AppAssets.authDo,
  width: 40,
  height: 40,
  fit: BoxFit.contain,
  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
);

final _roundedTopRight = SvgPicture.asset(
  AppAssets.authRoundedShapesVertical,
  fit: BoxFit.contain,
);

