// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  // Configuration.
  String? title;
  int? minLines;
  int? maxLines;
  int? maxLength;
  bool? readOnly;
  TextEditingController? controller;
  String? label;
  String? hintText;
  Widget? child;

  TaskItem({
    Key? key,
    this.title,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.readOnly,
    this.controller,
    this.label,
    this.hintText,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '',
            semanticsLabel: title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Container(
            // Position content of TextFormField.
            padding: const EdgeInsets.only(left: 8.0),
            // Position TextFormField compared to [title].
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: maxLength,
                    minLines: minLines,
                    maxLines: maxLines,
                    controller: controller,
                    autocorrect: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: false,
                    readOnly: readOnly ?? false,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    decoration: InputDecoration(
                      label: Text(label ?? ''),
                      hintText: hintText,
                      isCollapsed: child == null ? false : true,
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    // Position child compared to TextFormField.
                    padding: const EdgeInsets.only(right: 5.0),
                    child: child ?? Container(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
