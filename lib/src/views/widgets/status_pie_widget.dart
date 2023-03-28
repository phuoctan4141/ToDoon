// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class StatusPieWidget extends StatefulWidget {
  double deadLenght;
  double notLenght;
  double comLenght;

  String centerText;

  StatusPieWidget({
    Key? key,
    required this.deadLenght,
    required this.notLenght,
    required this.comLenght,
    required this.centerText,
  }) : super(key: key);

  @override
  State<StatusPieWidget> createState() => _StatusPieWidgetState();
}

class _StatusPieWidgetState extends State<StatusPieWidget> {
  final colorList = <Color>[
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
  ];

  double get deadLenght => widget.deadLenght;
  double get notLenght => widget.notLenght;
  double get comLenght => widget.comLenght;

  late Map<String, double> dataMap = {
    "Com": 0,
    "Dead": 0,
    "Not": 0,
  };

  late double total = 0;

  late bool isChange = false;

  void intData() {
    setState(() {
      dataMap['Dead'] = deadLenght;
      dataMap['Not'] = notLenght;
      dataMap['Com'] = comLenght;
      total = deadLenght + notLenght + comLenght;
    });
  }

  @override
  void initState() {
    super.initState();
    intData();
  }

  @override
  void didUpdateWidget(covariant StatusPieWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deadLenght != deadLenght ||
        oldWidget.notLenght != notLenght ||
        oldWidget.comLenght != comLenght) {
      isChange = true;
    } else {
      isChange = false;
    }
    intData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: PieChart(
          isChange: isChange,
          animationDuration: const Duration(milliseconds: 1500),
          dataMap: dataMap,
          chartType: ChartType.ring,
          ringStrokeWidth: 8,
          colorList: colorList,
          centerText: widget.centerText,
          centerTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary),
          legendOptions: const LegendOptions(
            showLegends: false,
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: false,
            decimalPlaces: 1,
          ),
          totalValue: total),
    );
  }
}
