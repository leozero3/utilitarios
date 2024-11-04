part of 'water_reminder_cubit.dart';

enum WaterReminderStatus { initial, loading, loaded, error }

class WaterReminderState extends Equatable {
  final WaterReminderStatus status;
  final WaterReminderModel? reminder;
  final String? errorMessage;
  final int? totalDoses;
  final int? intervalInMinutes;

  const WaterReminderState({
    required this.status,
    this.reminder,
    this.errorMessage,
    this.totalDoses,
    this.intervalInMinutes,
  });

  factory WaterReminderState.initial() {
    return WaterReminderState(status: WaterReminderStatus.initial);
  }

  factory WaterReminderState.loading() {
    return WaterReminderState(status: WaterReminderStatus.loading);
  }

  factory WaterReminderState.loaded(WaterReminderModel reminder) {
    return WaterReminderState(
        status: WaterReminderStatus.loaded, reminder: reminder);
  }

  factory WaterReminderState.error(String errorMessage) {
    return WaterReminderState(
        status: WaterReminderStatus.error, errorMessage: errorMessage);
  }

  WaterReminderState copyWith({
    WaterReminderStatus? status,
    WaterReminderModel? reminder,
    String? errorMessage,
    int? totalDoses,
    int? intervalInMinutes,
  }) {
    return WaterReminderState(
      status: status ?? this.status,
      reminder: reminder ?? this.reminder,
      errorMessage: errorMessage ?? this.errorMessage,
      totalDoses: reminder!.doseTimes.length.toInt(),
      intervalInMinutes: intervalInMinutes ?? this.intervalInMinutes,
    );
  }

  @override
  List<Object?> get props =>
      [status, reminder, errorMessage, totalDoses, intervalInMinutes];
}
