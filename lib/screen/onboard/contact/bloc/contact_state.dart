import 'package:connectcall/models/user_model.dart';
import 'package:equatable/equatable.dart';

enum ContactStatus { initial, loading, loaded, failure }

class ContactState extends Equatable {
  final ContactStatus status;
  final List<UserModel> users;
  final String query;
  final List<String> frequentUserIds;
  final String? errorMessage;

  const ContactState({
    this.status = ContactStatus.initial,
    this.users = const [],
    this.query = '',
    this.frequentUserIds = const [], 
    this.errorMessage,
  });

  List<UserModel> get filteredUsers {
    if (query.isEmpty) return users;
    final q = query.toLowerCase();
    return users.where((u) => u.name.toLowerCase().contains(q)).toList();
  }

  List<UserModel> get frequentUsers =>
      frequentUserIds.map((id) => users.firstWhere((u) => u.uid == id, orElse: () => users.first)).toList();

  ContactState copyWith({
    ContactStatus? status,
    List<UserModel>? users,
    String? query,
    List<String>? frequentUserIds, 
    String? errorMessage,
  }) {
    return ContactState(
      status: status ?? this.status,
      users: users ?? this.users,
      query: query ?? this.query,
      frequentUserIds: frequentUserIds ?? this.frequentUserIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, users, query, frequentUserIds, errorMessage];
}