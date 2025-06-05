import 'package:flutter/material.dart';

class CustomConfirmationModal extends StatelessWidget {
  // Propiedades de contenido
  final String title;
  final String subtitle;
  final String confirmButtonText;
  final String cancelButtonText;

  // Propiedades de estilo
  final Color backgroundColor;
  final Color confirmButtonColor;
  final Color cancelButtonColor;
  final Color titleColor;
  final Color subtitleColor;
  final Color confirmTextColor;
  final Color cancelTextColor;

  // Propiedades de dimensiones
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;
  final EdgeInsets buttonPadding;

  // Callbacks
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  // Propiedades de comportamiento
  final bool showCancelButton;

  // Propiedades de texto
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final TextStyle? buttonTextStyle;

  const CustomConfirmationModal({
    super.key,
    required this.title,
    required this.subtitle,
    this.confirmButtonText = 'Confirmar',
    this.cancelButtonText = 'Cancelar',
    this.backgroundColor = Colors.white,
    this.confirmButtonColor = const Color(0xFF6366F1),
    this.cancelButtonColor = Colors.transparent,
    this.titleColor = const Color(0xFF1F2937),
    this.subtitleColor = const Color(0xFF6B7280),
    this.confirmTextColor = Colors.white,
    this.cancelTextColor = const Color(0xFF6B7280),
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(24.0),
    this.buttonPadding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 12.0,
    ),
    this.onConfirm,
    this.onCancel,
    this.showCancelButton = true,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.buttonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isWeb = screenSize.width > 600;

    // Calculamos el ancho responsivo
    final modalWidth = width ?? _getResponsiveWidth(screenSize, isWeb);
    final modalHeight = height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isWeb ? 0 : 16,
        vertical: 16,
      ),
      child: Container(
        width: modalWidth,
        height: modalHeight,
        constraints: BoxConstraints(
          maxWidth: isWeb ? 500 : screenSize.width - 32,
          minHeight: 200,
          maxHeight: screenSize.height - 32,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header con botón X
            _buildHeader(context),

            // Contenido principal
            Flexible(child: _buildContent()),

            // Botones de acción
            _buildActionButtons(context, isWeb),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: padding.top,
        left: padding.left,
        right: padding.right,
        bottom: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style:
                  titleTextStyle ??
                  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
              textAlign: TextAlign.start,
            ),
          ),
          GestureDetector(
            onTap: onCancel ?? () => Navigator.of(context).pop(false),
            child: Icon(Icons.close, size: 20, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.left, vertical: 8),
      child: Text(
        subtitle,
        style:
            subtitleTextStyle ??
            TextStyle(fontSize: 14, color: subtitleColor, height: 1.5),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isWeb) {
    return Padding(
      padding: EdgeInsets.only(
        left: padding.left,
        right: padding.right,
        bottom: padding.bottom,
        top: 16,
      ),
      child: isWeb ? _buildWebButtons(context) : _buildMobileButtons(context),
    );
  }

  Widget _buildWebButtons(BuildContext context) {
    if (!showCancelButton) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildConfirmButton(context)],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildCancelButton(context),
        const SizedBox(width: 12),
        _buildConfirmButton(context),
      ],
    );
  }

  Widget _buildMobileButtons(BuildContext context) {
    if (!showCancelButton) {
      return SizedBox(
        width: double.infinity,
        child: _buildConfirmButton(context),
      );
    }

    return Column(
      children: [
        SizedBox(width: double.infinity, child: _buildConfirmButton(context)),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: _buildCancelButton(context)),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
      style: ElevatedButton.styleFrom(
        backgroundColor: confirmButtonColor,
        foregroundColor: confirmTextColor,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Text(
        confirmButtonText,
        style:
            buttonTextStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: confirmTextColor,
            ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return TextButton(
      onPressed: onCancel ?? () => Navigator.of(context).pop(false),
      style: TextButton.styleFrom(
        backgroundColor: cancelButtonColor,
        foregroundColor: cancelTextColor,
        padding: buttonPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
        ),
      ),
      child: Text(
        cancelButtonText,
        style:
            buttonTextStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: cancelTextColor,
            ),
      ),
    );
  }

  double _getResponsiveWidth(Size screenSize, bool isWeb) {
    if (isWeb) {
      return 400;
    } else {
      return screenSize.width * 0.9;
    }
  }

  // Método estático para mostrar el modal fácilmente
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    String confirmButtonText = 'Confirmar',
    String cancelButtonText = 'Cancelar',
    Color backgroundColor = Colors.white,
    Color confirmButtonColor = const Color(0xFF6366F1),
    Color cancelButtonColor = Colors.transparent,
    double? width,
    double? height,
    bool showCancelButton = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return CustomConfirmationModal(
          title: title,
          subtitle: subtitle,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          backgroundColor: backgroundColor,
          confirmButtonColor: confirmButtonColor,
          cancelButtonColor: cancelButtonColor,
          width: width,
          height: height,
          showCancelButton: showCancelButton,
          onConfirm: onConfirm,
          onCancel: onCancel,
        );
      },
    );
  }

  // Método adicional para mostrar modal de acción simple (solo confirmar)
  static Future<bool?> showSimple({
    required BuildContext context,
    required String title,
    required String subtitle,
    String confirmButtonText = 'Aceptar',
    Color backgroundColor = Colors.white,
    Color confirmButtonColor = const Color(0xFF6366F1),
    double? width,
    double? height,
    VoidCallback? onConfirm,
  }) {
    return show(
      context: context,
      title: title,
      subtitle: subtitle,
      confirmButtonText: confirmButtonText,
      backgroundColor: backgroundColor,
      confirmButtonColor: confirmButtonColor,
      width: width,
      height: height,
      showCancelButton: false,
      onConfirm: onConfirm,
    );
  }
}
