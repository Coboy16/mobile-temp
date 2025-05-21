// lib/widgets/profile_detail_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import 'custom_text_form_field_widget.dart';

class ProfileDetailCard extends StatefulWidget {
  final String title;
  final String currentValue;
  final String formFieldName;
  final IconData displayIcon;
  final String? hintText;
  final List<String? Function(String?)> validators;
  final Function(String newValue) onSave;
  final TextInputType? keyboardType;
  final bool readOnly;

  const ProfileDetailCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.formFieldName,
    required this.displayIcon,
    this.hintText,
    this.validators = const [],
    required this.onSave,
    this.keyboardType,
    this.readOnly = false,
  });

  @override
  State<ProfileDetailCard> createState() => _ProfileDetailCardState();
}

class _ProfileDetailCardState extends State<ProfileDetailCard> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isEditing = false;
  late String _displayValue;
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.currentValue;
    _editingController = TextEditingController(text: _displayValue);
  }

  @override
  void didUpdateWidget(covariant ProfileDetailCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue != oldWidget.currentValue && !_isEditing) {
      setState(() {
        _displayValue = widget.currentValue;
        _editingController.text = _displayValue;
      });
    }
    if (widget.readOnly && _isEditing) {
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    if (widget.readOnly) return;
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _editingController.text = _displayValue;
      } else {
        _editingController.text = _displayValue;
      }
    });
  }

  void _saveField() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final newValue = _editingController.text;

      if (newValue != _displayValue) {
        widget.onSave(newValue);
        setState(() {
          _isEditing = false;
        });
      } else {
        _toggleEditMode();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmptyNonReadOnly = _displayValue.isEmpty && !widget.readOnly;
    final String effectiveDisplayValue =
        isEmptyNonReadOnly
            ? 'No especificado'
            : (widget.readOnly && _displayValue.isEmpty
                ? 'N/A'
                : _displayValue);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:
          _isEditing
              ? FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      name: widget.formFieldName,
                      controller: _editingController,
                      labelText: widget.title,
                      hintText:
                          widget.hintText ??
                          'Ingresa ${widget.title.toLowerCase()}',
                      prefixIcon: FaIcon(widget.displayIcon, size: 18),
                      validators: widget.validators,
                      keyboardType: widget.keyboardType,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      autofocus: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _toggleEditMode,
                          child: Text(
                            'Cancelar',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _saveField,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                            textStyle: AppTextStyles.button.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              : InkWell(
                onTap: widget.readOnly ? null : _toggleEditMode,
                borderRadius: BorderRadius.circular(12.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: FaIcon(
                              widget.displayIcon,
                              size: 18,
                              color: AppColors.icon.withOpacity(0.8),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              effectiveDisplayValue,
                              style: AppTextStyles.bodyText1.copyWith(
                                color:
                                    isEmptyNonReadOnly ||
                                            (widget.readOnly &&
                                                _displayValue.isEmpty)
                                        ? AppColors.textDisabled
                                        : AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!widget.readOnly)
                            Icon(
                              FontAwesomeIcons.penToSquare,
                              size: 16,
                              color: AppColors.primary.withOpacity(0.7),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
