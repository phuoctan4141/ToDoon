import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'task.dart';

part 'plan.g.dart';

class PlansList {
  List<Plan> plans;

  PlansList({
    required this.plans,
  });

  factory PlansList.fromJson(List<dynamic> parsedJson) {
    List<Plan> plans = <Plan>[];

    plans = parsedJson.map((entry) => Plan.fromJson(entry)).toList();

    return PlansList(plans: plans);
  }
}

@JsonSerializable(explicitToJson: true)
class Plan {
  final int id;
  String name;
  List<Task> tasks = [];

  Plan({required this.id, this.name = '', required this.tasks});

  @override
  String toString() => 'Plan(id: $id, name: $name, tasks: $tasks)';

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  Map<String, dynamic> toJson() => _$PlanToJson(this);

  Plan copyWith({
    int? id,
    String? name,
    List<Task>? tasks,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    if (other is! Plan) return false;
    final mapEquals = const DeepCollectionEquality().equals;
    return mapEquals(other.toJson(), toJson());
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ tasks.hashCode;
}
