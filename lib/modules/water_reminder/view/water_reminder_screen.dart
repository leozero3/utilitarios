import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/water_reminder/cubit/water_reminder_cubit.dart';
import 'package:utilitarios/modules/water_reminder/widget/water_reminder_form.dart';

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
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Você deseja beber ${state.reminder!.totalLiters} litros de água por dia.',
          style: const TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 10),
        Text(
          'Horário: ${state.reminder!.startHour} às ${state.reminder!.endHour}',
        ),
        Text('Dose média: ${state.reminder!.doseAmount} ml'),
        Text('Total de doses: ${state.totalDoses}'),
        Text('Intervalo entre doses: ${state.intervalInMinutes} minutos'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<WaterReminderCubit>(context)
                    .deleteWaterReminder(state.reminder!.id);
              },
              child: const Text('Deletar Lembrete'),
            ),
            ElevatedButton(
              onPressed: () async {
                await BlocProvider.of<WaterReminderCubit>(context)
                    .resetReminder();
              },
              child: const Text('Resetar Lembrete'),
            ),
          ],
        ),
      ],
    ),
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
