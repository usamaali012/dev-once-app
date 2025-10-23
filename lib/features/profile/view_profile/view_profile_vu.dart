import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/util_service.dart';
import 'package:dev_once_app/core/widgets/app_image_picker.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/core/widgets/app_text_field_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:provider/provider.dart';

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
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 8,
              child: Row(
                spacing: 12,
                children: [
                  IconButton(
                    tooltip: 'Back',
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: context.pop,
                  ),
                  Text(
                    'View Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            context.watch<ViewProfileVm>().isBusy
              ? Center(child: LoadingWidget(size: 30, color: AppColors.primary))
              : Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 30,
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    _ProfileSummaryCard(
                      name: vm.details.name ?? '', 
                      date: vm.details.enrollmentDate ?? 0, 
                      imgUrl: vm.details.profileImageCompleteUrl ?? ''
                    ),
                    
                    AppTextFieldV2(
                      placeholder: vm.details.husbandName != null ? 'Husband Name' : 'Father Name',
                      initialValue: vm.details.husbandName ?? vm.details.fatherName,
                      readOnly: true,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Email',
                      initialValue: vm.details.email,
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Mobile',
                      initialValue: vm.details.mobile,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                    ),
                    AppTextFieldV2(
                      placeholder: 'CNIC',
                      initialValue: vm.details.cnic,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Address',
                      initialValue: vm.details.address,
                      readOnly: true,
                    ),
                        
                    Text(
                      'Details of Next of Kin',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                        
                    AppTextFieldV2(
                      placeholder: 'Next of Kin Name',
                      initialValue: vm.details.nokName,
                      readOnly: true,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Mobile of Kin Mobile',
                      initialValue: vm.details.nokPhone,
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Next of Kin CNIC',
                      initialValue: vm.details.nokCnic,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Relation with Next of Kin',
                      initialValue: vm.details.nokRelation,
                      readOnly: true,
                    ),
                        
                    Text(
                      'Bank Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                        
                    AppTextFieldV2(
                      placeholder: 'Account Title',
                      initialValue: vm.details.accountTitle,
                      readOnly: true,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Account Number',
                      initialValue: vm.details.accountNumber,
                      readOnly: true,
                    ),
                    AppTextFieldV2(
                      placeholder: 'IBAN Number',
                      initialValue: vm.details.ibanNumber,
                      readOnly: true,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Bank Name',
                      initialValue: vm.details.bankName,
                      readOnly: true,
                    ),
                    AppTextFieldV2(
                      placeholder: 'Account Ownership',
                      initialValue: vm.details.ownership,
                      readOnly: true,
                    ),
                        
                    ElevatedButton(
                      onPressed: context.pop,
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  final String name;
  final int date;
  final String imgUrl;

  const _ProfileSummaryCard({
    required this.name,
    required this.date,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF01E3D8),
                  Color(0xFF0E667B),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
          ),

          // Inner white panel for text
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(left: 87, right: 15, top: 15, bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.06),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          'Member Since',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('│', style: TextStyle(color: Color(0xFFE0E0E0))),
                        SizedBox(width: 8),
                        Text(
                          Utils.formateDateTimeStamp(date),
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Avatar card overlapping on the left
          Positioned(
            left: 15,
            top: 15,
            bottom: 15,
            child: Container(
              width: 85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.08),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: ImageWidget(url: imgUrl,),
            ),
          ),
        ],
      ),
    );
  }
}
