import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilitarios/modules/password_manager/passwords/repository/password_repository.dart';

part 'password_manager_state.dart';

class PasswordManagerCubit extends Cubit<PasswordManagerState> {
  final PasswordRepository _passwordRepository;
  PasswordManagerCubit(this._passwordRepository)
      : super(PasswordManagerState(status: PasswordManagerStatus.initial));

  Future<void> addPassword(
      String name, String password, String description) async {
    emit(state.copyWith(status: PasswordManagerStatus.loading));
    try {
      await _passwordRepository.addPassword(name, description, password);
      await loadPassword();
    } catch (e) {
      emit(state.copyWith(
          status: PasswordManagerStatus.error,
          errorMessage: 'Falha ao adicionar senha: $e'));
      log('Falha ao adicionar senha: $e');
    }
  }

  Future<void> loadPassword() async {
    emit(state.copyWith(status: PasswordManagerStatus.loading));
    try {
      final passwords = await _passwordRepository.getPasswords();
      emit(state.copyWith(
          status: PasswordManagerStatus.loaded, passwords: passwords));
    } catch (e) {
      emit(state.copyWith(
          status: PasswordManagerStatus.error,
          errorMessage: 'Falha ao carregar senhas: $e'));
      log('Falha ao carregar senhas: $e');
    }
  }

  Future<void> deletePassword(int id) async {
    emit(state.copyWith(status: PasswordManagerStatus.loading));
    try {
      await _passwordRepository.deletePassword(id);
      await loadPassword();
    } catch (e) {
      emit(state.copyWith(
          status: PasswordManagerStatus.error,
          errorMessage: 'Falha ao deletar senha: $e'));
      log('Falha ao deletar senha: $e');
    }
  }

  Future<void> updatePassword(
      int id, String name, String description, String password) async {
    emit(state.copyWith(status: PasswordManagerStatus.loading));
    try {
      await _passwordRepository.updatePassword(id, name, description, password);
      await loadPassword();
    } catch (e) {
      emit(state.copyWith(
          status: PasswordManagerStatus.error,
          errorMessage: 'Falha ao atualizar senha: $e'));
      log('Falha ao atualizar senha: $e');
    }
  }

  void showAddPasswordForm() {
    emit(state.copyWith(status: PasswordManagerStatus.adding));
  }

  Future<String> getDecryptedPassword(int id) async {
    try {
      return await _passwordRepository.getPasswordById(id);
    } catch (e) {
      emit(state.copyWith(
          status: PasswordManagerStatus.error,
          errorMessage: 'Falha ao descriptografar senha: $e'));
      return '';
    }
  }
}
