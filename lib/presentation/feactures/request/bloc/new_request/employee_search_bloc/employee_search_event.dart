part of 'employee_search_bloc.dart';

sealed class EmployeeSearchEvent extends Equatable {
  const EmployeeSearchEvent();

  @override
  List<Object> get props => [];
}

class SearchEmployees extends EmployeeSearchEvent {
  final String query;

  const SearchEmployees(this.query);

  @override
  List<Object> get props => [query];
}

class SelectEmployee extends EmployeeSearchEvent {
  final Employee? employee;

  const SelectEmployee(this.employee);

  @override
  List<Object> get props => [employee ?? Object()];
}

class ClearSearch extends EmployeeSearchEvent {
  const ClearSearch();
}
