import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/water_reminder/cubit/water_reminder_cubit.dart';
import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';

class WaterReminderForm extends StatefulWidget {
  @override
  _WaterReminderFormState createState() => _WaterReminderFormState();
}

class _WaterReminderFormState extends State<WaterReminderForm> {
  final _formKey = GlobalKey<FormState>();
  double? totalLiters;
  TimeOfDay? startHour;
  TimeOfDay? endHour;
  double? doseAmount;

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

  void _saveReminder() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // Aqui salvamos os valores dos campos de formulário

      if (startHour != null && endHour != null) {
        final startHourDouble = startHour!.hour + startHour!.minute / 60;
        final endHourDouble = endHour!.hour + endHour!.minute / 60;

        final reminder = WaterReminderModel(
          id: 0, // Defina o ID correto, se necessário
          totalLiters: totalLiters ?? 0.0,
          startHour: startHourDouble,
          endHour: endHourDouble,
          doseAmount: doseAmount ?? 0.0,
          doseTimes: [], // Será calculado pelo Cubit
        );

        // Salva e agenda as notificações e alarmes
        await BlocProvider.of<WaterReminderCubit>(context)
            .saveWaterReminder(reminder);
      } else {
        // Exiba uma mensagem de erro caso as horas não sejam selecionadas
        print('Hora de início ou fim não foi selecionada');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Total de Litros'),
            keyboardType: TextInputType.number,
            validator: (value) {
              final liters = double.tryParse(value ?? '');
              if (liters == null || liters <= 0) {
                return 'Insira um valor válido para litros';
              }
              return null;
            },
            onSaved: (value) => totalLiters = double.tryParse(value!),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _selectTime(context, isStart: true),
                child: Text(startHour != null
                    ? '${startHour!.hour}:${startHour!.minute.toString().padLeft(2, '0')}'
                    : 'Selecionar Hora Inicial'),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context, isStart: false),
                child: Text(endHour != null
                    ? '${endHour!.hour}:${endHour!.minute.toString().padLeft(2, '0')}'
                    : 'Selecionar Hora Final'),
              ),
            ],
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Quantidade por Dose (ml)'),
            keyboardType: TextInputType.number,
            onSaved: (value) => doseAmount = double.tryParse(value!),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     if (_formKey.currentState!.validate()) {
          //       _formKey.currentState!.save();
          //       final reminder = WaterReminderModel(
          //         id: 1,
          //         totalLiters: totalLiters!,
          //         // Converte TimeOfDay para double (hora + minutos em decimal)
          //         startHour: startHour!.hour + (startHour!.minute / 60),
          //         endHour: endHour!.hour + (endHour!.minute / 60),
          //         doseAmount: doseAmount!, doseTimes: [],
          //       );
          //       BlocProvider.of<WaterReminderCubit>(context)
          //           .saveWaterReminder(reminder);
          //     }
          //   },
          //   child: Text('Salvar'),
          // ),
          ElevatedButton(
            onPressed: _saveReminder,
            child: Text('Salvar Lembrete'),
          ),
        ],
      ),
    );
  }
}
