import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/presentation/feactures/request/temp/mock_data.dart';

part 'request_filter_event.dart';
part 'request_filter_state.dart';

class RequestFilterBloc extends Bloc<RequestFilterEvent, RequestFilterState> {
  RequestFilterBloc() : super(RequestFilterState()) {
    on<LoadInitialRequests>(_onLoadInitialRequests);
    on<SearchTermChanged>(_onSearchTermChanged);
    on<StatusTabChanged>(_onStatusTabChanged);
    on<TypeFilterChanged>(_onTypeFilterChanged);
    on<StatusFilterChanged>(_onStatusFilterChanged);
    on<FiltersCleared>(_onFiltersCleared);
  }

  void _onLoadInitialRequests(
    LoadInitialRequests event,
    Emitter<RequestFilterState> emit,
  ) {
    final initialState = RequestFilterState(
      allRequests: event.initialRequests,
      filteredRequests: event.initialRequests, // Initially show all
      selectedTypes: _initializeFilterMap(
        event.initialRequests.map((r) => r.type).toSet().toList(),
      ),
      selectedStatuses: _initializeFilterMap([
        'Pendiente',
        'Aprobada',
        'Rechazada',
      ]),
    );
    emit(_applyFilters(initialState));
  }

  void _onSearchTermChanged(
    SearchTermChanged event,
    Emitter<RequestFilterState> emit,
  ) {
    emit(_applyFilters(state.copyWith(searchTerm: event.searchTerm)));
  }

  void _onStatusTabChanged(
    StatusTabChanged event,
    Emitter<RequestFilterState> emit,
  ) {
    emit(_applyFilters(state.copyWith(selectedTabIndex: event.tabIndex)));
  }

  void _onTypeFilterChanged(
    TypeFilterChanged event,
    Emitter<RequestFilterState> emit,
  ) {
    emit(_applyFilters(state.copyWith(selectedTypes: event.selectedTypes)));
  }

  void _onStatusFilterChanged(
    StatusFilterChanged event,
    Emitter<RequestFilterState> emit,
  ) {
    emit(
      _applyFilters(state.copyWith(selectedStatuses: event.selectedStatuses)),
    );
  }

  void _onFiltersCleared(
    FiltersCleared event,
    Emitter<RequestFilterState> emit,
  ) {
    final clearedState = state.copyWith(
      searchTerm: '',
      // Reset selected types/statuses based on how they were initialized
      selectedTypes: _initializeFilterMap(
        state.allRequests.map((r) => r.type).toSet().toList(),
      ),
      selectedStatuses: _initializeFilterMap([
        'Pendiente',
        'Aprobada',
        'Rechazada',
      ]),
      // Keep selectedTabIndex or reset it depending on desired behavior
      // selectedTabIndex: 0,
    );
    emit(_applyFilters(clearedState));
  }

  Map<String, bool> _initializeFilterMap(List<String> items) {
    return {for (var item in items) item: false};
  }

  RequestFilterState _applyFilters(RequestFilterState currentState) {
    List<RequestData> filtered = List.from(currentState.allRequests);

    // 1. Filter by Status Tab
    if (currentState.selectedTabIndex == 1) {
      filtered = filtered.where((req) => req.status == 'Pendiente').toList();
    } else if (currentState.selectedTabIndex == 2) {
      filtered = filtered.where((req) => req.status == 'Aprobada').toList();
    } else if (currentState.selectedTabIndex == 3) {
      filtered = filtered.where((req) => req.status == 'Rechazada').toList();
    }

    // 2. Filter by Type Checkboxes
    final activeTypeFilters =
        currentState.selectedTypes.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList();
    if (activeTypeFilters.isNotEmpty) {
      filtered =
          filtered
              .where((req) => activeTypeFilters.contains(req.type))
              .toList();
    }

    // 3. Filter by Status Checkboxes
    final activeStatusFilters =
        currentState.selectedStatuses.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList();
    if (activeStatusFilters.isNotEmpty) {
      filtered =
          filtered
              .where((req) => activeStatusFilters.contains(req.status))
              .toList();
    }

    // 4. Filter by Search Term
    if (currentState.searchTerm.isNotEmpty) {
      final searchTermLower = currentState.searchTerm.toLowerCase().trim();
      if (searchTermLower.isNotEmpty) {
        filtered =
            filtered.where((req) {
              final nameLower = req.employeeName.toLowerCase();
              final codeLower = req.employeeCode.toLowerCase();
              return nameLower.contains(searchTermLower) ||
                  codeLower.contains(searchTermLower);
            }).toList();
      }
    }

    return currentState.copyWith(filteredRequests: filtered);
  }
}
