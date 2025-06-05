import 'package:flutter/material.dart';

import '/presentation/feactures/request/widgets/widget.dart';
import '/data/data.dart';

class SimpleRequestHelper {
  static Future<Map<String, dynamic>?> showSimpleRequestModal(
    BuildContext context,
    SimpleRequestType requestType, {
    Function(SimpleRequestData)? onSubmit,
  }) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleRequestModal(requestType: requestType, onSubmit: onSubmit);
      },
    );
  }

  // Métodos específicos para cada tipo
  static Future<Map<String, dynamic>?> showScheduleChangeModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) {
    return showSimpleRequestModal(
      context,
      SimpleRequestType.scheduleChange,
      onSubmit: onSubmit,
    );
  }

  static Future<Map<String, dynamic>?> showPositionChangeModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) {
    return showSimpleRequestModal(
      context,
      SimpleRequestType.positionChange,
      onSubmit: onSubmit,
    );
  }

  static Future<Map<String, dynamic>?> showTipChangeModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) {
    return showSimpleRequestModal(
      context,
      SimpleRequestType.tipChange,
      onSubmit: onSubmit,
    );
  }

  static Future<Map<String, dynamic>?> showAdvanceModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) {
    return showSimpleRequestModal(
      context,
      SimpleRequestType.advance,
      onSubmit: onSubmit,
    );
  }

  static Future<Map<String, dynamic>?> showUniformModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) {
    return showSimpleRequestModal(
      context,
      SimpleRequestType.uniform,
      onSubmit: onSubmit,
    );
  }

  static Future<Map<String, dynamic>?> showHousingChangeRequestModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return HousingChangeRequestModal(onSubmit: onSubmit);
      },
    );
  }

  static Future<Map<String, dynamic>?> showExitRequestModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ExitRequestModal(onSubmit: onSubmit);
      },
    );
  }

  static Future<Map<String, dynamic>?> showLetterRequestModal(
    BuildContext context, {
    Function(SimpleRequestData)? onSubmit,
  }) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LetterRequestModal(onSubmit: onSubmit);
      },
    );
  }
}
