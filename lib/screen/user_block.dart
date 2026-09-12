import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcall/models/user_model.dart';
import 'package:connectcall/repo/block_repo.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectcall/widgets/app_auth_scafflod.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key, required this.blockedIds});

  final List<String> blockedIds;

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final _blockRepository = BlockRepository();
  late List<String> _blockedIds;

  @override
  void initState() {
    super.initState();
    _blockedIds = List.from(widget.blockedIds);
  }

  Future<void> _unblock(String uid) async {
    await _blockRepository.unblockUser(uid);
    setState(() => _blockedIds.remove(uid));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      appHeader: AppBar(title: const Text('Blocked Users'), elevation: 0),
      body: _blockedIds.isEmpty
          ?  Center(
              child: Text('No blocked users', style: context.labelLB.copyWith(color: context.error)),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: _blockedIds.length,
              itemBuilder: (context, index) {
                final uid = _blockedIds[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const ListTile(title: Text('Loading...'));
                    }
                    if (!snap.data!.exists) {
                      return ListTile(
                        title: const Text('Unknown user'),
                        trailing: TextButton(
                          onPressed: () => _unblock(uid),
                          child: const Text('Unblock'),
                        ),
                      );
                    }

                    final user = UserModel.fromMap(snap.data!.data() as Map<String, dynamic>);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl) : null,
                          child: user.photoUrl.isEmpty
                              ? Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?')
                              : null,
                        ),
                        title: Text(user.name),
                        trailing: OutlinedButton.icon(
                          icon: const Icon(CupertinoIcons.person_add, size: 16),
                          label: const Text('Unblock'),
                          onPressed: () => _unblock(uid),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}