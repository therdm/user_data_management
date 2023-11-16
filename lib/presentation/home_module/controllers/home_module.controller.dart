import 'package:domain/use_cases/home/home_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:reactiv/reactiv.dart';

class HomeModuleController extends ReactiveController {
  final sampleHandler = HomeHandler();

  final ScrollController userDataController = ScrollController();
  int apiRequestNumber = 1;
  ReactiveBool isShowLoader = ReactiveBool(true);

  @override
  void onInit() {
    userDataController.addListener(() {
      if(userDataController.position.pixels == userDataController.position.maxScrollExtent){
        if(apiRequestNumber < 5){
          isShowLoader.value = true;
          apiRequestNumber += 1;
          sampleHandler.fetchSampleData(apiRequestNumber);
        }else{
          isShowLoader.value = false;
        }
      }
    });
    super.onInit();

  }
}
