import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:to_do_app_turtle/utils/string_resources.dart';

import '../services/db_manager.dart';

class TasksDataViewModel extends ChangeNotifier {
  static TasksDataViewModel read(BuildContext context) =>
      context.read<TasksDataViewModel>();
  static TasksDataViewModel watch(BuildContext context) =>
      context.watch<TasksDataViewModel>();
  int _selectedImage = 0;
  set selectedImage(int imageNumber) {
    _selectedImage = imageNumber;
    notifyListeners();
  }

  int? _tabIndex = 0;
  set tabIndex(int? v) {
    _tabIndex = v;
    notifyListeners();
  }

  int? get tabIndex => _tabIndex;
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
  final TextEditingController completedTaskSearchController =
      TextEditingController();
  final TextEditingController allTaskSearchController = TextEditingController();
  final TextEditingController favoriteTaskSearchController =
      TextEditingController();

  List<Map<String, dynamic>> toDoList = [];
  List<Map<String, dynamic>> toDoCompletedList = [];
  List<Map<String, dynamic>> toDoFavoriteList = [];
  List<Map<String, dynamic>> tasksSearchElements = [];
  List<Map<String, dynamic>> completedSearchElements = [];
  List<Map<String, dynamic>> favoriteSearchElements = [];
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
    reset();
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
    BotToast.showText(text: StringResources.addedSuccessfulText);
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
    BotToast.showText(text: StringResources.updatedSuccessfulText);
    reset();
    getTabsData();
  }

  void deleteTask(int id) async {
    await DbManager.deleteTask(id);
    BotToast.showText(text: StringResources.deletedSuccessfulText);
    _isLatest = true;
    getTabsData();
  }

  findSearchItem(
      {String? query,
      required List<Map<String, dynamic>> initialItems,
      int tabIndex = 0}) {
    List<Map<String, dynamic>> initialFilterSearch = [];
    List<Map<String, dynamic>> searchItems = [];
    for (var element in initialItems) {
      initialFilterSearch.add(element);
    }
    List<Map<String, dynamic>> initialFilterSearchItems = [];
    for (var item in initialFilterSearch) {
      if (item['title'].toLowerCase().contains(query?.toLowerCase())) {
        initialFilterSearchItems.add(item);
      }
    }
    searchItems.clear();
    searchItems.addAll(initialFilterSearchItems);
    tabIndex == 0
        ? tasksSearchElements = searchItems
        : tabIndex == 1
            ? completedSearchElements = searchItems
            : favoriteSearchElements = searchItems;
    notifyListeners();
  }

  void reset() {
    _pickedDate = DateTime.now();
    titleController.clear();
    subTitleController.clear();
    messageController.clear();
    allTaskSearchController.clear();
    favoriteTaskSearchController.clear();
    completedTaskSearchController.clear();
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
