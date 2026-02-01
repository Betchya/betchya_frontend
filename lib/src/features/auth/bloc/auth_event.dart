part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class _AuthStatusChanged extends AuthEvent {
  const _AuthStatusChanged(this.user);

  final User? user;

  @override
  List<Object> get props => [user ?? ''];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
