import 'package:equatable/equatable.dart';

class MainshallState extends Equatable {
  final int selectedIndex;

  const MainshallState({this.selectedIndex = 0});

  @override
  List<Object?> get props => [selectedIndex];
}