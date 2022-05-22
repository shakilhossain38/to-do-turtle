import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../utils/colors.dart';
import '../../../utils/string_resources.dart';
import '../../view_model/tasks_data_view_model.dart';
import 'add_edit_prompt.dart';
import 'package:bot_toast/bot_toast.dart';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';

class TasksListTileWidget extends StatelessWidget {
  var data;
  bool isLastIndex;
  int? index;
  TasksListTileWidget({this.data, this.isLastIndex = false, this.index});
  bool hasTextOverflow(String? text,
      {double minWidth = 0, double maxWidth = 0, int maxLines = 3}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text),
      maxLines: maxLines,
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    bool isOverFlow = hasTextOverflow(data['message'].toString(),
        maxWidth: MediaQuery.of(context).size.width * .55);
    var vm = TasksDataViewModel.watch(context);
    Color color = index! % 2 == 0 ? Colors.teal : Colors.amber;
    var spaceBetween = const SizedBox(
      width: 5,
    );
    var dateSection = Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
        //height: 50,
        width: 40,
        constraints: const BoxConstraints(minHeight: 110, minWidth: 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  DateFormat("dd").format(DateTime.parse(data['date'])),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  DateFormat("MMM").format(DateTime.parse(data['date'])),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  DateFormat("yy").format(DateTime.parse(data['date'])),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ));
    var message = AutoSizeText(
      data["message"] ?? "",
      maxLines: 3,
      style: const TextStyle(fontSize: 14),
      minFontSize: 15,
      overflowReplacement: Column(
        // This widget will be replaced.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data["message"] ?? "",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              GestureDetector(
                onTap: () {
                  vm.showMoreIndex = index!;
                },
                child: Text(
                  "Show more",
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
    var subTitle = Container(
        constraints: const BoxConstraints(minWidth: 10),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(data["subTitle"] ?? ""),
        ));
    var title = Text(
      data["title"],
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
    var favoriteComplete = Row(
      children: [
        GestureDetector(
          onTap: () {
            vm.updateTask(
                id: data["id"],
                isFavorite: data["isFavorite"] == 1 ? 0 : 1,
                isCompleted: data["isCompleted"],
                subTitle: data["subTitle"],
                message: data["message"],
                date: data["date"],
                title: data["title"]);
            BotToast.showText(
                text: data["isFavorite"] == 0
                    ? StringResources.markedAsFavoriteText
                    : StringResources.removedFavoriteText);
            vm.getTabsData();
          },
          child: Icon(
            data["isFavorite"] == 1 ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: color,
          ),
        ),
        spaceBetween,
        GestureDetector(
          onTap: () {
            vm.updateTask(
                id: data["id"],
                isFavorite: data["isFavorite"],
                isCompleted: data["isCompleted"] == 1 ? 0 : 1,
                subTitle: data["subTitle"],
                message: data["message"],
                date: data["date"],
                title: data["title"]);
            BotToast.showText(
                text: data["isCompleted"] == 0
                    ? StringResources.markedAsCompleteText
                    : StringResources.removedCompleteText);
            vm.getTabsData();
          },
          child: Icon(
            data["isCompleted"] == 1 ? Icons.star : Icons.star_border_outlined,
            color: color,
          ),
        ),
      ],
    );
    var taskSection = Expanded(
      child: Row(
        children: [
          const SizedBox(
            width: 15,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [title, favoriteComplete],
                ),
                spaceBetween,
                subTitle,
                spaceBetween,
                message,
              ],
            ),
          ),
        ],
      ),
    );
    var deleteIcon = Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {
            vm.deleteTask(data['id']!);
            vm.getTabsData();
          },
        ),
      ),
    );
    var editIcon = Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () => showPrompt(
            data['id']!, data['isFavorite']!, data['isCompleted']!, context),
      ),
    );
    var iconSection = Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(width: .5)),
        ),
        //height: 50,
        constraints: const BoxConstraints(minHeight: 110, minWidth: 40),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                editIcon,
                const SizedBox(
                  width: 3,
                ),
                deleteIcon,
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          ),
        ));
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: vm.showMoreIndex == index
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(data['message']),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          GestureDetector(
                              onTap: () {
                                vm.showMoreIndex = -1;
                              },
                              child: Text(
                                StringResources.showLessText,
                                style: TextStyle(color: AppTheme.primaryColor),
                              )),
                        ],
                      )
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    dateSection,
                    taskSection,
                    iconSection,
                  ],
                ),
        ),
        SizedBox(
          height: isLastIndex ? 50 : 0,
        )
      ],
    );
  }

  void showPrompt(
      int? id, int? isFavorite, int? isCompleted, BuildContext context) {
    var vm = TasksDataViewModel.read(context);
    vm.updateForm(id);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddEditTask(
            id: id,
            isCompleted: isCompleted,
            isFavorite: isFavorite,
          );
        });
  }
}
