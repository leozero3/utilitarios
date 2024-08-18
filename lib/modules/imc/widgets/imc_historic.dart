import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilitarios/modules/imc/bloc/imc_history_bloc.dart';
import 'package:intl/intl.dart';

class ImcHistoric extends StatelessWidget {
  const ImcHistoric({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ImcHistoryBloc, ImcHistoryState>(
          builder: (context, state) {
            bool isHistoryVisible = state is ImcHistoryLoaded;
            return TextButton(
              onPressed: () {
                if (isHistoryVisible) {
                  context.read<ImcHistoryBloc>().add(HideImcHistoryEvent());
                } else {
                  context.read<ImcHistoryBloc>().add(LoadImcHistoryEvent());
                }
              },
              child: Text(
                isHistoryVisible ? 'Ocultar Histórico' : 'Exibir Histórico',
              ),
            );
          },
        ),
        BlocBuilder<ImcHistoryBloc, ImcHistoryState>(
          builder: (context, state) {
            if (state is ImcHistoryLoaded) {
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        state.history.length + 1, // +1 para o carregamento
                    itemBuilder: (context, index) {
                      if (index == state.history.length) {
                        // Verifica se pode carregar mais itens
                        if (state.canLoadMore) {
                          context
                              .read<ImcHistoryBloc>()
                              .add(LoadMoreImcHistoryEvent());
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }

                      final imc = state.history[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Data: ${DateFormat('dd/MM/yyyy').format(imc.date!)}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('IMC: ${imc.imc?.toStringAsFixed(2)}'),
                                  Text(
                                      'Peso: ${imc.peso.toStringAsFixed(1)} kg'),
                                  Text(
                                      'Altura: ${imc.altura.toStringAsFixed(2)} m'),
                                  Text('Categoria: ${imc.categoriaImc()}'),
                                ],
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<ImcHistoryBloc>()
                                      .add(DeleteImcHistoryEvent(imc.id!));
                                },
                                child: const Text('Excluir'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else if (state is ImcHistoryError) {
              return Text(state.message);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
