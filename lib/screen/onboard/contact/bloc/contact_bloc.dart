// screen/contact/bloc/contact_bloc.dart
import 'dart:async';
import 'package:connectcall/repo/contract_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactRepository;
  StreamSubscription? _contactsSubscription;

  ContactBloc(this._contactRepository) : super(ContactInitial()) {
    on<LoadContacts>(_onLoadContacts);
    on<ContactsUpdated>(_onContactsUpdated);
  }

  void _onLoadContacts(LoadContacts event, Emitter<ContactState> emit) {
    emit(ContactLoading());
    _contactsSubscription?.cancel();
    _contactsSubscription = _contactRepository.getContacts().listen(
      (users) => add(ContactsUpdated(users)),
      onError: (error) => emit(ContactError(error.toString())),
    );
  }

  void _onContactsUpdated(ContactsUpdated event, Emitter<ContactState> emit) {
    emit(ContactLoaded(event.users));
  }

  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}