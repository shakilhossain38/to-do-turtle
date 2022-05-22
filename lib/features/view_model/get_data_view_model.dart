import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

import '../services/db_manager.dart';

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

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController isFavoriteController = TextEditingController();
  final TextEditingController isCompletedController = TextEditingController();
  final TextEditingController allTaskSearchController = TextEditingController();

  List<Map<String, dynamic>> toDoList = [];
  List<Map<String, dynamic>> toDoCompletedList = [];
  List<Map<String, dynamic>> toDoFavoriteList = [];
  List<Map<String, dynamic>> tasksSearchElements = [];
  DateTime _pickedDate = DateTime.now();
  bool _isLatest = true;
  int _showMoreIndex = -1;
  set pickedDate(DateTime date) {
    _pickedDate = date;
    notifyListeners();
  }

  set isLatest(bool value) {
    _isLatest = value;
    notifyListeners();
  }

  bool get isLatest => _isLatest;
  set showMoreIndex(int value) {
    _showMoreIndex = value;
    notifyListeners();
  }

  int get showMoreIndex => _showMoreIndex;

  DateTime get pickedDate => _pickedDate;

  void getTasksList({String? sortBy}) async {
    var getData = await DbManager.getTasks(sortBy: sortBy ?? "desc");
    toDoList = getData;
    isLoading = false;
    notifyListeners();
  }

  void getCompletedList({String? sortBy}) async {
    final getData =
        await DbManager.completedItem(isCompleted: 1, sortBy: sortBy ?? "desc");
    toDoCompletedList = getData;
    isLoading = false;
    notifyListeners();
  }

  void getFavoriteList({String? sortBy}) async {
    final getData =
        await DbManager.favoriteItem(isFavorite: 1, sortBy: sortBy ?? "desc");
    toDoFavoriteList = getData;
    isLoading = false;
    notifyListeners();
  }

  getTabsData({String sortBy = "desc"}) {
    getTasksList(sortBy: sortBy);
    getCompletedList(sortBy: sortBy);
    getFavoriteList(sortBy: sortBy);
  }

  updateForm(int? id) {
    final selectedId = toDoList.firstWhere((element) => element['id'] == id);
    titleController.text = selectedId['title'];
    subTitleController.text = selectedId['subTitle'];
    messageController.text = selectedId['message'];
    dateController.text = selectedId['date'];
    pickedDate = DateTime.parse(selectedId['date']);
    notifyListeners();
  }

  Future<void> addNewTasks() async {
    await DbManager.createNewTask(
        title: titleController.text,
        date: pickedDate.toString(),
        isCompleted: 0,
        isFavorite: 0,
        message: messageController.text,
        subTitle: subTitleController.text);
    _isLatest = true;
    BotToast.showText(text: "Task added successfully!");
    reset();
    getTabsData();
  }

  Future<void> updateTask(
      {int? id,
      int? isFavorite = 0,
      int? isCompleted = 0,
      String? date,
      String? message,
      String? subTitle,
      String? title}) async {
    await DbManager.updateTask(
        id: id,
        title: title ?? titleController.text,
        date: date ?? pickedDate.toString(),
        isCompleted: isCompleted,
        isFavorite: isFavorite,
        message: message ?? messageController.text,
        subTitle: subTitle ?? subTitleController.text);
    _isLatest = true;
    BotToast.showText(text: "Task updated successfully!");
    reset();
    getTabsData();
  }

  void deleteTask(int id) async {
    await DbManager.deleteTask(id);
    BotToast.showText(text: "Successfully deleted the task!");
    _isLatest = true;
    getTabsData();
  }

  List<Map<String, dynamic>> findSearchItem(
      {String? query, required List<Map<String, dynamic>> initialItems}) {
    List<Map<String, dynamic>> initialFilterSearch = [];
    for (var element in initialItems) {
      initialFilterSearch.add(element);
    }
    List<Map<String, dynamic>> initialFilterSearchItems = [];
    for (var item in initialFilterSearch) {
      if (item['title'].toLowerCase().contains(query?.toLowerCase())) {
        initialFilterSearchItems.add(item);
      }
    }
    tasksSearchElements.clear();
    tasksSearchElements.addAll(initialFilterSearchItems);
    notifyListeners();
    return tasksSearchElements;
  }

  void reset() {
    _pickedDate = DateTime.now();
    titleController.clear();
    subTitleController.clear();
    messageController.clear();
    allTaskSearchController.clear();
    isCompletedController.clear();
    isFavoriteController.clear();
    dateController.clear();
    notifyListeners();
  }

  resetSelectedImage() {
    _selectedImage = 0;
    notifyListeners();
  }
}
