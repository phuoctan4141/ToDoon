// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/themes/todoon_icons.dart';
import 'package:todoon/src/controllers/settings/themes.dart';

// ignore: camel_case_types, constant_identifier_names
enum onFunc { Edit, Delete }

class MenuTask extends StatefulWidget {
  Widget? icon;
  bool complete;
  bool alert;
  VoidCallback onAlert;
  VoidCallback onEdit;
  VoidCallback onDelete;

  MenuTask({
    Key? key,
    this.icon,
    required this.complete,
    required this.alert,
    required this.onAlert,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<MenuTask> createState() => _MenuTaskState();
}

class _MenuTaskState extends State<MenuTask>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MenuTask oldWidget) {
    if (oldWidget.alert != widget.alert) {
      _animationController.reset();
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4.0,
      runSpacing: 2.0,
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildInkAlert(context),
        _buildPopupMenuButton(context),
      ],
    );
  }

  _buildInkAlert(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Material(
        type: MaterialType.button,
        elevation: 1.0,
        color: Themes.instance.AlertCompleteBolderColor(widget.alert),
        shadowColor: Themes.instance.AlertCompleteBolderColor(widget.alert),
        borderRadius: Themes.instance.switchRollBorder,
        child: InkWell(
          key: ValueKey(widget.alert),
          splashColor: Theme.of(context).indicatorColor,
          borderRadius: Themes.instance.switchRollBorder,
          onTap: widget.onAlert,
          child: ScaleTransition(
            scale: _animation,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                ToDoonIcons.getAlertState(widget.alert),
                semanticLabel: Language.instance.Reminder,
                color: Themes.instance.AlertCompleteColor(widget.alert),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton(
      icon: widget.icon ??
          Icon(Icons.more_vert,
              color: Themes.instance.TaskItemCompleteColor(widget.complete)),
      tooltip: Language.instance.Show_Menu,
      itemBuilder: (context) => <PopupMenuItem>[
        PopupMenuItem(
            value: onFunc.Edit,
            child: ListTile(
              leading: const Icon(ToDoonIcons.edit),
              title: Text(Language.instance.Edit),
            )),
        PopupMenuItem(
            value: onFunc.Delete,
            child: ListTile(
              leading: const Icon(ToDoonIcons.delete),
              title: Text(Language.instance.Detete),
            )),
      ],
      onSelected: (value) {
        if (value == onFunc.Edit) widget.onEdit.call();
        if (value == onFunc.Delete) widget.onDelete.call();
      },
    );
  }
}
