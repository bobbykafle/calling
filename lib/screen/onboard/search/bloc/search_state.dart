part of 'search_bloc.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState {
  final SearchStatus status;
  final List<String> allItems;        // not used now, but keep for flexibility
  final List<String> filteredItems;
  final String query;

  const SearchState({
    this.status = SearchStatus.initial,
    this.allItems = const [],
    this.filteredItems = const [],
    this.query = '',
  });

  SearchState copyWith({
    SearchStatus? status,
    List<String>? allItems,
    List<String>? filteredItems,
    String? query,
  }) {
    return SearchState(
      status: status ?? this.status,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      query: query ?? this.query,
    );
  }
}