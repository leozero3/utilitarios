part of 'password_manager_cubit.dart';

enum PasswordManagerStatus { initial, loading, loaded, error, adding }

class PasswordManagerState extends Equatable {
  final PasswordManagerStatus status;
  final List<Map<String, dynamic>> passwords;
  final String? errorMessage;

  const PasswordManagerState(
      {required this.status, this.passwords = const [], this.errorMessage});

  @override
  List<Object?> get props => [status, passwords, errorMessage];

  PasswordManagerState copyWith({
    PasswordManagerStatus? status,
    List<Map<String, dynamic>>? passwords,
    String? errorMessage,
  }) {
    return PasswordManagerState(
      status: status ?? this.status,
      passwords: passwords ?? this.passwords,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
