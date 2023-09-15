import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pma_dclv/theme/theme.dart';
import 'package:pma_dclv/views/dashboard/charts/bar_chart/bar_data.dart';

class WeekChart extends StatefulWidget {
  const WeekChart({super.key, required this.weekData});

  final List<double> weekData;

  @override
  State<WeekChart> createState() => _WeekChartState();
}

class _WeekChartState extends State<WeekChart> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(
      monday: widget.weekData[0],
      tuesday: widget.weekData[1],
      wednesday: widget.weekData[2],
      thursday: widget.weekData[3],
      friday: widget.weekData[4],
      saturday: widget.weekData[5],
      sunday: widget.weekData[6],
    );
    barData.initializeBarData();

    final double max = widget.weekData.max;

    return BarChart(
      BarChartData(
        maxY: max,
        minY: 0,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(drawVerticalLine: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getBottomTitles,
          )),
        ),
        barGroups: barData.barData.map((data) => BarChartGroupData(
          x: data.x,
          showingTooltipIndicators: showingTooltip == data.x ? [0] : [],
          barRods: [
            BarChartRodData(
              toY: data.y,
              width: 10.w,
              color: primary,
            ),
            BarChartRodData(
              toY: data.y,
              width: 10.w,
              color: ascent,
            ),
          ],
        )).toList(),

        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          touchCallback: (event, response) {
            if (response != null && response.spot != null && event is FlTapUpEvent) {
              setState(() {
                final x = response.spot!.touchedBarGroup.x;
                final isShowing = showingTooltip == x;
                if (isShowing) {
                  showingTooltip = -1;
                } else {
                  showingTooltip = x;
                }
              });
            }
          },
          mouseCursorResolver: (event, response) {
            return response == null || response.spot == null
                ? MouseCursor.defer
                : SystemMouseCursors.click;
          },

          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: neutral_lightgrey
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta title) {
  TextStyle style = TextStyle(
    color: neutral_dark,
    fontSize: 10.sp,
  );

  Widget text;

  switch (value.toInt()){
    case 0:
      text = Text("Mon", style: style,);
      break;

    case 1:
      text = Text("Tue", style: style,);
      break;

    case 2:
      text = Text("Wed", style: style,);
      break;

    case 3:
      text = Text("Thu", style: style,);
      break;

    case 4:
      text = Text("Fri", style: style,);
      break;

    case 5:
      text = Text("Sat", style: style,);
      break;

    case 6:
      text = Text("Sun", style: style,);
      break;

    default:
      text = Text("", style: style,);
      break;
  }
  
  return SideTitleWidget(child: text, axisSide: title.axisSide);
}