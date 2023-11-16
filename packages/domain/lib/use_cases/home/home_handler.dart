import 'package:domain/daos/home/home_dao.dart';
import 'package:domain/dtos/responses/sample_response.dart';
import 'package:services/network_state_manager/network_state/service_state_manager.dart';

class HomeHandler with ServiceStateMixin {
  HomeHandler();

  final userData = Reactive<List<Data>>([]);

  Future<ServiceStatus> fetchSampleData(int apiRequestNumber) async {
    return serviceObserver(() async {
      final response = await HomeDao.instance.getSampleData();
      if (response.status.isSuccess) {
        if (apiRequestNumber == 1) {
          userData.value = response.body?.data ?? [];
        } else {
          userData.value.addAll(response.body?.data ?? []);
        }
      }
      return response.status;
    });
  }
}
