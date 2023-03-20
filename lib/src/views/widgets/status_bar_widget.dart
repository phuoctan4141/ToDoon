// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';

class StatusBarWidget extends StatefulWidget {
  double width;
  double height;
  TasksList deadTasksList;
  TasksList notTasksList;
  TasksList comTasksList;
  Duration duration;
  Curve curve;
  int quantity;

  StatusBarWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.deadTasksList,
    required this.notTasksList,
    required this.comTasksList,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.bounceInOut,
    this.quantity = 1,
  }) : super(key: key);

  @override
  State<StatusBarWidget> createState() => _StatusBarWidgetState();
}

class _StatusBarWidgetState extends State<StatusBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;
  late Animation<double> _tweenAnimation;

  late AnimationController _animationNot;
  late CurvedAnimation _curvedNot;
  late Animation<double> _tweenNot;

  late AnimationController _animationDead;
  late CurvedAnimation _curvedDead;
  late Animation<double> _tweenDead;

  late int quantity = widget.quantity;
  late double deadLength = 0;
  late double notLength = 0;
  late double comLength = 0;

  @override
  void initState() {
    super.initState();
    // Com.
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: widget.curve);
    _tweenAnimation = Tween(begin: 8.0, end: 10.0).animate(_curvedAnimation);
    // Not.
    _animationNot = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _curvedNot = CurvedAnimation(parent: _animationNot, curve: widget.curve);
    _tweenNot = Tween(begin: 8.0, end: 10.0).animate(_curvedNot);
    //Dead
    _animationDead = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _curvedDead = CurvedAnimation(parent: _animationDead, curve: widget.curve);
    _tweenDead = Tween(begin: 8.0, end: 10.0).animate(_curvedDead);

    setState(() {
      quantity = (widget.deadTasksList.tasks.length +
          widget.notTasksList.tasks.length +
          widget.comTasksList.tasks.length);
      /////////////////
      deadLength =
          ((widget.deadTasksList.tasks.length / quantity) * widget.width);

      notLength =
          ((widget.notTasksList.tasks.length / quantity) * widget.width);

      comLength =
          ((widget.comTasksList.tasks.length / quantity) * widget.width);
    });

    _animationController.forward();
    _animationNot.forward();
    _animationDead.forward();
  }

  @override
  void didUpdateWidget(StatusBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.deadTasksList.tasks.isNotEmpty) {
      _animationDead.reset();
      _animationDead.forward();
    } else if (widget.deadTasksList.tasks.isEmpty) {
      _animationDead.reverse();
    }

    if (widget.comTasksList.tasks.isNotEmpty) {
      if (widget.notTasksList.tasks.isNotEmpty) {
        _animationController.reset();
      }
      _animationController.forward();
    } else if (widget.comTasksList.tasks.isEmpty) {
      _animationController.reverse();
    }

    setState(() {
      quantity = (widget.deadTasksList.tasks.length +
          widget.notTasksList.tasks.length +
          widget.comTasksList.tasks.length);
      /////////////////
      deadLength =
          ((widget.deadTasksList.tasks.length / quantity) * widget.width);
      notLength =
          ((widget.notTasksList.tasks.length / quantity) * widget.width);
      comLength =
          ((widget.comTasksList.tasks.length / quantity) * widget.width);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationNot.dispose();
    _animationDead.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Listenable> listenables = [_tweenAnimation, _tweenNot, _tweenDead];
    /////////////////
    return AnimatedBuilder(
        animation: Listenable.merge(listenables),
        builder: (BuildContext context, Widget? child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                borderRadius: Themes.instance.switchRollBorder,
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  //Dead.
                  Expanded(
                    flex: (_tweenDead.value * deadLength).toInt(),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: Themes.instance.switchRollBorder,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Not.
                  Expanded(
                    flex: (_tweenNot.value * notLength).toInt(),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: Themes.instance.switchRollBorder,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Com.
                  Expanded(
                    flex: (_tweenAnimation.value * comLength).toInt(),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: Themes.instance.switchRollBorder,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
