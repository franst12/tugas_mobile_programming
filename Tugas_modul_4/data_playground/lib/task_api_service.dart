import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'task_api_model.dart';

part 'task_api_service.g.dart';

// MODIFIKASI: Ubah baseUrl ke JSONPlaceholder
@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com/')
abstract class TaskApiService {
  // Modul ini membuat factory, kita ikuti saja
  factory TaskApiService(Dio dio, {String baseUrl}) = _TaskApiService;

  // MODIFIKASI: Ubah endpoint dari /tasks ke /todos
  @POST('/todos')
  Future<TaskDto> createTask(@Body() TaskDto task);

  @GET('/todos')
  Future<List<TaskDto>> getTasks(); // [cite: 478]

  @GET('/todos/{id}')
  Future<TaskDto> getTaskById(@Path('id') int id); // [cite: 480]

  @PUT('/todos/{id}')
  Future<TaskDto> updateTask(@Path('id') int id, @Body() TaskDto task); // [cite: 482]

  @DELETE('/todos/{id}')
  Future<void> deleteTask(@Path('id') int id); // [cite: 483]
}