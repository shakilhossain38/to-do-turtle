import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:after_layout/after_layout.dart';
import 'package:to_do_app_turtle/features/views/widgets/add_edit_prompt.dart';
import 'package:to_do_app_turtle/features/views/widgets/tasks_list_tile_widget.dart';
import 'package:to_do_app_turtle/utils/common_text_field.dart';

import '../../utils/colors.dart';
import '../../utils/string_resources.dart';
import '../view_model/tasks_data_view_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    TasksDataViewModel.read(context).getTabsData();
  }

  @override
  Widget build(BuildContext context) {
    var vm = TasksDataViewModel.watch(context);
    Widget tabWidget({
      String? tabName,
    }) {
      return Tab(
          child: FittedBox(
        child: SizedBox(
          height: 40,
          child: Center(
              child: Text(
            "$tabName",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          )),
        ),
      ));
    }

    var allTasks = Column(
      mainAxisAlignment: vm.toDoList.isEmpty ||
              (vm.allTaskSearchController.text.isNotEmpty &&
                  vm.tasksSearchElements.isEmpty)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        vm.toDoList.isEmpty ||
                (vm.allTaskSearchController.text.isNotEmpty &&
                    vm.tasksSearchElements.isEmpty)
            ? Center(
                child: Text(
                  StringResources.noTaskText,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : const SizedBox(),
        vm.toDoList.isEmpty ||
                (vm.allTaskSearchController.text.isNotEmpty &&
                    vm.tasksSearchElements.isEmpty)
            ? const Center(
                child: SizedBox(),
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: vm.allTaskSearchController.text.isNotEmpty
                        ? vm.tasksSearchElements.length
                        : vm.toDoList.length,
                    itemBuilder: (context, index) => TasksListTileWidget(
                      data: vm.allTaskSearchController.text.isNotEmpty
                          ? vm.tasksSearchElements[index]
                          : vm.toDoList[index],
                      isLastIndex: vm.allTaskSearchController.text.isNotEmpty
                          ? index == vm.tasksSearchElements.length - 1
                              ? true
                              : false
                          : index == vm.toDoList.length - 1
                              ? true
                              : false,
                      index: index,
                    ),
                  ),
                ),
              ),
      ],
    );
    var favoriteTasks = Column(
      mainAxisAlignment: vm.toDoFavoriteList.isEmpty ||
              (vm.favoriteTaskSearchController.text.isNotEmpty &&
                  vm.favoriteSearchElements.isEmpty)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        vm.toDoFavoriteList.isEmpty ||
                (vm.favoriteTaskSearchController.text.isNotEmpty &&
                    vm.favoriteSearchElements.isEmpty)
            ? Center(
                child: Text(
                  StringResources.noTaskText,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : const SizedBox(),
        vm.toDoFavoriteList.isEmpty ||
                (vm.favoriteTaskSearchController.text.isNotEmpty &&
                    vm.favoriteSearchElements.isEmpty)
            ? const Center(
                child: SizedBox(),
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: vm.favoriteTaskSearchController.text.isNotEmpty
                        ? vm.favoriteSearchElements.length
                        : vm.toDoFavoriteList.length,
                    itemBuilder: (context, index) => TasksListTileWidget(
                      data: vm.favoriteTaskSearchController.text.isNotEmpty
                          ? vm.favoriteSearchElements[index]
                          : vm.toDoFavoriteList[index],
                      isLastIndex:
                          vm.favoriteTaskSearchController.text.isNotEmpty
                              ? index == vm.favoriteSearchElements.length - 1
                                  ? true
                                  : false
                              : index == vm.toDoFavoriteList.length - 1
                                  ? true
                                  : false,
                      index: index,
                    ),
                  ),
                ),
              ),
      ],
    );
    var completedTasks = Column(
      mainAxisAlignment: vm.toDoCompletedList.isEmpty ||
              (vm.completedTaskSearchController.text.isNotEmpty &&
                  vm.completedSearchElements.isEmpty)
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        vm.toDoCompletedList.isEmpty ||
                (vm.completedTaskSearchController.text.isNotEmpty &&
                    vm.completedSearchElements.isEmpty)
            ? Center(
                child: Text(
                  StringResources.noTaskText,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : const SizedBox(),
        vm.toDoCompletedList.isEmpty ||
                (vm.completedTaskSearchController.text.isNotEmpty &&
                    vm.completedSearchElements.isEmpty)
            ? const Center(
                child: SizedBox(),
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListView.builder(
                    itemCount: vm.completedTaskSearchController.text.isNotEmpty
                        ? vm.completedSearchElements.length
                        : vm.toDoCompletedList.length,
                    itemBuilder: (context, index) => TasksListTileWidget(
                      data: vm.completedTaskSearchController.text.isNotEmpty
                          ? vm.completedSearchElements[index]
                          : vm.toDoCompletedList[index],
                      isLastIndex:
                          vm.completedTaskSearchController.text.isNotEmpty
                              ? index == vm.completedSearchElements.length - 1
                                  ? true
                                  : false
                              : index == vm.toDoCompletedList.length - 1
                                  ? true
                                  : false,
                      index: index,
                    ),
                  ),
                ),
              ),
      ],
    );
    var spaceBetWeen = const SizedBox(
      height: 10,
    );
    var appBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${DateFormat("EEEE").format(DateTime.now())},",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  DateFormat("dd MMM yyyy").format(DateTime.now()),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              StringResources.toDoListText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
        Container(
          width: 90,
          height: 20,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  vm.isLatest = true;
                  vm.getTabsData(sortBy: "desc");
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 45,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(3),
                        bottomLeft: Radius.circular(3)),
                    color: vm.isLatest
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                  ),
                  child: Center(
                      child: Text(
                    "Latest",
                    style: TextStyle(
                        fontSize: 12,
                        color: vm.isLatest ? Colors.white : Colors.black,
                        fontWeight:
                            vm.isLatest ? FontWeight.w600 : FontWeight.normal),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  vm.isLatest = false;
                  vm.getTabsData(sortBy: "asc");
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 45,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(3),
                        bottomRight: Radius.circular(3)),
                    color: !vm.isLatest
                        ? AppTheme.primaryColor
                        : Colors.grey.shade300,
                  ),
                  child: Center(
                      child: Text(
                    "Oldest",
                    style: TextStyle(
                        fontSize: 12,
                        color: !vm.isLatest ? Colors.white : Colors.black,
                        fontWeight:
                            !vm.isLatest ? FontWeight.w600 : FontWeight.normal),
                  )),
                ),
              )
            ],
          ),
        ),
      ],
    );
    var searchField = CommonTextField(
      hintText: "Search by title",
      controller: vm.tabIndex == 0
          ? vm.allTaskSearchController
          : vm.tabIndex == 1
              ? vm.completedTaskSearchController
              : vm.favoriteTaskSearchController,
      onChanged: (v) {
        vm.findSearchItem(
            query: v,
            initialItems: vm.tabIndex == 0
                ? vm.toDoList
                : vm.tabIndex == 1
                    ? vm.toDoCompletedList
                    : vm.toDoFavoriteList,
            tabIndex: vm.tabIndex!);
      },
    );
    var floatingActionButton = InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddEditTask();
            });
      },
      child: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringResources.addText,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16),
            ),
            const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    spaceBetWeen,
                    appBar,
                    spaceBetWeen,
                    searchField,
                    DefaultTabController(
                      length: 3,
                      child: Expanded(
                        child: Column(
                          children: [
                            Container(
                              constraints:
                                  const BoxConstraints(maxHeight: 150.0),
                              child: TabBar(
                                //indicatorColor: Color(0xff8592E5),
                                onTap: (v) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  vm.tabIndex = v;
                                },
                                indicatorWeight: 4,
                                labelStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                unselectedLabelStyle:
                                    const TextStyle(fontSize: 12),
                                tabs: [
                                  tabWidget(tabName: StringResources.allText),
                                  tabWidget(
                                    tabName: StringResources.completedText,
                                  ),
                                  tabWidget(
                                    tabName: StringResources.favoriteText,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  allTasks,
                                  completedTasks,
                                  favoriteTasks,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: floatingActionButton,
    );
  }
}
