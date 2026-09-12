import 'package:connectcall/repo/block_repo.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_bloc.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_event.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_state.dart';
import 'package:connectcall/screen/onboard/search/bloc/search_bloc.dart';
import 'package:connectcall/screen/onboard/search/search_screen.dart';
import 'package:connectcall/utils/call_feedback.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_header.dart';
import 'package:connectcall/widgets/app_home_header.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ContactsScreen extends HookWidget {
  const ContactsScreen({super.key});

  static const double _reservedHeight = 210.0;
  static const double _minListHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final lastQueryFromBloc = useRef('');

    final mediaQuery = MediaQuery.of(context);
    final listAreaHeight =
        (mediaQuery.size.height -
                mediaQuery.padding.top -
                mediaQuery.padding.bottom -
                _reservedHeight)
            .clamp(_minListHeight, double.infinity);

    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        if (lastQueryFromBloc.value != state.query) {
          lastQueryFromBloc.value = state.query;
          searchController.text = state.query;
          searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: searchController.text.length),
          );
        }

        return AuthScaffold(
          appHeader: Column(
            children: [
              const CustomHeader(title: 'Contacts'),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, searchState) {
                  if (searchController.text != searchState.query) {
                    searchController.text = searchState.query;
                    searchController.selection = TextSelection.fromPosition(
                      TextPosition(offset: searchController.text.length),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                    child: CustomSearchBar(
                      searchController: searchController,
                      hintText: 'Search contacts',
                      showClearButton: searchState.query.isNotEmpty,
                      onChanged: (query) {
                        if (query != searchState.query) {
                          context.read<SearchBloc>().add(
                            SearchQueryChanged(query),
                          );
                          context.read<ContactBloc>().add(
                            ContactSearchQueryChanged(query),
                          );
                        }
                      },
                      onClear: () {
                        context.read<SearchBloc>().add(SearchQueryChanged(''));
                        context.read<ContactBloc>().add(
                          ContactSearchQueryChanged(''),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: SizedBox(
            height: listAreaHeight,
            child: _ContactListBody(state: state),
          ),
        );
      },
    );
  }
}

class _ContactListBody extends StatelessWidget {
  const _ContactListBody({required this.state});

  final ContactState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == ContactStatus.initial ||
        state.status == ContactStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ContactStatus.failure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Error: ${state.errorMessage ?? "Unknown error"}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final users = state.filteredUsers;
    final frequentUsers = state.frequentUsers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Frequent/Recent Section (Only shown when query is empty and list is not empty)
        if (state.query.isEmpty && frequentUsers.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Recent',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: frequentUsers.length,
              itemBuilder: (context, i) {
                final user = frequentUsers[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: user.photoUrl.isNotEmpty
                            ? NetworkImage(user.photoUrl)
                            : null,
                        child: user.photoUrl.isEmpty
                            ? Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        child: Text(
                          user.name,
                          style: const TextStyle(fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 16, thickness: 1, indent: 16, endIndent: 16),
        ],

        // 2. Main Contacts List Section
        Expanded(
          child: users.isEmpty
              ? Center(
                  child: Text(
                    state.query.isEmpty
                        ? 'No other contacts found'
                        : 'No contacts match "${state.query}"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return GestureDetector(
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => SafeArea(
                            child: ListTile(
                              leading: const Icon(
                                Icons.block,
                                color: Colors.red,
                              ),
                              title: const Text(
                                'Block this user',
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () async {
                                await BlockRepository().blockUser(user.uid);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },

                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: user.photoUrl.isNotEmpty
                                ? NetworkImage(user.photoUrl)
                                : null,
                            child: user.photoUrl.isEmpty
                                ? Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: user.isOnline
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user.isOnline ? 'Online' : 'Offline',
                                  style: TextStyle(
                                    color: user.isOnline
                                        ? Colors.green
                                        : Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final connectivity = await Connectivity()
                                      .checkConnectivity();
                                  if (connectivity.contains(
                                    ConnectivityResult.none,
                                  )) {
                                    CallFeedback.show(
                                      'No internet connection',
                                      isError: true,
                                    );
                                    return;
                                  }
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!await NetworkCheck.checkBeforeCall())
                                      return;
                                  },

                                  child: ZegoSendCallInvitationButton(
                                    buttonSize: const Size(38, 38),
                                    iconSize: const Size(20, 20),
                                    isVideoCall: false,
                                    resourceID: "zego_call",
                                    invitees: [
                                      ZegoUIKitUser(
                                        id: user.uid,
                                        name: user.name,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () async {
                                  final connectivity = await Connectivity()
                                      .checkConnectivity();
                                  if (connectivity.contains(
                                    ConnectivityResult.none,
                                  )) {
                                    CallFeedback.show(
                                      'No internet connection',
                                      isError: true,
                                    );
                                    return;
                                  }
                                },
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!await NetworkCheck.checkBeforeCall())
                                      return;
                                  },

                                  child: ZegoSendCallInvitationButton(
                                    buttonSize: const Size(38, 38),
                                    iconSize: const Size(20, 20),
                                    isVideoCall: true,
                                    resourceID: "zego_call",
                                    invitees: [
                                      ZegoUIKitUser(
                                        id: user.uid,
                                        name: user.name,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
