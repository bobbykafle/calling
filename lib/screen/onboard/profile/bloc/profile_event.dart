import 'package:connectcall/models/user_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class ProfileUpdated extends ProfileEvent {
  final UserModel user;
  const ProfileUpdated(this.user);
  @override
  List<Object?> get props => [user];
}

class EditProfileSubmitted extends ProfileEvent {
  final String name;
  final String? photoUrl;
  final String? email;
  const EditProfileSubmitted({required this.name, this.photoUrl, this.email});
  @override
  List<Object?> get props => [name, photoUrl];
}

class LogoutRequested extends ProfileEvent {
  const LogoutRequested();
}