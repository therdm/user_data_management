import 'package:flutter/material.dart';
import 'package:graphics/graphics_consts/graphics_string_consts.dart';
import 'package:graphics/widgets/cards/user_details_row.dart';
import 'package:reactiv/reactiv.dart';
import 'package:user_data_assignment/infrastructure/navigation/navigation.dart';
import 'package:user_data_assignment/presentation/home_module/controllers/home_module.controller.dart';
import 'package:services/network_state_manager/network_state/service_state_manager.dart';
import 'package:services/network_widgets/network_state_view.dart';
import 'package:services/network_widgets/show_snackbar.dart';

class HomeModuleScreen extends ReactiveStateWidget<HomeModuleController> {
  const HomeModuleScreen({super.key});

  @override
  BindController<HomeModuleController>? bindController() {
    return BindController(controller: () => HomeModuleController(), autoDispose: true);
  }

  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
    controller.sampleHandler.fetchSampleData(1).then((value) {
      if (value.isError) {
        showSnackBar(context: context, title: value.message, isError: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(GraphicsStringConsts.sampleData),
      ),
      body: Observer2(
          listenable: controller.sampleHandler.serviceState,
          listenable2: controller.isShowLoader,
          listener: (ServiceState state, trailingLoader) {
            return NetworkStateView.sizeFree(
              networkState: controller.apiRequestNumber == 1 ? state : ServiceState.success,
              child: (controller.sampleHandler.userData.value.isNotEmpty)
                  ? RefreshIndicator(
                      onRefresh: () async {
                        controller.sampleHandler.fetchSampleData(1);
                        controller.apiRequestNumber = 1;
                      },
                      child: ListView.builder(
                        controller: controller.userDataController,
                        itemCount: controller.sampleHandler.userData.value.length + 1,
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        itemBuilder: (context, index) {
                          if (index < controller.sampleHandler.userData.value.length) {
                            final data = controller.sampleHandler.userData.value[index];
                            return UserDetailsRow(
                              onSelect: () {
                                Routes.of(context).toLocationUserDetails(
                                    data.id.toString(),
                                    data.uuid ?? '',
                                    data.firstname ?? '',
                                    data.lastname ?? '',
                                    data.username ?? '',
                                    data.password ?? '',
                                    data.email ?? '',
                                    data.ip ?? '',
                                    data.macAddress ?? '',
                                    data.website ?? '',
                                    data.image ?? '');
                              },
                              imageUrl: data.image ?? '',
                              userName: '${data.firstname} ${data.lastname}',
                              userEmail: data.email ?? '',
                            );
                          } else {
                            return Center(
                              child: trailingLoader
                                  ? const CircularProgressIndicator()
                                  : const Text(GraphicsStringConsts.noDataDescription),
                            );
                          }
                        },
                      ),
                    )
                  : const Text(GraphicsStringConsts.noDataFound),
            );
          }),
    );
  }
}
