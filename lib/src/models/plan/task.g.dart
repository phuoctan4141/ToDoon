// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as int,
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      reminder: json['reminder'] as String? ?? '',
      complete: json['complete'] as bool? ?? false,
      alert: json['alert'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'date': instance.date,
      'reminder': instance.reminder,
      'complete': instance.complete,
      'alert': instance.alert,
    };
