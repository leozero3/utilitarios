import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:utilitarios/modules/water_reminder/cubit/water_reminder_cubit.dart';
import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';

class WaterReminderForm extends StatefulWidget {
  @override
  _WaterReminderFormState createState() => _WaterReminderFormState();
}

class _WaterReminderFormState extends State<WaterReminderForm> {
  final _formKey = GlobalKey<FormState>();

  // Variáveis para armazenar os valores dos sliders
  double totalLiters = 1.5; // Valor inicial
  double doseAmount = 200; // Valor inicial
  TimeOfDay? startHour;
  TimeOfDay? endHour;

  Future<void> _selectTime(BuildContext context,
      {required bool isStart}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? TimeOfDay(hour: 8, minute: 0)
          : TimeOfDay(hour: 20, minute: 0),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startHour = picked;
        } else {
          endHour = picked;
        }
      });
    }
  }

  int convertTimeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  void _saveReminder() async {
    // Verificar se as notificações estão habilitadas
    bool notificationsEnabled =
        await BlocProvider.of<WaterReminderCubit>(context)
            .notificationService
            .areNotificationsEnable();

    if (!notificationsEnabled) {
      // Se as notificações estiverem desabilitadas, exibir o diálogo
      _showEnableNotificationDialog();
      return; // Não continua até que as notificações estejam habilitadas
    }
    if (startHour != null && endHour != null) {
      final startHourDouble = startHour!.hour + startHour!.minute / 60;
      final endHourDouble = endHour!.hour + endHour!.minute / 60;
      List<double> doseTimes = [];

      final totalWaterInMl = totalLiters * 1000;
      final totalDoses = (totalWaterInMl / doseAmount).ceil();

      // Converte os horários de início e fim para minutos
      final startHourInMinutes = convertTimeOfDayToMinutes(startHour!);
      final endHourInMinutes = convertTimeOfDayToMinutes(endHour!);
      final totalMinutes = endHourInMinutes - startHourInMinutes;

      // Verificar se o total de minutos e doses é válido
      if (totalMinutes <= 0 || totalDoses <= 0) {
        throw UnsupportedError(
            'Intervalo de tempo ou número de doses inválido.');
      }

      final intervalInMinutes = (totalMinutes / totalDoses).ceil();

      // Calcula os horários das doses
      for (int i = 0; i < totalDoses; i++) {
        final doseTimeInMinutes = startHourInMinutes + (i * intervalInMinutes);
        if (doseTimeInMinutes > endHourInMinutes) {
          break; // Para se o tempo da dose exceder o tempo final
        }
        final doseTimeHour = doseTimeInMinutes ~/ 60;
        final doseTimeMinute = doseTimeInMinutes % 60;
        doseTimes.add(doseTimeHour + doseTimeMinute / 60); // Hora decimal
      }

      final reminder = WaterReminderModel(
        id: 0, // Defina o ID correto, se necessário
        totalLiters: totalLiters,
        startHour: startHourDouble,
        endHour: endHourDouble,
        doseAmount: doseAmount,
        doseTimes: doseTimes, // Agora com os horários calculados
      );

      // Salva e agenda as notificações e alarmes
      await BlocProvider.of<WaterReminderCubit>(context)
          .saveWaterReminder(reminder);
    } else {
      // Exibe uma mensagem de erro caso as horas não tenham sido selecionadas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione as horas de início e fim!')),
      );
    }
  }

  Future<void> _showEnableNotificationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ativar Notificações',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
              'As notificações estão desativadas. Por favor, ative-as nas configurações do seu dispositivo para receber lembretes.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop(); // Fechar o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Abrir as configurações do aplicativo
                AppSettings.openAppSettings(type: AppSettingsType.notification);
                context.pop();
              },
              child: Text('Abrir Configurações'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Slider para selecionar a quantidade total de litros de água
            Text('Selecione a quantidade de água (litros):'),
            Text('${totalLiters.toStringAsFixed(1)} L'),
            Slider(
              value: totalLiters,
              min: 0.5, // 500 ml
              max: 4.0, // 4 litros
              divisions: 35, // Incremento de 100ml
              label: '${totalLiters.toStringAsFixed(1)} L',
              onChanged: (value) {
                setState(() {
                  totalLiters = value;
                });
              },
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),

            SizedBox(height: 20),
            // Slider para selecionar a quantidade de água por copo
            Text('Selecione a quantidade por copo (ml):'),
            SizedBox(height: 20),
            Text(
              '${doseAmount.toStringAsFixed(0)} ml por copo',
            ),
            Slider(
              value: doseAmount,
              min: 100, // 100 ml
              max: 1000, // 500 ml
              divisions: 18, // Incremento de 20ml
              label: '${doseAmount.toStringAsFixed(0)} ml',
              onChanged: (value) {
                setState(() {
                  doseAmount = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Selecione o horário de início e término
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _selectTime(context, isStart: true),
                  child: Text(startHour != null
                      ? '${startHour!.hour}:${startHour!.minute.toString().padLeft(2, '0')}'
                      : 'Hora Inicial'),
                ),
                ElevatedButton(
                  onPressed: () => _selectTime(context, isStart: false),
                  child: Text(endHour != null
                      ? '${endHour!.hour}:${endHour!.minute.toString().padLeft(2, '0')}'
                      : 'Hora Final'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Botão para salvar o lembrete
            ElevatedButton(
              onPressed: _saveReminder,
              child: Text('Salvar Lembrete'),
            ),
          ],
        ),
      ),
    );
  }
}
