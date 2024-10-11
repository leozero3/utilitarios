import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';
import 'package:utilitarios/modules/water_reminder/repository/water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/services/alarm_service.dart';
import 'package:utilitarios/modules/water_reminder/services/notification_service.dart';

part 'water_reminder_state.dart';

class WaterReminderCubit extends Cubit<WaterReminderState> {
  final WaterReminderRepository repository;
  final NotificationService notificationService;
  final AlarmService alarmService;

  WaterReminderCubit(
    this.repository,
    this.notificationService,
    this.alarmService,
  ) : super(WaterReminderState.initial());

  Future<void> loadWaterReminder() async {
    try {
      // Emitir estado de carregamento
      emit(WaterReminderState.loading());

      // Carregar o lembrete do repositório
      final WaterReminderModel? reminder = await repository.loadWaterReminder();

      // Verificar se um lembrete foi encontrado
      if (reminder != null) {
        _scheduleDailyReminders(reminder);
        // Emitir o estado carregado se o lembrete existir
        emit(WaterReminderState.loaded(reminder));
      } else {
        // Emitir o estado inicial se nenhum lembrete for encontrado
        emit(WaterReminderState.initial());
      }
    } catch (e) {
      // Emitir o estado de erro em caso de exceção
      log('Erro ao carregar lembrete de água: $e'); // Log do erro completo
      emit(WaterReminderState.error(
          'Erro ao carregar o lembrete de água. : $e  '));
    }
  }

  Future<void> saveWaterReminder(WaterReminderModel reminder) async {
    try {
      emit(WaterReminderState.loading());
      await repository.saveWaterReminder(reminder);
      _scheduleReminders(reminder);
      emit(WaterReminderState.loaded(reminder));
    } catch (e) {
      emit(WaterReminderState.error('Erro ao salvar o lembrete de agua'));
      log(e.toString());
    }
  }

  Future<void> updateDoseAmount(double newDose) async {
    final currentState = state;
    if (currentState.status == WaterReminderStatus.loaded &&
        currentState.reminder != null) {
      final updatedReminder =
          currentState.reminder!.copyWith(doseAmount: newDose);
      await saveWaterReminder(updatedReminder);
    }
  }

  Future<void> deleteWaterReminder(int id) async {
    try {
      emit(WaterReminderState.loading());
      await repository.deleteWaterReminder(id);
      emit(WaterReminderState.initial());
    } catch (e) {
      emit(WaterReminderState.error('Erro ao excluir o lembrete de agua'));
    }
  }

  void calculateDoseDetails(WaterReminderModel reminder) {
    try {
      final totalLiters = reminder.totalLiters;
      final doseAmount = reminder.doseAmount;
      final startHour = reminder.startHour;
      final endHour = reminder.endHour;

      // Verificar se os valores de entrada são válidos
      if (doseAmount <= 0 || totalLiters <= 0 || startHour >= endHour) {
        throw UnsupportedError('Valores inválidos para cálculo.');
      }

      final totalWaterInMl = totalLiters * 1000;
      final totalDoses = (totalWaterInMl / doseAmount).ceil();

      final startHourInMinutes = (startHour * 60).toInt();
      final endHourInMinutes = (endHour * 60).toInt();
      final totalMinutes = endHourInMinutes - startHourInMinutes;

      // Verificar se o total de minutos e doses é válido
      if (totalMinutes <= 0 || totalDoses <= 0) {
        throw UnsupportedError(
            'Intervalo de tempo ou número de doses inválido.');
      }

      final intervalInMinutes = (totalMinutes / totalDoses).ceil();

      List<double> doseTimes = [];
      for (int i = 0; i < totalDoses; i++) {
        final doseTimeInMinutes = startHourInMinutes + (i * intervalInMinutes);
        final doseTimeHour = doseTimeInMinutes ~/ 60;
        final doseTimeMinute = doseTimeInMinutes % 60;
        doseTimes.add(doseTimeHour + doseTimeMinute / 60); // Hora decimal
      }
      log(doseTimes.toString());

      // Atualizar o lembrete e emitir o estado atualizado
      final updatedReminder = reminder.copyWith(doseTimes: doseTimes);

      emit(state.copyWith(
        reminder: updatedReminder,
        totalDoses: totalDoses,
        intervalInMinutes: intervalInMinutes,
      ));
    } catch (e) {
      log('Erro ao calcular detalhes da dose: $e');
    }
  }

  // void _scheduleReminders(WaterReminderModel reminder) {
  //   final int totalMinutes =
  //       ((reminder.endHour - reminder.startHour) * 60).toInt();
  //   final double intervals =
  //       totalMinutes / (reminder.totalLiters / reminder.doseAmount);
  //   log(intervals.toString());

  //   for (int i = 0;
  //       i <= (reminder.totalLiters / reminder.doseAmount).toInt();
  //       i++) {
  //     int reminderTime = (reminder.startHour * 60 + (intervals * i)).toInt();
  //     int hour = reminderTime ~/ 60;
  //     int minute = reminderTime % 60;
  //     log(reminderTime.toString());

  //     notificationService.scheduleNotification(
  //         hour, minute.toDouble(), 'Hora de beber água!');
  //     alarmService.scheduleAlarm(hour, minute);
  //   }
  // }

  void _scheduleReminders(WaterReminderModel reminder) {
    if (reminder.doseTimes.isEmpty) {
      log('Nenhuma dose a ser agendada.');
      return; // Prevenir loop infinito caso a lista esteja vazia
    }

    for (double doseTime in reminder.doseTimes) {
      final hour = doseTime.toInt();
      final minute = ((doseTime - hour) * 60).toInt();

      // Agendar notificação
      notificationService.scheduleNotification(
        hour,
        minute.toDouble(),
        'Hora de beber água!',
      );

      // Agendar alarme
      alarmService.scheduleAlarm(hour, minute);
      log('Agendado: $hour:$minute');
    }
  }

  void _scheduleDailyReminders(WaterReminderModel reminder) {
    if (reminder.doseTimes.isEmpty) {
      log('Nenhuma dose a ser agendada para o próximo dia.');
      return; // Prevenir loop infinito caso a lista esteja vazia
    }

    final DateTime now = DateTime.now();
    final DateTime resetTime = DateTime(now.year, now.month, now.day + 1, 0, 0);

    // Agendar uma notificação para o reset diário do lembrete à meia-noite
    notificationService.scheduleNotification(
      resetTime.hour,
      resetTime.minute.toDouble(),
      'Reinício do lembrete de água!',
    );

    // Após reset, agendar novamente as doses do dia seguinte
    _scheduleReminders(reminder); // Chamar apenas se houver doses
  }

  Future<void> resetReminder() async {
    try {
      // Emitir estado de carregamento
      emit(WaterReminderState.loading());

      // Excluir todos os lembretes no banco de dados
      await repository.deleteAllReminders();

      // Retornar ao estado inicial
      emit(WaterReminderState.initial());
    } catch (e) {
      emit(WaterReminderState.error('Erro ao resetar o lembrete.'));
      log('Erro ao resetar o lembrete: $e');
    }
  }
}
