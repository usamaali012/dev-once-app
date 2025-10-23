// import 'package:dev_once_app/core/constants/relationships.dart';
import 'package:dev_once_app/core/utils/app_validators.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/features/profile/caution/caution_model.dart';
import 'package:flutter/material.dart';
import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field_v2.dart';
import 'package:dev_once_app/features/profile/caution/caution_vm.dart';
import 'package:provider/provider.dart';

class CautionScreen extends StatefulWidget {
  const CautionScreen({super.key});

  @override
  State<CautionScreen> createState() => _CautionScreenState();
}

class _CautionScreenState extends State<CautionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final vm = context.read<CautionVm>();
    MandatoryInfo initialData = vm.data;
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
                      'MANDATORY',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: -0.7,
                        height: 0
                      ),
                    ),
                    Text(
                      'INFORMATION',
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
                      'Enter the details below to open \nthe dashboard.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    context.watch<CautionVm>().isLoading 
                    ? Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: SizedBox.square(
                        dimension: 30,
                        child: LoadingWidget(size: 30, color: AppColors.primary),
                      ),
                    ) 
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Selector<CautionVm, int>(
                          selector: (_, vm) => vm.guardianType,
                          builder: (context, guardianType, _) {
                            final onChanged = context.read<CautionVm>().onGuardianTypeChanged; // handler doesn't trigger rebuilds
                            return Row(
                              children: [
                                Expanded(
                                  child: _CompactRadio<int>(
                                    label: 'Father Name',
                                    value: 0,
                                    groupValue: guardianType,      // ← comes from Selector (listens)
                                    onChanged: onChanged,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: _CompactRadio<int>(
                                    label: 'Husband Name',
                                    value: 1,
                                    groupValue: guardianType,
                                    onChanged: onChanged,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        
                        AppTextFieldV2(
                          initialValue: vm.guardianType == 1 ? initialData.husbandName : initialData.fatherName,
                          placeholder: vm.guardianLabel,
                          onSaved: context.read<CautionVm>().onGuardianSaved,
                          validator: context.read<CautionVm>().onGuardianValidate,
                          inputFormatters: [onlyAlphabetsFormatter],
                        ),
                        const SizedBox(height: 16),
                        
                        AppTextFieldV2(
                          initialValue: initialData.mobile,
                          label: 'Mobile No.*',
                          placeholder: 'Mobile No.*',
                          keyboardType: TextInputType.phone,
                          onSaved: context.read<CautionVm>().onMobileSaved,
                          validator: context.read<CautionVm>().onMobileValidate,
                          inputFormatters: [mobileNumberFormatter],
                        ),
                        const SizedBox(height: 16),
                        
                        AppTextFieldV2(
                          initialValue: initialData.cnic,
                          placeholder: 'CNIC.*',
                          label: 'CNIC.*',
                          keyboardType: TextInputType.number,
                          onSaved: context.read<CautionVm>().onCnicSaved,
                          validator: context.read<CautionVm>().onCnicValidate,
                          inputFormatters: [CNICInputFormatter()]
                        ),
                        const SizedBox(height: 16),
                        
                        AppTextFieldV2(
                          initialValue: initialData.address,
                          placeholder: 'Address.*',
                          onSaved: context.read<CautionVm>().onAddressSaved,
                          validator: context.read<CautionVm>().onAddressValidate,
                        ),
                        const SizedBox(height: 16),
                        
                        AppTextFieldV2(
                          initialValue: initialData.nokName,
                          placeholder: 'Next of Kin Name.*',
                          onSaved: context.read<CautionVm>().onNokNameSaved,
                          validator: context.read<CautionVm>().onNokNameValidate,
                          inputFormatters: [onlyAlphabetsFormatter],
                        ),
                        const SizedBox(height: 16),
                        
                        AppTextFieldV2(
                          initialValue: initialData.nokPhone,
                          placeholder: 'Next of Kin Mobile.*',
                          keyboardType: TextInputType.phone,
                          onSaved: context.read<CautionVm>().onNokMobileSaved,
                          validator: context.read<CautionVm>().onNokMobileValidate,
                        ),
                        const SizedBox(height: 16),
                        
                        AppTextFieldV2(
                          initialValue: initialData.nokCnic,
                          placeholder: 'Next of Kin CNIC.*',
                          keyboardType: TextInputType.number,
                          onSaved: context.read<CautionVm>().onNokCnicSaved,
                          validator: context.read<CautionVm>().onNokCnicValidate,
                          inputFormatters: [CNICInputFormatter()]
                        ),
                        const SizedBox(height: 16),
                        
                        Padding(
                          padding: const EdgeInsets.only(left: 14, bottom: 5),
                          child: Text(
                            'Relation with Next of Kin.*',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        // DropdownButtonFormField<String>(
                        //   initialValue: initialData.nokRelation,
                        //   items: relationships,
                        //   onChanged: context.read<CautionVm>().onRelationChanged,
                        //   validator: context.read<CautionVm>().onRelationValidate,
                        //   decoration: const InputDecoration(
                        //     filled: true,
                        //     fillColor: Color(0xFFF3F3F3),
                        //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(10)),
                        //       borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(10)),
                        //       borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.all(Radius.circular(10)),
                        //       borderSide: BorderSide(color: AppColors.primary, width: 1.4),
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: context.watch<CautionVm>().isBusy ? null : _onUpdate, 
                          child: context.watch<CautionVm>().isBusy ? LoadingWidget() : const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onUpdate() async {
    if(_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final resp = await context.read<CautionVm>().update();

      if(resp.success) {
        // ignore: use_build_context_synchronously
        SnackbarService.showSuccessSnack(context, 'Manadatory Information Saved Sucessfully!');
        // ignore: use_build_context_synchronously
        // context.pushReplacement(UpdateProfileVu());        
      } else {
        // ignore: use_build_context_synchronously
        SnackbarService.showErrorSnack(context, resp.message!);
      }
    }
  }
}

class _CompactRadio<T> extends StatelessWidget {
  const _CompactRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String label;
  final T value;
  final T? groupValue;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,           // ← direct binding
            onChanged: onChanged,             // ← direct binding
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          ),
          const SizedBox(width: 6),
          Flexible(child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
