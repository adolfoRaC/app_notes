import 'package:get/get.dart';

class DataController extends GetxController {
  var data = {}.obs;

  void setData(String key, dynamic value) {
    data[key] = value;
  }

  dynamic getData(String key) {
    return data[key];
  }
}
