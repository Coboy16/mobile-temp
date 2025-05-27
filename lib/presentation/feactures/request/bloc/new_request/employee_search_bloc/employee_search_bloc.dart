import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/data/data.dart';
import '/presentation/feactures/request/temp/app_data.dart';

part 'employee_search_event.dart';
part 'employee_search_state.dart';

class EmployeeSearchBloc
    extends Bloc<EmployeeSearchEvent, EmployeeSearchState> {
  EmployeeSearchBloc() : super(EmployeeSearchInitial()) {
    on<SearchEmployees>(_onSearchEmployees);
    on<SelectEmployee>(_onSelectEmployee);
    on<ClearSearch>(_onClearSearch);
  }

  void _onSearchEmployees(
    SearchEmployees event,
    Emitter<EmployeeSearchState> emit,
  ) async {
    emit(const EmployeeSearchLoading());

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    List<Employee> filteredEmployees;

    if (event.query.isEmpty) {
      filteredEmployees = kMockEmployees;
    } else {
      filteredEmployees =
          kMockEmployees
              .where(
                (employee) =>
                    employee.name.toLowerCase().contains(
                      event.query.toLowerCase(),
                    ) ||
                    employee.id.toLowerCase().contains(
                      event.query.toLowerCase(),
                    ),
              )
              .toList();
    }

    final currentState = state;
    final selectedEmployee =
        currentState is EmployeeSearchLoaded
            ? currentState.selectedEmployee
            : null;

    emit(
      EmployeeSearchLoaded(
        employees: filteredEmployees,
        selectedEmployee: selectedEmployee,
        query: event.query,
        isDropdownOpen: true,
      ),
    );
  }

  void _onSelectEmployee(
    SelectEmployee event,
    Emitter<EmployeeSearchState> emit,
  ) {
    final currentState = state;
    if (currentState is EmployeeSearchLoaded) {
      emit(
        currentState.copyWith(
          selectedEmployee: event.employee,
          isDropdownOpen: false,
        ),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<EmployeeSearchState> emit) {
    emit(
      const EmployeeSearchLoaded(
        employees: [],
        query: '',
        isDropdownOpen: false,
      ),
    );
  }
}
