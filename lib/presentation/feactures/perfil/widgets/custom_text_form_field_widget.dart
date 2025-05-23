import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '/presentation/resources/resources.dart';

class CustomTextFormField extends StatelessWidget {
  final String name;
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final Widget? prefixIcon;
  final List<String? Function(String?)> validators;
  final ValueChanged<String?>? onChanged;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;
  final bool autofocus;

  const CustomTextFormField({
    super.key,
    required this.name,
    required this.labelText,
    this.hintText,
    this.initialValue,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.prefixIcon,
    this.validators = const [],
    this.onChanged,
    this.keyboardType,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FormBuilderTextField(
        name: name,
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        obscureText: obscureText,
        readOnly: readOnly,
        focusNode: focusNode,
        autofocus: autofocus,
        onChanged: onChanged,
        keyboardType: keyboardType,
        autovalidateMode: autovalidateMode,
        style: AppTextStyles.bodyText1.copyWith(
          color: readOnly ? AppColors.textDisabled : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        validator: FormBuilderValidators.compose(validators),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: AppTextStyles.label.copyWith(
            color: readOnly ? AppColors.textDisabled : AppColors.textSecondary,
            fontSize: 12,
          ),
          hintStyle: AppTextStyles.bodyText2.copyWith(
            color: AppColors.textSecondary.withOpacity(0.7),
          ),
          prefixIcon:
              prefixIcon != null
                  ? Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 10.0),
                    child: IconTheme(
                      data: IconThemeData(
                        color:
                            readOnly
                                ? AppColors.textDisabled
                                : AppColors.icon.withOpacity(0.8),
                        size: 18,
                      ),
                      child: prefixIcon!,
                    ),
                  )
                  : null,
          filled: true,
          fillColor:
              readOnly
                  ? AppColors.inputBackground.withOpacity(0.3)
                  : AppColors.inputBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.border.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.border.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.error, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.border.withOpacity(0.2)),
          ),
        ),
      ),
    );
  }
}
