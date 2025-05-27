part of 'request_filter_bloc.dart';

sealed class RequestFilterEvent extends Equatable {
  const RequestFilterEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialRequests extends RequestFilterEvent {
  final List<RequestData> initialRequests;

  const LoadInitialRequests(this.initialRequests);

  @override
  List<Object> get props => [initialRequests];
}

class SearchTermChanged extends RequestFilterEvent {
  final String searchTerm;

  const SearchTermChanged(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}

class StatusTabChanged extends RequestFilterEvent {
  final int tabIndex;

  const StatusTabChanged(this.tabIndex);

  @override
  List<Object> get props => [tabIndex];
}

class TypeFilterChanged extends RequestFilterEvent {
  final Map<String, bool> selectedTypes;

  const TypeFilterChanged(this.selectedTypes);

  @override
  List<Object> get props => [selectedTypes];
}

class StatusFilterChanged extends RequestFilterEvent {
  final Map<String, bool> selectedStatuses;

  const StatusFilterChanged(this.selectedStatuses);

  @override
  List<Object> get props => [selectedStatuses];
}

class FiltersCleared extends RequestFilterEvent {}
