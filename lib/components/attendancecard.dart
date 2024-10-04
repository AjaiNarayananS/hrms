import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class AttendanceCard extends StatelessWidget {
  final double attendancePercentage;
  final double percentageChange;
  final int reportedCount;
  final int onLeaveCount;
  final int notReportedCount;

  const AttendanceCard({
    super.key,
    required this.attendancePercentage,
    required this.percentageChange,
    required this.reportedCount,
    required this.onLeaveCount,
    required this.notReportedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Attendance Percentage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.arrow_upward, color: Colors.green),
                      Text(
                        '${percentageChange.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: SfRadialGauge(
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 100,
                      showLabels: false,
                      showTicks: false,
                      startAngle: 270,
                      endAngle: 270,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.2,
                        color: Colors.grey.shade300,
                        thicknessUnit: GaugeSizeUnit.factor,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                          value: attendancePercentage,
                          width: 0.2,
                          sizeUnit: GaugeSizeUnit.factor,
                          enableAnimation: true,
                          animationDuration: 500,
                          animationType: AnimationType.ease,
                          gradient: const SweepGradient(
                            colors: <Color>[
                              Color(0xFF4e1bd9),
                              Color(0xFFafffb6)
                            ],
                            stops: <double>[0.25, 0.75]
                          )
                        ),
                        MarkerPointer(
                          enableAnimation: true,
                          animationDuration: 500,
                          animationType: AnimationType.ease,
                          markerWidth: 28,
                          markerHeight: 28,
                          value: attendancePercentage,
                          markerType: MarkerType.circle,
                          color: const Color(0xFF87e8e8),
                        )
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                          positionFactor: 0.1,
                          angle: 90,
                          widget: Text(
                            '${attendancePercentage.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold
                            ),
                          )
                        )
                      ]
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildAttendanceStatus('Reported', reportedCount, Colors.green),
              const SizedBox(height: 8),
              _buildAttendanceStatus('On Leave', onLeaveCount, Colors.orange),
              const SizedBox(height: 8),
              _buildAttendanceStatus('Not Reported', notReportedCount, Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceStatus(String label, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}