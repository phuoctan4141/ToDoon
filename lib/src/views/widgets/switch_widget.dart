// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable, unnecessary_overrides, unused_element
import 'package:flutter/material.dart';

import 'package:todoon/src/controllers/settings/themes.dart';

class SwitchWidget extends StatefulWidget {
  Icon? icon;
  Text? title;
  bool value;
  String activeText;
  String inactiveText;
  IconData? activeIcon;
  IconData? inativeIcon;
  double? width;
  double? height;
  double? switchRollSize;
  Duration duration;
  Function(bool) onChanged;

  SwitchWidget({
    Key? key,
    this.icon,
    this.title,
    required this.value,
    this.activeText = 'On',
    this.inactiveText = 'Off',
    this.activeIcon,
    this.inativeIcon,
    this.width = 70.0,
    this.height = 70.0,
    this.switchRollSize = 25.0,
    this.duration = const Duration(milliseconds: 200),
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<AlignmentGeometry> _alignAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
        value: widget.value ? 1.0 : 0.0,
        duration: widget.duration);

    _alignAnimation = Tween<AlignmentGeometry>(
            begin: Alignment.centerLeft, end: Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SwitchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value == widget.value) return;

    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return InkWell(
              onTap: () => _setSwitchState(context),
              onDoubleTap: () => _setSwitchState(context),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// Switch Title.
                      _switchTitle(context),

                      /// Switch Button.
                      _switchButton(context),
                    ],
                  ),
                ),
              ));
        });
  }

  /// Switch title.
  Widget _switchTitle(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.icon ?? Container(),
        widget.title ?? Container(),
      ],
    );
  }

  /// Switch button.
  Widget _switchButton(BuildContext context) {
    return Container(
      // Distance between [_switchButton] and [_switchTitle].
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: Themes.instance.switchRollBorder,
        border:
            Border.all(width: 1.0, color: Themes.instance.switchRollItemColor),
        color: Themes.instance.switchSectionColor(widget.value),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.blueGrey.shade200,
            offset: const Offset(1, 2),
            blurRadius: 3.0,
          ),
        ],
      ),

      /// Switch button.
      child: Padding(
        // Position between text and toggle.
        padding:
            const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 4.0, left: 4.0),
        // Switch button.
        child: Stack(
          children: [
            // Active switch.
            _activeSwitch(context),
            // Switch Roll.
            _switchRoll(context),
            // Inactive switch.
            _inactiveSwitch(context),
          ],
        ),
      ),
    );
  }

  /// Active switch.
  Widget _activeSwitch(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.value ? 1.0 : 0.0,
      duration: widget.duration,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        alignment: Alignment.centerLeft,
        child: Text(
          widget.activeText,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Themes.instance.switchActiveItemColor),
        ),
      ),
    );
  }

  /// Switch Roll.
  Widget _switchRoll(BuildContext context) {
    return AlignTransition(
      alignment: _alignAnimation,
      child: Container(
        width: widget.switchRollSize,
        height: widget.switchRollSize,
        decoration: BoxDecoration(
          borderRadius: Themes.instance.switchRollBorder,
          color: Themes.instance.switchRollItemColor,
        ),
        // Switch Roll Icon.
        child: widget.value
            ? Icon(widget.activeIcon ?? Icons.done_sharp)
            : Icon(widget.inativeIcon ?? Icons.clear_sharp),
      ),
    );
  }

  /// Inactive switch.
  Widget _inactiveSwitch(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.value ? 0.0 : 1.0,
      duration: widget.duration,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        alignment: Alignment.centerRight,
        child: Text(
          widget.inactiveText,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Themes.instance.RadioSelectedColor),
        ),
      ),
    );
  }

  /// Set switch state.
  void _setSwitchState(BuildContext context) {
    // set value.
    setState(() {
      widget.value == false ? widget.onChanged(true) : widget.onChanged(false);
    });
  }
}
