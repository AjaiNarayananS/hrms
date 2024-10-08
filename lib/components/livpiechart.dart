import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LeavesPieChart extends StatefulWidget {
  final Map<String, int> data;

  const LeavesPieChart({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _LeavesPieChartState createState() => _LeavesPieChartState();
}

class _LeavesPieChartState extends State<LeavesPieChart> with SingleTickerProviderStateMixin {
  int touchedIndex = -1;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final chartHeight = availableHeight * 0.8; // 80% for chart
        final tooltipHeight = availableHeight * 0.2; // 20% for tooltip

        return Column(
          children: [
            SizedBox(
              height: chartHeight,
              child: PieChart(
                PieChartData(
                  sections: _getChartSections(),
                  sectionsSpace: 0,
                  centerSpaceRadius: chartHeight * 0.2,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      if (!mounted) return;
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          _animationController.reverse();
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        _animationController.forward();
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: tooltipHeight,
              child: _buildTooltip(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTooltip() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal:4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _tooltipItem(Colors.green, 'A: ${widget.data['Allotted']}'),
          _tooltipItem(Colors.red, 'U: ${widget.data['Used']}'),
          _tooltipItem(Colors.blue, 'B: ${widget.data['Balance']}'),
        ],
      ),
    );
  }

  Widget _tooltipItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 2),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  List<PieChartSectionData> _getChartSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 12.0;
      final radius = 50.0 + (isTouched ? _animation.value * 10.0 : 0);

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: widget.data['Allotted']!.toDouble(),
            title: 'Allotted',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.bold),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: widget.data['Used']!.toDouble(),
            title: 'Used',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.bold),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blue,
            value: widget.data['Balance']!.toDouble(),
            title: 'Balance',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.bold),
          );
        default:
          throw Error();
      }
    });
  }
}
