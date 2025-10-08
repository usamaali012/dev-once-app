import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/widgets/app_text_field.dart';
import 'package:dev_once_app/features/auth/widgets/auth_background.dart';
import 'package:dev_once_app/features/caution/caution_vm.dart';
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
    return Scaffold(
      body: AuthBackground(
        title: 'Caution',
        headerFraction: 0.30,
        topCornerRadius: 30,
        leading: doIcon,
        topRightDecoration: roundedTopRight,
        overlapGraphic: mobileIcon,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter the details below to open the dashboard.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF808A93),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _CompactRadio<int>(
                          label: 'Father Name',
                          value: 0,
                          groupValue: context.read<CautionVm>().nameType,
                          onChanged: context.read<CautionVm>().onNameTypeChanged,
                        ),
                      ),
                      // const SizedBox(width: 3),
                      Expanded(
                        child: _CompactRadio<int>(
                          label: 'Husband Name',
                          value: 1,
                          groupValue: context.read<CautionVm>().nameType,
                          onChanged: context.read<CautionVm>().onNameTypeChanged
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  AppTextField(
                    placeholder: context.read<CautionVm>().guardianLabel,
                    onSaved: context.read<CautionVm>().onGuardianSaved,
                    validator: context.read<CautionVm>().onGuardianValidate,
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    label: 'Mobile No.*',
                    keyboardType: TextInputType.phone,
                    onSaved: context.read<CautionVm>().onMobileSaved,
                    validator: context.read<CautionVm>().onMobileValidate,
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    label: 'CNIC.*',
                    keyboardType: TextInputType.number,
                    onSaved: context.read<CautionVm>().onCnicSaved,
                    validator: context.read<CautionVm>().onCnicValidate,
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    label: 'Address.*',
                    onSaved: context.read<CautionVm>().onAddressSaved,
                    validator: context.read<CautionVm>().onAddressValidate,
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    label: 'Next of Kin Name.*',
                    onSaved: context.read<CautionVm>().onNokNameSaved,
                    validator: context.read<CautionVm>().onNokNameValidate,
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    label: 'Next of Kin Mobile.*',
                    keyboardType: TextInputType.phone,
                    onSaved: context.read<CautionVm>().onNokMobileSaved,
                    validator: context.read<CautionVm>().onNokMobileValidate,
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    label: 'Next of Kin CNIC.*',
                    keyboardType: TextInputType.number,
                    onSaved: context.read<CautionVm>().onNokCnicSaved,
                    validator: context.read<CautionVm>().onNokCnicValidate,
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
                    items: relations,
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
                    onPressed: vm.isBusy ? null : () async {
                      if (!(_formKey.currentState?.validate() ?? false)) return;
                      _formKey.currentState!.save();
                      await vm.submit();
                      // Next step can be handled later
                    },
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
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Next'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final relations = [
    DropdownMenuItem(value: 'Father', child: Text('Father')),
    DropdownMenuItem(value: 'Mother', child: Text('Mother')),
    DropdownMenuItem(value: 'Brother', child: Text('Brother')),
    DropdownMenuItem(value: 'Sister', child: Text('Sister')),
    DropdownMenuItem(value: 'Son', child: Text('Son')),
    DropdownMenuItem(value: 'Husband', child: Text('Husband')),
    DropdownMenuItem(value: 'Grandfather', child: Text('Grandfather')),
    DropdownMenuItem(value: 'Uncle', child: Text('Grandson')),
    DropdownMenuItem(value: 'Uncle', child: Text('Uncle')),
    DropdownMenuItem(value: 'Nephew', child: Text('Nephew')),
    DropdownMenuItem(value: 'Daughter', child: Text('Daughter')),
    DropdownMenuItem(value: 'Wife', child: Text('Wife')),
    DropdownMenuItem(value: 'Grandmother', child: Text('Grandmother')),
    DropdownMenuItem(value: 'Granddaughter', child: Text('Granddaughter')),
    DropdownMenuItem(value: 'Aunt', child: Text('Aunt')),
    DropdownMenuItem(value: 'Niece', child: Text('Niece')),
    DropdownMenuItem(value: 'Cousin', child: Text('Cousin')),
    DropdownMenuItem(value: 'Self', child: Text('Self')),
  ];

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
          RadioGroup(
            onChanged: onChanged, 
            groupValue: groupValue,
            child: Radio<T>(
              value: value,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: -4, 
                vertical: -4,
              ),
          )
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
