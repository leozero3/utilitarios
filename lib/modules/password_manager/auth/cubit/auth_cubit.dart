import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class AuthCubit extends Cubit<bool> {
  final LocalAuthentication localAuth;
  final String storedPin = 'seu_pin_aqui'; // Defina seu PIN correto aqui

  AuthCubit(this.localAuth) : super(false);

  Future<void> authenticate() async {
    emit(false); // Reseta o estado antes da autenticação
    try {
      bool authenticated = await localAuth.authenticate(
        localizedReason: 'Autentique-se para acessar o gerenciador de senhas',
        options: const AuthenticationOptions(
          sensitiveTransaction: false,
          useErrorDialogs: true, // Permite exibir diálogos de erro padrão
        ),
      );
      emit(authenticated);
    } catch (e) {
      emit(false); // Em caso de erro, garante que o estado seja falso
    }
  }

  // void authenticateWithPin(String pin) {
  //   if (pin == storedPin) {
  //     emit(true); // Emite verdadeiro se o PIN estiver correto
  //   } else {
  //     emit(false); // Emite falso se o PIN estiver incorreto
  //   }
  // }

  Future<bool> checkBiometricSupport() async {
    bool canAuthenticateWithBiometrics = false;

    try {
      canAuthenticateWithBiometrics = await localAuth.canCheckBiometrics;
    } catch (e) {
      print("Erro ao verificar suporte biométrico: $e");
    }

    return canAuthenticateWithBiometrics;
  }
}
