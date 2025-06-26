import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';

// --------- Category -----------

class Category {
  final String name;
  final double amount;
  bool isSelect;

  Category(this.name, this.isSelect, {required this.amount});
}

// ----------- PIE CHART WIDGET --------------

class PieChartPainter extends CustomPainter {
  final List<Category> categories;
  final List<Color> colors;
  final double strokeWidth;

  PieChartPainter({required this.categories, required this.colors, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final double total = categories.fold<double>(0.0, (sum, c) => sum + c.amount);
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = min(size.width / 2, size.height / 2);

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    double startAngle = -pi / 2;

    for (int i = 0; i < categories.length; i++) {
      final sweepAngle = (categories[i].amount / total) * 2 * pi;
      paint.color = colors[i % colors.length];
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PieChartView extends StatefulWidget {
  final List<Category> categories;
  final Function onTap;
  final double radius;
  int? total;
  final List<Color> colors;

  PieChartView(
      {Key? key,
      required this.categories,
      required this.onTap,
      required this.colors,
      this.total,
      this.radius = 200})
      : super(key: key);

  State<PieChartView> createState() => PieChartViewState();
}

class PieChartViewState extends State<PieChartView> {
  late final ScrollController _logs;

  @override
  void initState() {
    super.initState();
    _logs = ScrollController();
  }

  @override
  void dispose() {
    _logs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.total ?? widget.categories.fold<double>(0.0, (sum, c) => sum + c.amount);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        color: second_lightBg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: widget.radius,
                height: widget.radius,
                child: GestureDetector(
                  onTap: widget.onTap as void Function(),
                  child: CustomPaint(
                    painter: PieChartPainter(
                        categories: widget.categories,
                        strokeWidth: widget.radius * 0.15,
                        colors: widget.colors),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    total.toStringAsFixed(0),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Total", style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          Container(
            height: widget.radius / 1.8,
            child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(lightBg),
                    mainAxisMargin: 2,
                    crossAxisMargin: 2,
                    trackColor: MaterialStateProperty.all(darkBg),
                    thickness: MaterialStateProperty.all(5),
                  ),
                ),
                child: Scrollbar(
                  controller: _logs,
                  interactive: true,
                  thumbVisibility: true,
                  trackVisibility: true,
                  child: SingleChildScrollView(
                    controller: _logs,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.categories.length, (index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: widget.colors[index % widget.colors.length],
                              ),
                              SizedBox(width: 5),
                              Text(
                                widget.categories[index].name,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

// Sample data
/*
  final List<Category> sampleCategories = [
  Category('Groceries', false, amount: 500.00),
  Category('Shopping', false, amount: 150.00),
  Category('Food', false, amount: 90.00),
  Category('Bills', false, amount: 90.00),
  Category('Subscriptions', false, amount: 40.00),
  Category('Fees', false, amount: 20.00),
  Category('Other', false, amount: 20.00),
];

final kNeumorphicColors = [
  Color(0xFF5262FF),
  Color(0xFF2EC6FF),
  Color(0xFF8B230A),
  Color(0xFF7BC952),
  Color(0xFFFFAB43),
  Color(0xFFFC5B39),
  Color(0xFF8B8782),
  Color(0xFF40502D),
  Color(0xB3000000),
];*/
