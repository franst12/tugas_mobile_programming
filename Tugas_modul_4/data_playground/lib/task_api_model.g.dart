// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDto _$TaskDtoFromJson(Map<String, dynamic> json) => TaskDto(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      isCompleted: json['completed'] as bool,
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$TaskDtoToJson(TaskDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'completed': instance.isCompleted,
      'userId': instance.userId,
    };
