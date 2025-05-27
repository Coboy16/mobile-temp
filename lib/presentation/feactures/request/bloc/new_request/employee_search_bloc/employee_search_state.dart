part of 'employee_search_bloc.dart';

sealed class EmployeeSearchState extends Equatable {
  const EmployeeSearchState();

  @override
  List<Object> get props => [];
}

class EmployeeSearchInitial extends EmployeeSearchState {
  const EmployeeSearchInitial();
}

class EmployeeSearchLoading extends EmployeeSearchState {
  const EmployeeSearchLoading();
}

class EmployeeSearchLoaded extends EmployeeSearchState {
  final List<Employee> employees;
  final Employee? selectedEmployee;
  final String query;
  final bool isDropdownOpen;

  const EmployeeSearchLoaded({
    required this.employees,
    this.selectedEmployee,
    required this.query,
    required this.isDropdownOpen,
  });

  @override
  List<Object> get props => [
    employees,
    selectedEmployee ?? '',
    query,
    isDropdownOpen,
  ];

  EmployeeSearchLoaded copyWith({
    List<Employee>? employees,
    Employee? selectedEmployee,
    String? query,
    bool? isDropdownOpen,
    bool clearSelectedEmployee = false,
  }) {
    return EmployeeSearchLoaded(
      employees: employees ?? this.employees,
      selectedEmployee:
          clearSelectedEmployee
              ? null
              : selectedEmployee ?? this.selectedEmployee,
      query: query ?? this.query,
      isDropdownOpen: isDropdownOpen ?? this.isDropdownOpen,
    );
  }
}
