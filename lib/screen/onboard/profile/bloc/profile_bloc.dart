import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectcall/repo/profile_repo.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  StreamSubscription? _profileSubscription;
 ProfileRepository get profileRepository => _profileRepository;
  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<ProfileUpdated>(_onProfileUpdated);
    on<EditProfileSubmitted>(_onEditProfileSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) {
    emit(ProfileLoading());
    _profileSubscription?.cancel();
    _profileSubscription = _profileRepository.getCurrentUserProfile().listen(
      (user) => add(ProfileUpdated(user)),
      onError: (error) => emit(ProfileError(error.toString())),
    );
  }

  void _onProfileUpdated(ProfileUpdated event, Emitter<ProfileState> emit) {
    emit(ProfileLoaded(event.user));
  }

  Future<void> _onEditProfileSubmitted(
    EditProfileSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      await _profileRepository.updateProfile(
        name: event.name,
        photoUrl: event.photoUrl,
      );
      
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await _profileRepository.logout();
    emit(ProfileLoggedOut());
  }

  @override
  Future<void> close() {
    _profileSubscription?.cancel();
    return super.close();
  }
}