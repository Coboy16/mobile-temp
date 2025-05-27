import 'package:flutter/material.dart';
import 'package:fe_core_vips/core/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/presentation/resources/resources.dart';

class OtpFormWidget extends StatefulWidget {
  final String email;
  final Function(String otp) onOtpVerified;
  final VoidCallback onResendOtp;
  final VoidCallback onGoBack;
  final String? descriptionText;
  final String? buttonText;
  final String? resendOtpButtonText;
  final VoidCallback? onError; // Callback opcional para manejar errores

  const OtpFormWidget({
    super.key,
    required this.email,
    required this.onOtpVerified,
    required this.onResendOtp,
    required this.onGoBack,
    this.descriptionText,
    this.buttonText,
    this.resendOtpButtonText,
    this.onError, // Nuevo parámetro opcional
  });

  @override
  State<OtpFormWidget> createState() => OtpFormWidgetState();
}

class OtpFormWidgetState extends State<OtpFormWidget> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void clearOtpField() {
    if (mounted) {
      setState(() {
        _otpController.clear();
      });
      _otpFocusNode.requestFocus();
    }
  }

  String get currentOtpValue => _otpController.text;

  void setOtpValue(String value) {
    if (mounted) {
      setState(() {
        _otpController.text = value;
      });
    }
  }

  void _submitOtp() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      widget.onOtpVerified(_otpController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final defaultPinTheme = PinTheme(
      width:
          ResponsiveValue<double>(
            context,
            defaultValue: 50, // Desktop
            conditionalValues: [Condition.equals(name: MOBILE, value: 45.0)],
          ).value,
      height:
          ResponsiveValue<double>(
            context,
            defaultValue: 55, // Desktop
            conditionalValues: [Condition.equals(name: MOBILE, value: 50.0)],
          ).value,
      textStyle: TextStyle(
        fontSize:
            ResponsiveValue<double>(
              context,
              defaultValue: 22, // Desktop
              conditionalValues: [Condition.equals(name: MOBILE, value: 20.0)],
            ).value,
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius / 1.5),
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.descriptionText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.itemSpacing),
              child: Text(
                widget.descriptionText!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyTextColor,
                ),
              ),
            ),
          Center(
            child: Pinput(
              length: 6,
              controller: _otpController,
              focusNode: _otpFocusNode,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                ),
              ),
              validator: (s) {
                return s?.length == 6 ? null : l10n.otpFormValidatorError;
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => _submitOtp(),
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (pin) => _submitOtp(),
            ),
          ),
          SizedBox(
            height:
                ResponsiveValue<double>(
                  context,
                  defaultValue: AppDimensions.largeSpacing * 1.2, // Desktop
                  conditionalValues: [
                    Condition.equals(name: MOBILE, value: 20.0),
                  ],
                ).value,
          ),
          ElevatedButton(
            onPressed: _submitOtp,
            child: Text(widget.buttonText ?? l10n.otpFormDefaultSubmitButton),
          ),
          SizedBox(
            height:
                ResponsiveValue<double>(
                  context,
                  defaultValue: AppDimensions.itemSpacing, // Desktop
                  conditionalValues: [
                    Condition.equals(name: MOBILE, value: 12.0),
                  ],
                ).value,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.otpFormDidNotReceiveCodePrompt,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyTextColor,
                ),
              ),
            ],
          ),
          Center(
            child: TextButton(
              onPressed: widget.onResendOtp,
              child: Text(
                widget.resendOtpButtonText ?? l10n.otpFormDefaultResendButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
