import 'package:json_annotation/json_annotation.dart';

part 'task_api_model.g.dart';

@JsonSerializable()
class TaskDto {
  final int? id;
  final String title;

  // JSONPlaceholder menggunakan 'completed', bukan 'isCompleted'
  // Kita gunakan @JsonKey untuk memetakannya
  @JsonKey(name: 'completed')
  final bool isCompleted;

  // JSONPlaceholder juga punya 'userId'
  // INI ADALAH BARIS YANG HILANG DARI KODE ANDA
  final int userId;

  TaskDto({
    this.id,
    required this.title,
    required this.isCompleted,
    required this.userId, // DAN INI
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) =>
      _$TaskDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDtoToJson(this);
}