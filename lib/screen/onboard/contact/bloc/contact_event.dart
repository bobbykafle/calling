import 'package:connectcall/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class LoadContacts extends ContactEvent {}

class ContactsUpdated extends ContactEvent {
  final List<UserModel> users;

  const ContactsUpdated(this.users);

  @override
  List<Object?> get props => [users];
}