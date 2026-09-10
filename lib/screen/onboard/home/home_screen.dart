import 'package:connectcall/repo/search_repo.dart';
import 'package:connectcall/screen/onboard/search/bloc/search_bloc.dart';
import 'package:connectcall/screen/onboard/search/search_screen.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_header.dart';
import 'package:connectcall/widgets/app_home_header.dart';
import 'package:connectcall/widgets/app_space.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;
  String _lastQueryFromBloc = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(SearchRepository()),
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          // Optional: handle errors, navigation, etc.
        },
        builder: (context, state) {
          // Sync controller only when query actually changes
          if (_lastQueryFromBloc != state.query) {
            _lastQueryFromBloc = state.query;
            _searchController.text = state.query;
            _searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: _searchController.text.length),
            );
          }

          return AuthScaffold(
            appHeader: Column(
              children: [
            
                const AppHomeHeader(title: "Welcome  to  Cally", ),
                
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (_searchController.text != state.query) {
                      _searchController.text = state.query;
                      _searchController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _searchController.text.length),
                      );
                    }

                    return CustomSearchBar(
                      searchController: _searchController,
                      hintText: "Who you're looking for?",
                      showClearButton: state.query.isNotEmpty,
                      onChanged: (query) {
                        if (query != state.query) {
                          context.read<SearchBloc>().add(SearchQueryChanged(query));
                        }
                      },
                      onClear: () {
                        context.read<SearchBloc>().add(SearchQueryChanged(''));
                      },
                    );
                  },
                ),
              ],
            ),
           body: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    const SizedBox(height: 12),
    SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.status == SearchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SearchStatus.failure) {
            return  Center(
              child: Text(
                'Something went wrong',
                style: context.labelMB.copyWith(color: context.error),
              ),
            );
          }

          if (state.filteredItems.isEmpty) {
            return  Center(
              child: Text(
                'No contacts found',
                style: context.labelLM,
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.filteredItems.length,
            itemBuilder: (context, index) {
              final name = state.filteredItems[index];
              return ListTile(
                leading: const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
                title: Text(name),
                subtitle: const Text('Online'),
                onTap: () {
                  // open chat / profile
                },
              );
            },
          );
        },
      ),
    ),
  ],
),
                    
                  
                
              
          
          );
        },
      ),
    );
  }
}