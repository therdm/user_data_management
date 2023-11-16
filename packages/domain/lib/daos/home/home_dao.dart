import 'package:domain/dtos/responses/sample_response.dart';
import 'package:services/data_providers/data_providers.dart';

class HomeDao {
  HomeDao._();

  static final instance = HomeDao._();

  Future<ServiceResponse<UserDetails>> getSampleData() async {
    final response = await RestApi.instance.get('/users?_quantity=20');
    return response.richData(UserDetails.fromJson(response.body));
  }
}
