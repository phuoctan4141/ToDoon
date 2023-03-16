// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/views/data/tasks/components/task_item.dart';

class AddTask extends StatelessWidget {
  final TextEditingController textEditingDecription;
  final TextEditingController textEditingDate;
  final TextEditingController textEditingReminder;

  final VoidCallback onAdd;
  final VoidCallback onCancel;

  // ignore: prefer_const_constructors_in_immutables
  AddTask({
    Key? key,
    required this.textEditingDecription,
    required this.textEditingDate,
    required this.textEditingReminder,
    required this.onAdd,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Language.instance.Add_Task),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _TaskDecription(context),
            _TaskDate(context),
            // _TaskReminder(context),
          ],
        ),
      ),
      actionsPadding:
          const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 20.0),
      actionsOverflowAlignment: OverflowBarAlignment.end,
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel),
            label: Text(Language.instance.Cancel),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 120,
          ),
          child: ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_task),
            label: Text(Language.instance.Add_Task),
            style: Themes.instance.AddButtonStyle,
          ),
        ),
      ],
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  Widget _TaskDecription(BuildContext context) {
    return TaskItem(
      title: Language.instance.Description,
      maxLength: 128,
      maxLines: 1,
      minLines: 1,
      controller: textEditingDecription,
      hintText: Language.instance.New_Task,
    );
  }

  Widget _TaskDate(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: TaskItem(
        title: Language.instance.Date,
        minLines: 1,
        maxLines: 1,
        readOnly: true,
        controller: textEditingDate,
        keyboardType: TextInputType.datetime,
        child: IconButton(
          onPressed: () => changeDate(context),
          icon: const Icon(Icons.event_available_outlined),
        ),
      ),
      onTap: () => changeDate(context),
    );
  }

  Widget _TaskReminder(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: TaskItem(
        title: Language.instance.Reminder,
        minLines: 1,
        maxLines: 1,
        readOnly: true,
        controller: textEditingReminder,
        child: IconButton(
          onPressed: () => changeReminder(context),
          icon: const Icon(Icons.alarm),
        ),
      ),
      onTap: () => changeReminder(context),
    );
  }

  /////////////////////////////
  // View handle  /////////////
  // View handle //////////////
  /////////////////////////////

  void changeDate(BuildContext context) {
    final currentTime = DateTime.now();
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: currentTime,
      maxTime: DateTime(2050, 12, 31),
      theme: Themes.instance.DatetimePickerTheme,
      locale: Language.instance.getLocaleType,
      onConfirm: (datetime) {
        initializeDateFormatting(Language.instance.current.code, null);
        textEditingDate.text = DateFormat.yMd(Language.instance.current.code)
            .add_jms()
            .format(datetime);
      },
    );
  }

  void changeReminder(BuildContext context) {
    final currentTime = DateTime.now();
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: currentTime,
      maxTime: DateTime(2050, 12, 31),
      locale: Language.instance.getLocaleType,
      theme: Themes.instance.DatetimePickerTheme,
      onConfirm: (datetime) {
        if (datetime.isAfter(currentTime)) {
          initializeDateFormatting(Language.instance.current.code, null);
          textEditingReminder.text =
              DateFormat.yMd(Language.instance.current.code)
                  .add_jms()
                  .format(datetime);
        }
      },
    );
  }
}
