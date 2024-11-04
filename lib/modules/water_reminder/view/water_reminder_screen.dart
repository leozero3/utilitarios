import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:utilitarios/core/constants/app_icons.dart';
import 'package:utilitarios/modules/water_reminder/cubit/water_reminder_cubit.dart';
import 'package:app_settings/app_settings.dart';
import 'package:go_router/go_router.dart';
import 'package:utilitarios/modules/water_reminder/model/water_reminder_model.dart';
import 'package:utilitarios/modules/water_reminder/repository/water_reminder_repository.dart';
import 'package:utilitarios/modules/water_reminder/services/notification_service.dart';

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
    log('init');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WaterReminderCubit>().loadWaterReminder();
    });
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
                  'Sua meta diária é de ${state.reminder!.totalLiters.toStringAsFixed(1)} litros',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity, // Card ocupa toda a largura
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: Column(
                                children: [
                                  Image.asset(AppIcons.waterClock),
                                  Text(
                                    '${formatHourAndMinute(state.reminder!.startHour)} às ${formatHourAndMinute(state.reminder!.endHour)}',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                                'Dose média: ${state.reminder!.doseAmount} ml'),
                            const SizedBox(height: 20),
                            Text(
                                'Intervalo entre doses: ${state.reminder!.intervalInMinutes} minutos'),
                            const SizedBox(height: 20),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                      'Total de doses: ${state.reminder!.doseTimes.length}'),
                                  const SizedBox(height: 5),
                                  Wrap(
                                    spacing: 8,
                                    children: List.generate(
                                      state.reminder!.doseTimes.length,
                                      (index) {
                                        double doseTime = index == 0
                                            ? state.reminder!.startHour
                                            : state.reminder!.doseTimes[index];

                                        // Obtém o horário atual
                                        DateTime now = DateTime.now();

                                        // Converte doseTime para o formato de DateTime para fazer a comparação
                                        DateTime doseDateTime = DateTime(
                                          now.year,
                                          now.month,
                                          now.day,
                                          doseTime.floor(), // Horas
                                          (doseTime % 1 * 60)
                                              .toInt(), // Minutos
                                        );

                                        // Verifica se o horário atual já passou do horário da dose
                                        bool isPast = now.isAfter(doseDateTime);

                                        return Column(
                                          children: [
                                            Image.asset(
                                              isPast
                                                  ? AppIcons.waterCupE
                                                  : AppIcons
                                                      .waterCupF, // Muda a imagem se o horário já passou
                                              scale: 2.7,
                                            ),
                                            Text(
                                              formatHourAndMinute(doseTime),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      deleteButton(context, state),
    ],
  );
}

Padding deleteButton(BuildContext context, WaterReminderState state) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Mostrar o diálogo de confirmação
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Confirmar exclusão'),
                content:
                    const Text('Tem certeza que deseja deletar este lembrete?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Fechar o diálogo ao clicar em "Cancelar"
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Acessar o WaterReminderCubit e deletar o lembrete
                      BlocProvider.of<WaterReminderCubit>(context)
                          .deleteWaterReminder(state.reminder!.id);

                      // Fechar o diálogo
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Deletar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Deletar Lembrete'),
      ),
    ),
  );
}

String formatHourAndMinute(double hour) {
  int minutes = (hour % 1 * 60).toInt();
  return '${(hour ~/ 1).toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
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
