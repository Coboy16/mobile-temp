part of 'request_filter_bloc.dart';

class RequestFilterState extends Equatable {
  final List<RequestData> allRequests;
  final List<RequestData> filteredRequests;
  final String searchTerm;
  final int selectedTabIndex;
  final Map<String, bool> selectedTypes;
  final Map<String, bool> selectedStatuses;

  const RequestFilterState({
    this.allRequests = const [],
    this.filteredRequests = const [],
    this.searchTerm = '',
    this.selectedTabIndex = 0, // 0: Todas
    this.selectedTypes = const {},
    this.selectedStatuses = const {},
  });

  RequestFilterState copyWith({
    List<RequestData>? allRequests,
    List<RequestData>? filteredRequests,
    String? searchTerm,
    int? selectedTabIndex,
    Map<String, bool>? selectedTypes,
    Map<String, bool>? selectedStatuses,
  }) {
    return RequestFilterState(
      allRequests: allRequests ?? this.allRequests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      searchTerm: searchTerm ?? this.searchTerm,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedTypes: selectedTypes ?? this.selectedTypes,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
    );
  }

  @override
  List<Object?> get props => [
    allRequests,
    filteredRequests,
    searchTerm,
    selectedTabIndex,
    selectedTypes,
    selectedStatuses,
  ];
}
