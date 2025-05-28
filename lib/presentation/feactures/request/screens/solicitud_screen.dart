import 'dart:convert';

import 'package:fe_core_vips/presentation/feactures/request/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '/presentation/feactures/request/temp/app_models.dart';
import '/presentation/feactures/request/temp/app_data_json.dart';
import '/presentation/resources/resources.dart';

class SolicitudScreen extends StatefulWidget {
  const SolicitudScreen({super.key});

  @override
  State<SolicitudScreen> createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  late AppData appData;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> decodedJson = jsonDecode(
      solicitudDataJsonString,
    );
    appData = AppData.fromJson(decodedJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.pageBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: AppColors.primaryTextColor,
          ),
          onPressed: () {
            // Navigator.pop(context); // Example navigation
          },
        ),
        title: const Text(
          'Detalle de Solicitud',
          style: TextStyle(
            color: AppColors.primaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ResponsiveRowColumn(
          rowSpacing: 16,
          columnSpacing: 16,
          layout:
              ResponsiveBreakpoints.of(context).largerThan(TABLET)
                  ? ResponsiveRowColumnType.ROW
                  : ResponsiveRowColumnType.COLUMN,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 2, // Takes 2/3 of the space in row layout
              child: LeftColumnContent(appData: appData),
            ),
            ResponsiveRowColumnItem(
              rowFlex: 1, // Takes 1/3 of the space in row layout
              child: RightColumnContent(appData: appData),
            ),
          ],
        ),
      ),
    );
  }
}
