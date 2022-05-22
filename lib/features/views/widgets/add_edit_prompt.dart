import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/colors.dart';
import '../../../utils/common_text_field.dart';
import '../../../utils/string_resources.dart';
import '../../view_model/get_data_view_model.dart';

class AddEditTask extends StatelessWidget {
  int? id;
  int? isFavorite;
  int? isCompleted;
  AddEditTask({this.id, this.isFavorite, this.isCompleted});

  Future<void> selectDate(BuildContext context) async {
    var vm = GetDataViewModel.read(context);
    final DateTime? date = await showDatePicker(
      //initialDatePickerMode: DatePickerMode.year,
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.primaryColor,
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor)
                .copyWith(secondary: AppTheme.primaryColor),
            //buttonTheme: ButtonThemeData(textTheme: Colors.black),
          ),
          child: child!,
        );
      },
      initialDate: vm.pickedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (date != null && date != vm.pickedDate) {
      vm.pickedDate = date;
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var vm = GetDataViewModel.watch(context);
    vm.dateController.text = DateFormat("dd/MM/yyyy").format(vm.pickedDate);
    var spaceBetween = const SizedBox(
      height: 10,
    );
    var title = CommonTextField(
      controller: vm.titleController,
      validator: (v) {
        v!.isEmpty ? StringResources.thisFieldIsRequired : null;
      },
      hintText: StringResources.titleText,
      labelText: StringResources.titleText,
    );
    var addNew = Row(
      children: [
        Text(
          StringResources.addNewText,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
    var closeButton = Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.close,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
    var subTitle = CommonTextField(
      controller: vm.subTitleController,
      hintText: StringResources.subTitleText,
      labelText: StringResources.subTitleText,
    );
    var note = CommonTextField(
      controller: vm.messageController,
      hintText: StringResources.noteText,
      labelText: StringResources.noteText,
      maxLines: 4,
      validator: (v) {
        v!.isEmpty ? StringResources.thisFieldIsRequired : null;
      },
    );
    var date = CommonTextField(
      hintText: StringResources.dateText,
      labelText: StringResources.dateText,
      controller: vm.dateController,
      readOnly: true,
      onTap: () {
        selectDate(context);
      },
    );
    var addButton = ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          var vm = GetDataViewModel.read(context);
          if (id == null) {
            await vm.addNewTasks();
          }
          if (id != null) {
            await vm.updateTask(
                id: id!, isCompleted: isCompleted, isFavorite: isFavorite);
          }
          Navigator.of(context).pop();
        }
      },
      child: Text(
          id == null ? StringResources.createText : StringResources.updateText),
    );
    return AlertDialog(
      titlePadding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      contentPadding: const EdgeInsets.only(top: 12, left: 0, bottom: 10),
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            addNew,
            closeButton,
          ],
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: ListBody(
              children: <Widget>[
                title,
                spaceBetween,
                subTitle,
                spaceBetween,
                note,
                spaceBetween,
                date,
                spaceBetween,
                spaceBetween,
                addButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
