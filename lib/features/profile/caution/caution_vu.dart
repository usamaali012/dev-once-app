import 'package:dev_once_app/core/constants/relationships.dart';
import 'package:dev_once_app/core/utils/app_validators.dart';
import 'package:dev_once_app/core/utils/snackbar_service.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/features/profile/caution/caution_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/core/widgets/app_background.dart';
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
  void initState() {
    super.initState();
    context.read<CautionVm>().get();   
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CautionVm>();
    MandatoryInfo initialData = vm.data;
    return Scaffold(
      body: AppBackground(
        title: 'Caution',
        headerFraction: 0.30,
        topCornerRadius: 30,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: mobileIcon,
        child: vm.isLoading ? 
          Center(
            widthFactor: 1,
            heightFactor: 1,
            child: SizedBox.square(
              dimension: 30,
              child: LoadingWidget(size: 30, color: AppColors.primary),
            ),
          ) : 
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter the details below to open \nthe dashboard.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF808A93),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    
                    AppTextField(
                      initialValue: vm.guardianType == 1 ? initialData.husbandName : initialData.fatherName,
                      placeholder: vm.guardianLabel,
                      onSaved: context.read<CautionVm>().onGuardianSaved,
                      validator: context.read<CautionVm>().onGuardianValidate,
                      inputFormatters: [onlyAlphabetsFormatter],
                    ),
                    const SizedBox(height: 16),
                    
                    AppTextField(
                      initialValue: initialData.mobile,
                      label: 'Mobile No.*',
                      keyboardType: TextInputType.phone,
                      onSaved: context.read<CautionVm>().onMobileSaved,
                      validator: context.read<CautionVm>().onMobileValidate,
                      inputFormatters: [mobileNumberFormatter],
                    ),
                    const SizedBox(height: 16),
                    
                    AppTextField(
                      initialValue: initialData.cnic,
                      label: 'CNIC.*',
                      keyboardType: TextInputType.number,
                      onSaved: context.read<CautionVm>().onCnicSaved,
                      validator: context.read<CautionVm>().onCnicValidate,
                      inputFormatters: [CNICInputFormatter()]
                    ),
                    const SizedBox(height: 16),
                    
                    AppTextField(
                      initialValue: initialData.address,
                      label: 'Address.*',
                      onSaved: context.read<CautionVm>().onAddressSaved,
                      validator: context.read<CautionVm>().onAddressValidate,
                    ),
                    const SizedBox(height: 16),
                    
                    AppTextField(
                      initialValue: initialData.nokName,
                      label: 'Next of Kin Name.*',
                      onSaved: context.read<CautionVm>().onNokNameSaved,
                      validator: context.read<CautionVm>().onNokNameValidate,
                      inputFormatters: [onlyAlphabetsFormatter],
                    ),
                    const SizedBox(height: 16),
                    
                    AppTextField(
                      initialValue: initialData.nokPhone,
                      label: 'Next of Kin Mobile.*',
                      keyboardType: TextInputType.phone,
                      onSaved: context.read<CautionVm>().onNokMobileSaved,
                      validator: context.read<CautionVm>().onNokMobileValidate,
                    ),
                    const SizedBox(height: 16),
                    
                    AppTextField(
                      initialValue: initialData.nokCnic,
                      label: 'Next of Kin CNIC.*',
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
                    DropdownButtonFormField<String>(
                      initialValue: initialData.nokRelation,
                      items: relationships,
                      onChanged: context.read<CautionVm>().onRelationChanged,
                      validator: context.read<CautionVm>().onRelationValidate,
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 56,
                  child: Consumer<CautionVm>(
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
                      child: vm.isBusy ? LoadingWidget() : const Text('Next'),
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
    if(_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final resp = await context.read<CautionVm>().update();

      if(resp.success) {
        // ignore: use_build_context_synchronously
        SnackbarService.showSuccessSnack(context, 'Manadatory Info Saved Sucessfully!');
        // ignore: use_build_context_synchronously
        // context.pushReplacement(CautionScreen());        
      } else {
        // ignore: use_build_context_synchronously
        SnackbarService.showErrorSnack(context, resp.message!);
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
