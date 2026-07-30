import 'package:equatable/equatable.dart';

abstract class AppRootEvent extends Equatable {
  const AppRootEvent();

  @override
  List<Object?> get props => [];
}

class AppStartupRequested extends AppRootEvent {}
