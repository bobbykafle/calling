import 'dart:async';
import 'package:connectcall/repo/call_repo.dart';
import 'package:connectcall/repo/contract_repo.dart';
import 'package:connectcall/utils/cache_avatar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactRepository _contactRepository;
  StreamSubscription? _contactsSubscription;
  final CallLogRepository _callLogRepository;

  ContactBloc(this._contactRepository, this._callLogRepository) : super(const ContactState()) {
  on<LoadContacts>(_onLoadContacts);
  on<ContactsUpdated>(_onContactsUpdated);
  on<ContactSearchQueryChanged>(_onSearchQueryChanged);
  on<FrequentContactsUpdated>((e, emit) => emit(state.copyWith(frequentUserIds: e.ids)));

  _callLogRepository.getFrequentContactIds().listen((ids) => add(FrequentContactsUpdated(ids)));
}

  void _onLoadContacts(LoadContacts event, Emitter<ContactState> emit) {
    emit(state.copyWith(status: ContactStatus.loading));
    _contactsSubscription?.cancel();
    _contactsSubscription = _contactRepository.getContacts().listen(
      (users) => add(ContactsUpdated(users)),
      onError: (error) => emit(state.copyWith(
        status: ContactStatus.failure,
        errorMessage: error.toString(),
      )),
    );
  }

  void _onContactsUpdated(ContactsUpdated event, Emitter<ContactState> emit) {
  for (final user in event.users) {
    ZegoAvatarCache.set(user.uid, user.photoUrl);
  }
  emit(state.copyWith(status: ContactStatus.loaded, users: event.users));
}
void _onSearchQueryChanged(
    ContactSearchQueryChanged event, Emitter<ContactState> emit) {
  emit(state.copyWith(query: event.query));
}
 
  @override
  Future<void> close() {
    _contactsSubscription?.cancel();
    return super.close();
  }
}