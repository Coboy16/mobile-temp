import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fe_core_vips/data/data.dart';

import '/presentation/feactures/request/bloc/bloc.dart';

class EmployeeSelectorFormField extends StatefulWidget {
  final String name;
  final String? Function(Employee?)? validator;
  final Employee? initialValue;
  final ValueChanged<Employee?>? onChanged;

  const EmployeeSelectorFormField({
    super.key,
    required this.name,
    this.validator,
    this.initialValue,
    this.onChanged,
  });

  @override
  State<EmployeeSelectorFormField> createState() =>
      _EmployeeSelectorFormFieldState();
}

class _EmployeeSelectorFormFieldState extends State<EmployeeSelectorFormField>
    with AutomaticKeepAliveClientMixin {
  // AutomaticKeepAliveClientMixin ayuda a mantener el estado
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  late EmployeeSearchBloc _bloc;
  bool _isDropdownOpen = false;
  Employee? _selectedEmployee;
  FormFieldState<Employee>? _fieldState;
  bool _isProcessingTap = false;
  bool _hasStartedTyping = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🚀 EmployeeSelector: initState');
    _bloc = EmployeeSearchBloc();
    _focusNode.addListener(_onFocusChange);

    if (widget.initialValue != null) {
      debugPrint(
        '📝 EmployeeSelector: Setting initial value: ${widget.initialValue!.name}',
      );
      _selectedEmployee = widget.initialValue;
      _updateDisplayText();
      _bloc.add(SelectEmployee(widget.initialValue));
    }
  }

  @override
  void dispose() {
    debugPrint('🗑️ EmployeeSelector: dispose');
    _textController.dispose();
    _focusNode.dispose();
    _removeOverlay();
    _bloc.close();
    super.dispose();
  }

  void _updateDisplayText() {
    if (_selectedEmployee != null && !_hasStartedTyping) {
      final newText =
          '${_selectedEmployee!.name}\nCódigo ${_selectedEmployee!.id} | ${_selectedEmployee!.role}';
      debugPrint('🔄 EmployeeSelector: Updating display text to: $newText');
      _textController.text = newText;
    }
  }

  void _onFocusChange() {
    debugPrint(
      '👁️ EmployeeSelector: Focus changed - hasFocus: ${_focusNode.hasFocus}, hasStartedTyping: $_hasStartedTyping, selectedEmployee: ${_selectedEmployee?.name}',
    );

    if (_focusNode.hasFocus) {
      debugPrint('🎯 EmployeeSelector: Field gained focus');

      if (_selectedEmployee == null || _hasStartedTyping) {
        debugPrint('✅ EmployeeSelector: Conditions met to show dropdown');
        if (!_isDropdownOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            debugPrint(
              '⏰ EmployeeSelector: PostFrameCallback - showing overlay',
            );
            _showOverlay();
          });

          if (!_hasStartedTyping) {
            _bloc.add(const SearchEmployees(''));
          }
        }
      } else {
        debugPrint(
          '❌ EmployeeSelector: Employee selected and not typing - preventing dropdown',
        );
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_focusNode.hasFocus && !_hasStartedTyping) {
            debugPrint('🚫 EmployeeSelector: Removing focus from field');
            _focusNode.unfocus();
          }
        });
      }
    } else {
      debugPrint('😴 EmployeeSelector: Field lost focus');

      if (_isDropdownOpen) {
        if (_selectedEmployee != null && _hasStartedTyping) {
          debugPrint('🔙 EmployeeSelector: Restoring text after lost focus');
          _hasStartedTyping = false;
          _updateDisplayText();
        }

        Future.delayed(const Duration(milliseconds: 200), () {
          if (!_focusNode.hasFocus) {
            debugPrint('⏰ EmployeeSelector: Delayed removal of overlay');
            _removeOverlay();
          }
        });
      }
    }
  }

  void _onTextChanged(String value) {
    debugPrint(
      '📝 EmployeeSelector: Text changed to: "$value", hasStartedTyping: $_hasStartedTyping, isDropdownOpen: $_isDropdownOpen',
    );

    if (!_hasStartedTyping && value.isNotEmpty && _selectedEmployee == null) {
      debugPrint(
        '🔍 EmployeeSelector: User started typing, enabling search mode',
      );
      _hasStartedTyping = true;
    }

    if (_isDropdownOpen) {
      debugPrint('🔍 EmployeeSelector: Searching for: "$value"');
      _bloc.add(SearchEmployees(value));
    }
  }

  void _startSearching() {
    debugPrint('🔍 EmployeeSelector: Starting search mode');

    _hasStartedTyping = true;
    _textController.clear();

    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('🎯 EmployeeSelector: Requesting focus for search');
        _focusNode.requestFocus();
      }
    });
  }

  void _onEmployeeSelected(Employee employee) {
    debugPrint('✅ EmployeeSelector: Employee selected: ${employee.name}');

    _hasStartedTyping = false;

    setState(() {
      _selectedEmployee = employee;
    });
    _updateDisplayText();

    if (_fieldState != null) {
      _fieldState!.didChange(employee);
    }

    _bloc.add(SelectEmployee(employee));
    _focusNode.unfocus();
    widget.onChanged?.call(employee);
  }

  void _clearSelection() {
    debugPrint('🗑️ EmployeeSelector: Clearing selection');

    _hasStartedTyping = false;

    setState(() {
      _selectedEmployee = null;
    });
    _textController.clear();

    if (_fieldState != null) {
      _fieldState!.didChange(null);
    }

    _bloc.add(const SelectEmployee(null));
    widget.onChanged?.call(null);
  }

  void _onFieldTapped() {
    debugPrint(
      '👆 EmployeeSelector: Field tapped - selectedEmployee: ${_selectedEmployee?.name}, hasStartedTyping: $_hasStartedTyping, isProcessingTap: $_isProcessingTap',
    );

    if (_isProcessingTap) {
      debugPrint('🚫 EmployeeSelector: Tap already being processed, ignoring');
      return;
    }

    if (_selectedEmployee != null && !_hasStartedTyping) {
      debugPrint('🔄 EmployeeSelector: Switching to search mode');
      _isProcessingTap = true;
      _startSearching();

      Future.delayed(const Duration(milliseconds: 300), () {
        _isProcessingTap = false;
      });
    }
  }

  void _showOverlay() {
    if (_isDropdownOpen || !mounted) {
      debugPrint(
        '⚠️ EmployeeSelector: Cannot show overlay - isOpen: $_isDropdownOpen, mounted: $mounted',
      );
      return;
    }

    debugPrint('📋 EmployeeSelector: Showing dropdown overlay');

    final RenderBox? renderBox =
        _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) {
      debugPrint('⚠️ EmployeeSelector: RenderBox is null, cannot show overlay');
      return;
    }

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              debugPrint('👆 EmployeeSelector: Overlay background tapped');
            },
            child: Stack(
              children: [
                Positioned(
                  left: offset.dx,
                  top: offset.dy + size.height + 4,
                  width: size.width,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 280),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: BlocProvider.value(
                        value: _bloc,
                        child: _DropdownContent(
                          onEmployeeSelected: _onEmployeeSelected,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );

    if (mounted) {
      Overlay.of(context).insert(_overlayEntry!);
      _isDropdownOpen = true;
      debugPrint('✅ EmployeeSelector: Overlay inserted');
    }
  }

  void _removeOverlay() {
    debugPrint('🗑️ EmployeeSelector: Removing overlay');
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      _isDropdownOpen = false;
      debugPrint('✅ EmployeeSelector: Overlay removed');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(
      context,
    ); // IMPORTANTE: Llamar super.build para AutomaticKeepAliveClientMixin

    debugPrint(
      '🏗️ EmployeeSelector: Building widget - selectedEmployee: ${_selectedEmployee?.name}, hasStartedTyping: $_hasStartedTyping',
    );

    return FormBuilderField<Employee>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator: widget.validator,
      builder: (FormFieldState<Employee> field) {
        _fieldState = field;

        final isFieldDisabled = _selectedEmployee != null && !_hasStartedTyping;
        debugPrint('🔒 EmployeeSelector: Field disabled: $isFieldDisabled');

        return RepaintBoundary(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    key: _fieldKey,
                    child: GestureDetector(
                      onTap: isFieldDisabled ? _onFieldTapped : null,
                      child: IgnorePointer(
                        ignoring: isFieldDisabled,
                        child: Focus(
                          skipTraversal: isFieldDisabled,
                          child: TextFormField(
                            // CLAVE: Key que no cambie con rebuilds del padre
                            key: ValueKey('employee_field_${widget.name}'),
                            controller: _textController,
                            maxLines: isFieldDisabled ? 2 : 1,
                            minLines: 1,
                            focusNode: _focusNode,
                            onChanged: _onTextChanged,
                            // Evitar que pierda foco en rebuilds del padre
                            enableInteractiveSelection: true,
                            decoration: InputDecoration(
                              hintText:
                                  isFieldDisabled
                                      ? null
                                      : 'Buscar empleado por nombre o código',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                height: isFieldDisabled ? 1.3 : 1.0,
                                color: isFieldDisabled ? Colors.black87 : null,
                              ),
                              prefixIcon: Icon(
                                LucideIcons.search,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: isFieldDisabled ? 8 : 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor:
                                  isFieldDisabled
                                      ? Colors.grey[50]
                                      : Colors.white,
                              errorText: field.errorText,
                            ),
                            style: TextStyle(
                              color: isFieldDisabled ? Colors.black87 : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_selectedEmployee != null)
                    Positioned(
                      right: 8,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            debugPrint('❌ EmployeeSelector: X button tapped');
                            _clearSelection();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              LucideIcons.x,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_selectedEmployee == null)
                    Positioned(
                      right: 12,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Icon(
                          _isDropdownOpen
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DropdownContent extends StatelessWidget {
  final Function(Employee) onEmployeeSelected;

  const _DropdownContent({required this.onEmployeeSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeSearchBloc, EmployeeSearchState>(
      builder: (context, state) {
        debugPrint(
          '🏗️ DropdownContent: Building content - state: ${state.runtimeType}',
        );

        if (state is EmployeeSearchLoading) {
          return const SizedBox(
            height: 100,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state is EmployeeSearchLoaded) {
          debugPrint(
            '📋 DropdownContent: Showing ${state.employees.length} employees',
          );

          if (state.employees.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.userX, color: Colors.grey[400], size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'No se encontraron empleados',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: state.employees.length,
            itemBuilder: (context, index) {
              final employee = state.employees[index];
              return _EmployeeListItem(
                employee: employee,
                onTap: () {
                  debugPrint(
                    '👆 DropdownContent: Employee item tapped: ${employee.name}',
                  );
                  onEmployeeSelected(employee);
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _EmployeeListItem extends StatelessWidget {
  final Employee employee;
  final VoidCallback onTap;

  const _EmployeeListItem({required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(LucideIcons.user, color: Colors.grey[600], size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${employee.role} - Código ${employee.id}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
