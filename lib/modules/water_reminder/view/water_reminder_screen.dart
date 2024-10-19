import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/core/constants/app_icons.dart';
import 'package:utilitarios/modules/water_reminder/cubit/water_reminder_cubit.dart';
import 'package:app_settings/app_settings.dart';
import 'package:go_router/go_router.dart';
import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';

part '../widget/water_reminder_form.dart';

class WaterReminderScreen extends StatefulWidget {
  const WaterReminderScreen({super.key});

  @override
  State<WaterReminderScreen> createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<WaterReminderCubit>(context).loadWaterReminder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lembrete de Água')),
      body: BlocBuilder<WaterReminderCubit, WaterReminderState>(
        builder: (context, state) {
          switch (state.status) {
            case WaterReminderStatus.loading:
              return const Center(child: CircularProgressIndicator());

            case WaterReminderStatus.loaded:
              return _buildLoadedState(context, state);

            case WaterReminderStatus.error:
              return _buildErrorState(context, state);

            case WaterReminderStatus.initial:
            default:
              return WaterReminderForm();
          }
        },
      ),
    );
  }
}

Widget _buildLoadedState(BuildContext context, WaterReminderState state) {
  return Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text(
                  'Sua meta diária é de ${state.reminder!.totalLiters} litros de água por dia.',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity, // Card ocupa toda a largura
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Horário: ${state.reminder!.startHour} às ${state.reminder!.endHour}',
                          ),
                          Image.asset(AppIcons.waterClock),
                          Text('Dose média: ${state.reminder!.doseAmount} ml'),
                          Text(
                              'Total de doses: ${state.reminder!.doseTimes.length}'),
                          Image.asset(AppIcons.waterCup, scale: 2.7),
                          Text(
                              'Intervalo entre doses: ${state.reminder!.intervalInMinutes} minutos'),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity, // Botão ocupa toda a largura
          child: ElevatedButton(
            onPressed: () {
              BlocProvider.of<WaterReminderCubit>(context)
                  .deleteWaterReminder(state.reminder!.id);
            },
            child: const Text('Deletar Lembrete'),
          ),
        ),
      ),
    ],
  );
}

Widget _buildErrorState(BuildContext context, WaterReminderState state) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          state.errorMessage ?? 'Erro desconhecido',
          style: const TextStyle(color: Colors.red, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await BlocProvider.of<WaterReminderCubit>(context).resetReminder();
          },
          child: const Text('Resetar Lembrete'),
        ),
      ],
    ),
  );
}
