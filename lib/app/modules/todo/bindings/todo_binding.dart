
import 'package:belajardek/app/modules/todo/controller/todo_controller.dart';
import 'package:get/get.dart';


class TodoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodoController>(
          () => TodoController(),
    );
  }
}