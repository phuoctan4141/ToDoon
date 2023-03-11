import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

class TasksList {
  final List<Task> tasks;

  TasksList({
    required this.tasks,
  });

  factory TasksList.fromJson(List<dynamic> parsedJson) {
    List<Task> tasks = <Task>[];

    tasks = parsedJson.map((entry) => Task.fromJson(entry)).toList();

    return TasksList(tasks: tasks);
  }

  int get completeCountTask => tasks.where((task) => task.complete).length;
}

@JsonSerializable(explicitToJson: true)
class Task {
  final int id;
  String description;
  String date;
  String reminder;
  bool complete;
  bool alert;

  Task({
    required this.id,
    this.description = '',
    this.date = '',
    this.reminder = '',
    this.complete = false,
    this.alert = false,
  });

  @override
  String toString() {
    return 'Task(id: $id, description: $description, date: $date, reminder: $reminder, complete: $complete, alert: $alert)';
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    int? id,
    String? description,
    String? date,
    String? reminder,
    bool? complete,
    bool? alert,
  }) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      date: date ?? this.date,
      reminder: reminder ?? this.reminder,
      complete: complete ?? this.complete,
      alert: alert ?? this.alert,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Task) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode =>
      id.hashCode ^
      description.hashCode ^
      date.hashCode ^
      reminder.hashCode ^
      complete.hashCode ^
      alert.hashCode;
}
