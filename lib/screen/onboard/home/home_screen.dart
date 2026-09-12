import 'package:connectcall/routes/app_routes.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_bloc.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_event.dart';
import 'package:connectcall/screen/onboard/contact/bloc/contact_state.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_bloc.dart';
import 'package:connectcall/screen/onboard/profile/bloc/profile_state.dart';
import 'package:connectcall/screen/onboard/search/search_screen.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:connectcall/widgets/app_home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  static const double _reservedHeight = 200.0;
  static const double _minListHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();

    final mediaQuery = MediaQuery.of(context);
    final listAreaHeight = (mediaQuery.size.height -
            mediaQuery.padding.top -
            mediaQuery.padding.bottom -
            _reservedHeight)
        .clamp(_minListHeight, double.infinity);

    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        if (searchController.text != state.query) {
          searchController.text = state.query;
          searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: searchController.text.length),
          );
        }

        return AuthScaffold(
          appHeader: Column(
  children: [
    BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        String? photoUrl;
        if (profileState is ProfileLoaded) {
          photoUrl = profileState.user.photoUrl;
        }

        return AppHomeHeader(
          title: "Welcome  to  Cally",
          avatarUrl: (photoUrl != null && photoUrl.isNotEmpty) ? photoUrl : null,
          onAvatarTap: () {
           
          },
        );
      },
    ),
              CustomSearchBar(
                searchController: searchController,
                hintText: "Who you're looking for?",
                showClearButton: state.query.isNotEmpty,
                onChanged: (query) {
                  if (query != state.query) {
                    context.read<ContactBloc>().add(ContactSearchQueryChanged(query));
                  }
                },
                onClear: () {
                  context.read<ContactBloc>().add(const ContactSearchQueryChanged(''));
                },
              ),
            ],
          ),
          body: SizedBox(
            height: listAreaHeight,
            child: _HomeResultsList(state: state),
          ),
        );
      },
    );
  }
}

class _HomeResultsList extends StatelessWidget {
  const _HomeResultsList({required this.state});

  final ContactState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == ContactStatus.initial || state.status == ContactStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ContactStatus.failure) {
      return Center(
        child: Text('Something went wrong', style: context.labelMB.copyWith(color: context.error)),
      );
    }

    final users = state.filteredUsers;

    if (users.isEmpty) {
      return Center(child: Text('No contacts found', style: context.labelLM));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: users.length,
      separatorBuilder: (context,index){
        return Divider(color: context.onSurface.withOpacity(0.2));
      },
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: CircleAvatar(
            radius: 24,
            backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
            child: user.photoUrl.isEmpty
                ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?')
                : null,
          ),
          title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          subtitle: Row(
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
                style: TextStyle(color: user.isOnline ? Colors.green : Colors.grey, fontSize: 12),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ZegoSendCallInvitationButton(
                buttonSize: const Size(36, 36),
                iconSize: const Size(18, 18),
                isVideoCall: false,
                resourceID: "zego_call",
                invitees: [ZegoUIKitUser(id: user.uid, name: user.name)],
              ),
              const SizedBox(width: 2),
              ZegoSendCallInvitationButton(
                buttonSize: const Size(36, 36),
                iconSize: const Size(18, 18),
                isVideoCall: true,
                resourceID: "zego_call",
                invitees: [ZegoUIKitUser(id: user.uid, name: user.name)],
              ),
            ],
          ),
        );
       
      },
      
    );
  }
}