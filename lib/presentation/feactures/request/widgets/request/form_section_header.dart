import 'package:flutter/material.dart';

class FormSectionHeader extends StatelessWidget {
  final String title;
  final bool isRequired;

  const FormSectionHeader({
    super.key,
    required this.title,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: RichText(
        text: TextSpan(
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(text: title),
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
