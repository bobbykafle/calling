import 'package:connectcall/screen/onboard/contact/bloc/contact_bloc.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_event.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_state.dart';
import 'package:connectcall/screen/onboard/search/bloc/search_bloc.dart';
import 'package:connectcall/screen/onboard/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ContactsScreen extends HookWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final lastQueryFromBloc = useRef('');

    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        // keep the text field in sync when the bloc's query changes
        // from somewhere else (e.g. a clear button elsewhere).
        if (lastQueryFromBloc.value != state.query) {
          lastQueryFromBloc.value = state.query;
          searchController.text = state.query;
          searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: searchController.text.length),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Contacts'), elevation: 0),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: CustomSearchBar(
                  searchController: searchController,
                  hintText: 'Search contacts',
                  showClearButton: state.query.isNotEmpty,
                  onChanged: (query) {
                    if (query != state.query) {
                          context.read<SearchBloc>().add(SearchQueryChanged(query));
                        }
                      },
                      onClear: () {
                        context.read<SearchBloc>().add(SearchQueryChanged(''));
                  },
                ),
              ),
              Expanded(child: _ContactListBody(state: state)),
            ],
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
            'Error: ${state.errorMessage}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final users = state.filteredUsers;

    if (users.isEmpty) {
      return Center(
        child: Text(
          state.query.isEmpty
              ? 'No other contacts found'
              : 'No contacts match "${state.query}"',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: users.length,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage:
                  user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
              child: user.photoUrl.isEmpty
                  ? Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : null,
            ),
            title: Text(user.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: user.isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    user.isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: user.isOnline ? Colors.green : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ZegoSendCallInvitationButton(
                  buttonSize: const Size(38, 38),
                  iconSize: const Size(20, 20),
                  isVideoCall: false,
                  resourceID: "zego_call",
                  invitees: [ZegoUIKitUser(id: user.uid, name: user.name)],
                ),
                const SizedBox(width: 4),
                ZegoSendCallInvitationButton(
                  buttonSize: const Size(38, 38),
                  iconSize: const Size(20, 20),
                  isVideoCall: true,
                  resourceID: "zego_call",
                  invitees: [ZegoUIKitUser(id: user.uid, name: user.name)],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}