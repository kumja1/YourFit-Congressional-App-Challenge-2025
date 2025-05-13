import 'package:get/get.dart';

class AsyncButtonController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> handleOnPressed(
    Future<void> Function()? onPressed,
    bool loadingAnimation,
  ) async {
    {
      if (onPressed == null) return;

      if (loadingAnimation) {
        isLoading.value = true;
        await onPressed().whenComplete(() => isLoading.value = false);
        return;
      }
      await onPressed();
    }
  }
}
