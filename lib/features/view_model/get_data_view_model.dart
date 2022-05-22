import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

class GetDataViewModel extends ChangeNotifier {
  static GetDataViewModel read(BuildContext context) =>
      context.read<GetDataViewModel>();
  static GetDataViewModel watch(BuildContext context) =>
      context.watch<GetDataViewModel>();
  int _selectedImage = 0;
  set selectedImage(int imageNumber) {
    _selectedImage = imageNumber;
    notifyListeners();
  }

  bool _isLoading = false;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  int get selectedImage => _selectedImage;
  resetSelectedImage() {
    _selectedImage = 0;
    notifyListeners();
  }
}
