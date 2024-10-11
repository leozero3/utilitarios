class WaterReminderModel {
  final int id;
  final double totalLiters; // Total de água desejada
  final double startHour; // Hora inicial (agora em double)
  final double endHour; // Hora final (agora em double)
  final double doseAmount; // Quantidade por dose
  final List<double> doseTimes;

  WaterReminderModel({
    required this.id,
    required this.totalLiters,
    required this.startHour,
    required this.endHour,
    required this.doseAmount,
    required this.doseTimes,
  });

  // Método para copiar o objeto com modificações parciais
  WaterReminderModel copyWith({
    int? id,
    double? totalLiters,
    double? startHour,
    double? endHour,
    double? doseAmount,
    List<double>? doseTimes,
  }) {
    return WaterReminderModel(
      id: id ?? this.id,
      totalLiters: totalLiters ?? this.totalLiters,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      doseAmount: doseAmount ?? this.doseAmount,
      doseTimes: doseTimes ?? this.doseTimes,
    );
  }

  // Conversão para o banco de dados (Map)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalLiters': totalLiters,
      'startHour': startHour,
      'endHour': endHour,
      'doseAmount': doseAmount,
      'doseTimes': doseTimes.join(','),
    };
  }

  factory WaterReminderModel.fromMap(Map<String, dynamic> map) {
    return WaterReminderModel(
      id: map['id'],
      totalLiters: map['totalLiters'],
      startHour: map['startHour'],
      endHour: map['endHour'],
      doseAmount: map['doseAmount'],
      doseTimes:
          map['doseTimes'].split(',').map((e) => double.parse(e)).toList(),
    );
  }
}
