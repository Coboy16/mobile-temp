import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:data_table_2/data_table_2.dart';

import '/presentation/feactures/request/temp/mock_data.dart';
import '/presentation/feactures/request/widgets/widget.dart';
import '/presentation/feactures/request/bloc/bloc.dart';
import '/presentation/feactures/request/utils/utils.dart';
import '/presentation/resources/resources.dart';

class RequestsTableArea extends StatefulWidget {
  const RequestsTableArea({super.key});

  @override
  State<RequestsTableArea> createState() => _RequestsTableAreaState();
}

class _RequestsTableAreaState extends State<RequestsTableArea> {
  int _selectedTabIndex = 0; // 0: Todas, 1: Pendientes, etc.
  bool _isListView = true;
  DateTime? _startDate;
  DateTime? _endDate;

  // Variables para DataTable2
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  List<RequestData> _sortedRequests = [];

  @override
  void initState() {
    super.initState();
    // Cargar las solicitudes iniciales en el bloc
    context.read<RequestFilterBloc>().add(LoadInitialRequests(dummyRequests));
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDialog<DateTimeRange>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerPopup(
          initialStartDate: _startDate,
          initialEndDate: _endDate,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        print('Rango seleccionado: $_startDate - $_endDate');
      });
    }
  }

  // Función para ordenar las solicitudes
  void _onSort(int columnIndex, bool ascending, List<RequestData> requests) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      _sortedRequests = List.from(requests);

      switch (columnIndex) {
        case 0: // Código
          _sortedRequests.sort(
            (a, b) =>
                ascending ? a.code.compareTo(b.code) : b.code.compareTo(a.code),
          );
          break;
        case 1: // Tipo
          _sortedRequests.sort(
            (a, b) =>
                ascending ? a.type.compareTo(b.type) : b.type.compareTo(a.type),
          );
          break;
        case 2: // Empleado
          _sortedRequests.sort(
            (a, b) =>
                ascending
                    ? a.employeeName.compareTo(b.employeeName)
                    : b.employeeName.compareTo(a.employeeName),
          );
          break;
        case 3: // Período
          _sortedRequests.sort(
            (a, b) =>
                ascending
                    ? a.period.compareTo(b.period)
                    : b.period.compareTo(a.period),
          );
          break;
        case 4: // Empresa
          _sortedRequests.sort(
            (a, b) =>
                ascending
                    ? a.company.compareTo(b.company)
                    : b.company.compareTo(a.company),
          );
          break;
        case 5: // Solicitado
          _sortedRequests.sort(
            (a, b) =>
                ascending
                    ? a.requestedAgo.compareTo(b.requestedAgo)
                    : b.requestedAgo.compareTo(a.requestedAgo),
          );
          break;
        case 6: // Estado
          _sortedRequests.sort(
            (a, b) =>
                ascending
                    ? a.status.toString().compareTo(b.status.toString())
                    : b.status.toString().compareTo(a.status.toString()),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadiusValue = 8.0;
    const BorderRadius borderRadius = BorderRadius.all(
      Radius.circular(borderRadiusValue),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius,
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado y filtros (siempre visibles)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Listado de Solicitudes',
                      style: AppTextStyles.titleSolicitudes,
                    ),
                    const SizedBox(height: 16),
                    // Filtros y cambio de vista
                    FilterHeaderWidget(
                      initialTabIndex: _selectedTabIndex,
                      initialListView: _isListView,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                        context.read<RequestFilterBloc>().add(
                          StatusTabChanged(index),
                        );
                      },
                      onViewChanged: (isListView) {
                        setState(() {
                          _isListView = isListView;
                        });
                      },
                      onFilterByDate: () {
                        _showDateRangePicker(context);
                      },
                      onDownload: () {},
                    ),
                  ],
                ),
              ),

              // Contenido principal
              BlocBuilder<RequestFilterBloc, RequestFilterState>(
                builder: (context, state) {
                  // Inicializar _sortedRequests si está vacío
                  if (_sortedRequests.isEmpty &&
                      state.filteredRequests.isNotEmpty) {
                    _sortedRequests = List.from(state.filteredRequests);
                  }

                  if (isMobile) {
                    return _buildMobileView(state.filteredRequests);
                  } else {
                    return _buildDesktopView(state.filteredRequests);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Vista desktop (sin cambios)
  Widget _buildDesktopView(List<RequestData> requests) {
    const double borderRadiusValue = 8.0;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(borderRadiusValue),
        bottomRight: Radius.circular(borderRadiusValue),
      ),
      child: Container(
        height: 600, // Altura fija para evitar problemas de layout
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child:
            _isListView
                ? _buildDataTable2View(requests)
                : _buildCardsView(requests),
      ),
    );
  }

  // Vista móvil sin paginación interna
  Widget _buildMobileView(List<RequestData> requests) {
    return Container(
      constraints: const BoxConstraints(minHeight: 400, maxHeight: 600),
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
      child:
          requests.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                shrinkWrap: true,
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == requests.length - 1 ? 0 : 16.0,
                    ),
                    child: RequestCard(
                      request: requests[index],
                      onViewDetails: () {
                        context.go('/home/request/${requests[index].code}');
                      },
                      onActionSelected: (action) {
                        /* TODO */
                      },
                    ),
                  );
                },
              ),
    );
  }

  // Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.inbox, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No hay solicitudes para mostrar',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Intenta ajustar los filtros o crear una nueva solicitud',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- Vista de Tabla con DataTable2 (sin cambios) ---
  Widget _buildDataTable2View(List<RequestData> requests) {
    // Usar requests ordenadas si existen, sino usar las originales
    final displayRequests =
        _sortedRequests.isNotEmpty ? _sortedRequests : requests;

    return DataTable2(
      // Configuración general
      columnSpacing: 20,
      horizontalMargin: 20,
      minWidth: 1200,
      showBottomBorder: false,
      border: TableBorder(
        horizontalInside: BorderSide.none, // Quita las líneas horizontales
        verticalInside: BorderSide.none, // Quita las líneas verticales
      ),

      // Estilos de encabezado
      headingRowHeight: 50,
      headingRowColor: WidgetStateProperty.all(
        Color(0xFFF8F9FA), // Fondo gris claro para la cabecera
      ),
      headingTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
        fontSize: 13,
      ),

      // Estilos de filas de datos
      dataRowHeight: 80,
      dataTextStyle: const TextStyle(fontSize: 13, color: Colors.black87),

      // Decoración de la tabla (sin bordes)
      decoration: const BoxDecoration(),

      // Configuración de ordenamiento
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,

      // Configuración de scroll
      scrollController: ScrollController(),

      // Filas vacías
      empty: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.inbox, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No hay solicitudes para mostrar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Intenta ajustar los filtros o crear una nueva solicitud',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),

      // Definición de columnas
      columns: [
        DataColumn2(
          label: Text('Código', style: _getHeaderStyle()),
          size: ColumnSize.S,
          onSort:
              (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending, requests),
        ),
        DataColumn2(
          label: Text('Tipo', style: _getHeaderStyle()),
          size: ColumnSize.L,
          onSort:
              (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending, requests),
        ),
        DataColumn2(
          label: Text('Empleado', style: _getHeaderStyle()),
          size: ColumnSize.L,
          onSort:
              (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending, requests),
        ),
        DataColumn2(
          label: Text('Período', style: _getHeaderStyle()),
          size: ColumnSize.M,
          onSort:
              (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending, requests),
        ),
        DataColumn2(
          label: Text('Empresa/Sucursal', style: _getHeaderStyle()),
          size: ColumnSize.L,
          onSort:
              (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending, requests),
        ),
        DataColumn2(
          label: Text('Solicitado', style: _getHeaderStyle()),
          size: ColumnSize.S,
          onSort:
              (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending, requests),
        ),
        DataColumn2(
          label: Text('Estado', style: _getHeaderStyle()),
          size: ColumnSize.S,
          onSort:
              (columnIndex, ascending) =>
                  _onSort(columnIndex, ascending, requests),
        ),
        DataColumn2(
          label: Text('Acciones', style: _getHeaderStyle()),
          size: ColumnSize.M,
          fixedWidth: 200,
        ),
      ],

      // Filas de datos
      rows: displayRequests.map((request) => _buildDataRow2(request)).toList(),
    );
  }

  // Estilo para headers
  TextStyle _getHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade700,
      fontSize: 13,
      letterSpacing: 0.2,
    );
  }

  // --- Vista de Tarjetas (Grid/Lista) ---
  Widget _buildCardsView(List<RequestData> requests) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final int crossAxisCount =
            availableWidth > 1200
                ? 3
                : availableWidth > 800
                ? 2
                : 1;

        return SingleChildScrollView(
          child:
              crossAxisCount > 1
                  ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 380,
                    ),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      return RequestCard(
                        request: requests[index],
                        onViewDetails: () {
                          context.go('/home/request/${requests[index].code}');
                        },
                        onActionSelected: (action) {},
                      );
                    },
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == requests.length - 1 ? 0 : 16.0,
                        ),
                        child: RequestCard(
                          request: requests[index],
                          onViewDetails: () {
                            context.go('/home/request/${requests[index].code}');
                          },
                          onActionSelected: (action) {
                            /* TODO */
                          },
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }

  // DataRow2 con mejor configuración (sin cambios)
  DataRow2 _buildDataRow2(RequestData request) {
    return DataRow2(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      cells: [
        DataCell(
          Text(
            request.code,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          _buildTypeCell(request.typeIcon, request.type, request.typeDate),
        ),
        DataCell(
          _buildEmployeeCell(
            request.employeeName,
            request.employeeCode,
            request.employeeDept,
          ),
        ),
        DataCell(
          Text(
            request.period,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(_buildCompanyCell(request.company, request.branch)),
        DataCell(
          Text(
            request.requestedAgo,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        DataCell(StatusBadge(status: request.status)),
        DataCell(_buildActionsCell(request)),
      ],
    );
  }

  // Resto de métodos helper sin cambios...
  Widget _buildTypeCell(IconData icon, String type, String date) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
          child: Icon(icon, size: 18, color: AppColors.primaryBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCell(String name, String code, String dept) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          code,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          dept,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildCompanyCell(String company, String branch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          company,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          branch,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildActionsCell(RequestData request) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            context.go('/home/request/${request.code}');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
              color: const Color.fromARGB(36, 192, 189, 189),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ver detalles',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                const SizedBox(width: 4),
                Icon(LucideIcons.arrowRight, size: 12, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          color: Colors.white,
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
              color: const Color.fromARGB(36, 192, 189, 189),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(LucideIcons.plus, size: 14, color: Colors.black),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          itemBuilder:
              (context) => [
                _buildMenuItem(
                  icon: LucideIcons.squarePen,
                  text: 'Editar solicitud',
                  textColor: Colors.black87,
                ),
                _buildMenuItem(
                  icon: LucideIcons.download,
                  text: 'Descargar PDF',
                  textColor: Colors.black87,
                ),
                _buildMenuItem(
                  icon: LucideIcons.circleCheckBig,
                  text: 'Aprobar solicitud',
                  textColor: AppColors.primaryPurple,
                ),
                _buildMenuItem(
                  icon: LucideIcons.circleX,
                  text: 'Rechazar solicitud',
                  textColor: Colors.red,
                ),
              ],
          onSelected: (value) {
            switch (value) {
              case 'Editar solicitud':
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Editar solicitud ${request.code}')),
                );
                break;

              case 'Descargar PDF':
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text("Generando PDF..."),
                        ],
                      ),
                    );
                  },
                );

                Future.delayed(Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('PDF descargado correctamente'),
                      backgroundColor: AppColors.primaryPurple,
                    ),
                  );
                });
                break;

              case 'Aprobar solicitud':
                showApprovalFlow(context, request);
                break;

              case 'Rechazar solicitud':
                showRejectionFlow(context, request);
                break;
            }
          },
          offset: const Offset(0, 30),
          elevation: 2,
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required IconData icon,
    required String text,
    required Color textColor,
  }) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 18, color: textColor),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 13, color: textColor)),
        ],
      ),
    );
  }
}
