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
      appBar: AppBar(title: Text('Lembrete de Água')),
      body: BlocBuilder<WaterReminderCubit, WaterReminderState>(
        builder: (context, state) {
          switch (state.status) {
            case WaterReminderStatus.loading:
              return Center(child: CircularProgressIndicator());

            case WaterReminderStatus.loaded:
              // Calcular doses e intervalos
              BlocProvider.of<WaterReminderCubit>(context)
                  .calculateDoseDetails(state.reminder!);

              return Column(
                children: [
                  Text(
                    'Você deseja beber ${state.reminder!.totalLiters} litros de água por dia.',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Horário: ${state.reminder!.startHour} às ${state.reminder!.endHour}',
                  ),
                  Text('Dose média: ${state.reminder!.doseAmount} ml'),
                  Text('Total de doses: ${state.totalDoses}'),
                  Text(
                      'Intervalo entre doses: ${state.intervalInMinutes} minutos'),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<WaterReminderCubit>(context)
                          .deleteWaterReminder(state.reminder!.id);
                    },
                    child: Text('Deletar Lembrete'),
                  ),
                ],
              );

            case WaterReminderStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? 'Erro desconhecido',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await BlocProvider.of<WaterReminderCubit>(context)
                            .resetReminder();
                      },
                      child: Text('Resetar Lembrete'),
                    ),
                  ],
                ),
              );

            case WaterReminderStatus.initial:
            default:
              return WaterReminderForm();
          }
        },
      ),
    );
  }
}
