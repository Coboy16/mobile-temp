import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '/presentation/resources/resources.dart';

class ForgotPasswordOtpForm extends StatefulWidget {
  final String email;
  final Function(String otp) onOtpVerified;
  final VoidCallback onResendOtp;
  final VoidCallback onGoBack;

  const ForgotPasswordOtpForm({
    super.key,
    required this.email,
    required this.onOtpVerified,
    required this.onResendOtp,
    required this.onGoBack,
  });

  @override
  State<ForgotPasswordOtpForm> createState() => _ForgotPasswordOtpFormState();
}

class _ForgotPasswordOtpFormState extends State<ForgotPasswordOtpForm> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  void _submitOtp() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      widget.onOtpVerified(_otpController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 800;

    final defaultPinTheme = PinTheme(
      width: isMobile ? 45 : 50,
      height: isMobile ? 50 : 55,
      textStyle: TextStyle(
        fontSize: isMobile ? 20 : 22,
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
                return s?.length == 6
                    ? null
                    : 'El código debe ser de 6 dígitos';
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
          SizedBox(height: isMobile ? 20 : AppDimensions.largeSpacing * 1.2),
          ElevatedButton(
            onPressed: _submitOtp,
            child: const Text('Verificar Código'),
          ),
          SizedBox(height: isMobile ? 12 : AppDimensions.itemSpacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿No recibiste el código? ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyTextColor,
                ),
              ),
              TextButton(
                onPressed: widget.onResendOtp,
                child: const Text('Reenviar código'),
              ),
            ],
          ),
          Center(
            child: TextButton(
              onPressed: widget.onGoBack,
              child: const Text('Ingresar otro correo'),
            ),
          ),
        ],
      ),
    );
  }
}
