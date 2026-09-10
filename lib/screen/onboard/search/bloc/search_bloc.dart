import 'package:bloc/bloc.dart';
import 'package:connectcall/repo/search_repo.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository _repo;

  SearchBloc(this._repo) : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);

   
    add(SearchQueryChanged(''));
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(
      status: SearchStatus.loading,
      query: event.query,
    ));

    if (event.query.trim().isEmpty) {
      try {
        final allUsers = await _repo.getAllUsers();
        emit(state.copyWith(
          status: SearchStatus.success,
          allItems: allUsers.map((u) => u.name).toList(),
          filteredItems: allUsers.map((u) => u.name).toList(),
        ));
      } catch (e) {
        emit(state.copyWith(
          status: SearchStatus.failure,
          allItems: [],
          filteredItems: [],
        ));
      }
      return;
    }

    // Non-empty query → search
    try {
      final results = await _repo.searchUsers(event.query);

      emit(state.copyWith(
        status: SearchStatus.success,
        allItems: state.allItems.isEmpty
            ? results.map((u) => u.name).toList()
            : state.allItems,
        filteredItems: results.map((u) => u.name).toList(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SearchStatus.failure,
        filteredItems: [],
      ));
    }
  }
}