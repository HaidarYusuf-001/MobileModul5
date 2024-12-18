import 'app/modules/todo/bindings/connection_binding.dart';

class DependencyInjection {
  static void init() {
    ConnectionBinding().dependencies();
  }
}
