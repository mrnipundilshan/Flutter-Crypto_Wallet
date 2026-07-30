import 'package:equatable/equatable.dart';

enum AppRootStatus { loading, needsOnboarding, needsUnlock }

class AppRootState extends Equatable {
  final AppRootStatus status;

  const AppRootState({this.status = AppRootStatus.loading});

  @override
  List<Object?> get props => [status];
}
