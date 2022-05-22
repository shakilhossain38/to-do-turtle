import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bot_toast/bot_toast.dart';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';

import '../../../utils/colors.dart';
import '../../view_model/get_data_view_model.dart';

class TasksListTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var vm = GetDataViewModel.watch(context);

    var spaceBetween = SizedBox(
      width: 5,
    );
    var dateSection = Container(
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))),
        //height: 50,
        width: 40,
        constraints: BoxConstraints(minHeight: 110, minWidth: 40),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "22/05/22",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "22/05/22",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              Center(
                child: Text(
                  "22/05/22",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ));
    var message = AutoSizeText(
      "ASDsadsadsadasfdsadas",
      maxLines: 3,
      style: TextStyle(fontSize: 14),
      minFontSize: 15,
      overflowReplacement: Column(
        // This widget will be replaced.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "message",
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              GestureDetector(
                onTap: () {
                  // vm.showMoreIndex = index!;
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
        constraints: BoxConstraints(minWidth: 10),
        decoration: BoxDecoration(
            border: Border.all(), borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text("subtitle"),
        ));
    var title = Text(
      "title",
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
    var favoriteComplete = Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.favorite_border,
            size: 20,
            color: Colors.red,
          ),
        ),
        spaceBetween,
        GestureDetector(
          onTap: () {},
          child: Icon(
            Icons.star_border_outlined,
            color: Colors.red,
          ),
        ),
      ],
    );
    var taskSection = Expanded(
      child: Row(
        children: [
          SizedBox(
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
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
    );
    var editIcon = Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
    var iconSection = Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(width: .5)),
        ),
        //height: 50,
        constraints: BoxConstraints(minHeight: 110, minWidth: 40),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                editIcon,
                SizedBox(
                  width: 3,
                ),
                deleteIcon,
                SizedBox(
                  width: 3,
                ),
              ],
            ),
          ),
        ));
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Row(
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
          height: 0,
        )
      ],
    );
  }
}
