import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilitarios/main.dart';
import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';
import 'package:utilitarios/modules/water_reminder/repository/water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

part 'water_reminder_state.dart';

class WaterReminderCubit extends Cubit<WaterReminderState> {
  final WaterReminderRepository repository;
  final NotificationService notificationService;
  // final AlarmService alarmService;

  WaterReminderCubit(
    this.repository,
    this.notificationService,
    // this.alarmService,
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
        log('loadWaterReminder loaded');
      } else {
        // Emitir o estado inicial se nenhum lembrete for encontrado
        emit(WaterReminderState.initial());
        log('loadWaterReminder initial');
      }
      log('loadWaterReminder--------------------------------');
    } on Exception catch (e) {
      // Emitir o estado de erro em caso de exceção
      log('Erro ao carregar lembrete de água: $e'); // Log do erro completo
      emit(WaterReminderState.error(
          'Erro ao carregar o lembrete de água. : $e  '));
    }
  }

  Future<void> saveWaterReminder(WaterReminderModel reminder) async {
    try {
      emit(WaterReminderState.loading());

      // Cálculo dos horários das doses antes de salvar
      await calculateDoseDetails(reminder);

      await repository.saveWaterReminder(reminder);
      _scheduleReminders(reminder);
      emit(WaterReminderState.loaded(
        reminder,
      ));

      log('Salvou ------------------');
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

  Future<void> calculateDoseDetails(WaterReminderModel reminder) async {
    try {
      final totalLiters = reminder.totalLiters;
      final doseAmount = reminder.doseAmount;
      final startHour = reminder.startHour;
      final endHour = reminder.endHour;
      List<double> doseTimes = [];

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

      // Reset the doseTimes list to prevent duplicate or infinite loops

      for (int i = 0; i < totalDoses; i++) {
        final doseTimeInMinutes = startHourInMinutes + (i * intervalInMinutes);
        if (doseTimeInMinutes > endHourInMinutes) {
          break; // Stop if dose time exceeds the end time
        }
        final doseTimeHour = doseTimeInMinutes ~/ 60;
        final doseTimeMinute = doseTimeInMinutes % 60;
        doseTimes.add(doseTimeHour + doseTimeMinute / 60); // Hora decimal
        reminder.doseTimes;
        log('-----------Dose time: $doseTimeHour:$doseTimeMinute');
        log('-----------Dosetimes -----: $doseTimes');
      }

      log('Calculated doseTimes: $doseTimes');

      // Atualizar o lembrete e emitir o estado atualizado
      final updatedReminder = reminder.copyWith(doseTimes: doseTimes);
      log('Estado anterior: ${state.toString()}');

      // emit(state.copyWith(
      //   status: WaterReminderStatus.loading,
      //   reminder: updatedReminder,
      //   totalDoses: totalDoses,
      //   intervalInMinutes: intervalInMinutes,
      // ));
      log('Novo estado emitido: ${state.copyWith}');

      log('Total Doses: $totalDoses, Interval in Minutes: $intervalInMinutes');
      log('Valores calculados - Total Doses: $totalDoses, Intervalo em Minutos: $intervalInMinutes');
    } catch (e) {
      log('Erro ao calcular detalhes da dose: $e');
    }
  }

  void _scheduleReminders(WaterReminderModel reminder) {
    if (reminder.doseTimes.isEmpty) {
      log('Nenhuma dose a ser agendada.');
      return;
    }

    for (double doseTime in reminder.doseTimes) {
      final hour = doseTime.toInt();
      final minute = ((doseTime - hour) * 60).toInt();

      if (hour >= 0 && hour <= 23 && minute >= 0 && minute < 60) {
        final now = DateTime.now();
        final scheduledDate = DateTime(
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        // Convertemos DateTime para TZDateTime (se estiver usando timezones)
        final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

        // Usando um ID único para cada notificação
        final notificationId = scheduledDate.millisecondsSinceEpoch ~/ 1000;

        // Agendar notificação
        notificationService.scheduleNotification(
          notificationId, // O ID da notificação (int)
          'Hora de beber água!', // Título da notificação
          'Beba ${reminder.doseAmount.toString()} ml de água', // Conteúdo da notificação
          tzScheduledDate, // A data e hora (TZDateTime)
        );

        log('Agendado: $hour:$minute');
      } else {
        log('Horário de dose inválido: $hour:$minute');
      }
    }
  }

  void _scheduleDailyReminders(WaterReminderModel reminder) async {
    // Limpar notificações antigas
    await flutterLocalNotificationsPlugin.cancelAll();

    for (int i = 0; i < reminder.doseTimes.length; i++) {
      // Calcular o horário da dose baseado em doseTimes
      final doseTime = reminder.doseTimes[i];
      final scheduledTime = DateTime.now().add(Duration(
          hours: doseTime.floor(), minutes: ((doseTime % 1) * 60).toInt()));

      // Agendar a notificação com TZDateTime
      await notificationService.scheduleNotification(
        i, // ID único para cada notificação
        'Hora de beber água!',
        'Beba ${reminder.doseAmount} ml de água',
        scheduledTime,
      );
    }
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
