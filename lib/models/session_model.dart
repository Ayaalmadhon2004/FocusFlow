class SessionModel {
  final String id;
  final String taskName;
  final int durationMinutes;
  final DateTime completedAt;
  final bool wasCompleted;

  SessionModel({
    required this.id,
    required this.taskName,
    required this.durationMinutes,
    required this.completedAt,
    this.wasCompleted = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'taskName': taskName,
    'durationMinutes': durationMinutes,
    'completedAt': completedAt.toIso8601String(),
    'wasCompleted': wasCompleted,
  };

  factory SessionModel.fromJson(Map<String, dynamic> json) => SessionModel(
    id: json['id'],
    taskName: json['taskName'],
    durationMinutes: json['durationMinutes'],
    completedAt: DateTime.parse(json['completedAt']),
    wasCompleted: json['wasCompleted'],
  );
}