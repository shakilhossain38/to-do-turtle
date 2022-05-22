import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:after_layout/after_layout.dart';
import 'package:to_do_app_turtle/features/views/widgets/tasks_list_tile_widget.dart';

import '../../utils/string_resources.dart';
import '../view_model/get_data_view_model.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin {
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    var vm = GetDataViewModel.watch(context);
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          )),
        ),
      ));
    }

    var allTasks = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => TasksListTileWidget(),
            ),
          ),
        ),
      ],
    );
    var favoriteTasks = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => TasksListTileWidget(),
            ),
          ),
        ),
      ],
    );
    var completedTasks = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => TasksListTileWidget(),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${DateFormat("EEEE").format(DateTime.now())},",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  DateFormat("dd MMM yyyy")
                                      .format(DateTime.now()),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              StringResources.toDoListText,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        Container(
                          width: 90,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3)),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {},
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: 45,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(3),
                                        bottomLeft: Radius.circular(3)),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Latest",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  )),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {},
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 500),
                                  width: 45,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(3),
                                        bottomRight: Radius.circular(3)),
                                    color: Colors.grey.shade300,
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Oldest",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    DefaultTabController(
                      length: 3,
                      child: Expanded(
                        child: Column(
                          children: [
                            Container(
                              constraints: BoxConstraints(maxHeight: 150.0),
                              child: TabBar(
                                //indicatorColor: Color(0xff8592E5),
                                indicatorWeight: 4,
                                labelStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                unselectedLabelStyle: TextStyle(fontSize: 12),
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
      floatingActionButton: InkWell(
        onTap: () {
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       return AddEditTask();
          //     });
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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
              Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
