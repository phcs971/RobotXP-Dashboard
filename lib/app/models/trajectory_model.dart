import 'package:intl/intl.dart';

class TrajectoryList {
  final List<TrajectoryModel> trajectories;
  final int totalCount;

  TrajectoryList.fromJson(Map<String, dynamic> json)
      : trajectories = (json['trajectories'] as List? ?? [])
            .map((j) => TrajectoryModel.fromJson(j))
            .toList(),
        totalCount = json['totalCount'];
}

class TrajectoryModel {
  final int id;
  String? name;
  final DateTime startedAt, endedAt;

  Duration get duration => endedAt.difference(startedAt);

  String get title =>
      name ??
      'Trajetoria: ${DateFormat("dd/MM/yyyy' às 'HH:mm:ss").format(startedAt)} até ${DateFormat("dd/MM/yyyy' às 'HH:mm:ss").format(endedAt)}';

  TrajectoryModel({
    required this.id,
    this.name,
    required this.startedAt,
    required this.endedAt,
  });

  TrajectoryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        startedAt = DateTime.parse(json['startedAt']),
        endedAt = DateTime.parse(json['endedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt.toIso8601String(),
      };
}
