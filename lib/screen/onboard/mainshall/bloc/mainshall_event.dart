
import 'package:equatable/equatable.dart';

abstract class MainshallEvent extends Equatable {
  const MainshallEvent();

  @override
  List<Object?> get props => [];
}

class NavigationTabChanged extends MainshallEvent {
  final int tabIndex;

  const NavigationTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}