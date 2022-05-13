import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show Card, CircularProgressIndicator, Colors;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metrics/bloc/analysis_bloc.dart';
import 'package:metrics/cells/sliding_segment.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  Map<DateTime, double> series = {};
  final controller = TextEditingController();
  final List<FlSpot> dummyData1 = List.generate(8, (index) {
    return FlSpot(index.toDouble(), index * Random().nextInt(100).toDouble());
  });

  final List<FlSpot> dummyData2 = List.generate(5, (index) {
    return FlSpot(index.toDouble(), index * Random().nextInt(100).toDouble());
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendData() {
    String? fixedQuery;
    if (controller.text.startsWith("http"))
      fixedQuery = controller.text.trim();
    else
      fixedQuery = "http://${controller.text}";

    context.read<AnalysisBloc>().add(LoadEvent(queryParams: fixedQuery));
  }

  Widget detailsTitle(
    String key,
    String value,
  ) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(key, style: TextStyle(color: CupertinoColors.activeBlue)),
          Expanded(child: Text(value)),
        ],
      );

  Widget get linechart => Column(
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                color: CupertinoColors.activeBlue,
              ),
              const SizedBox(width: 10),
              Text("Total clicks"),
              const SizedBox(width: 40),
              Container(
                width: 10,
                height: 10,
                color: CupertinoColors.systemIndigo,
              ),
              const SizedBox(width: 10),
              Text("Total views")
            ],
          ),
          const SizedBox(height: 40),
          Container(
            height: 400,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                ),
                maxY: 500,
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: dummyData1,
                    barWidth: 2,
                    color: CupertinoColors.systemIndigo,
                  ),
                  LineChartBarData(
                    spots: dummyData2,
                    barWidth: 2,
                    color: CupertinoColors.systemBlue,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  Widget lightHouseDetails(LoadedState state) => ListView(
        children: [
          detailsTitle(
            "Request Url: ",
            state.data!["lighthouseResult"]["requestedUrl"],
          ),
          const SizedBox(height: 10),
          detailsTitle(
            "LightHouse Version: ",
            state.data!["lighthouseResult"]["lighthouseVersion"],
          ),
          const SizedBox(height: 10),
          detailsTitle(
            "User Agent: ",
            state.data!["lighthouseResult"]["userAgent"],
          ),
          const SizedBox(height: 10),
          detailsTitle(
            "Fetch Time: ",
            state.data!["lighthouseResult"]["fetchTime"],
          ),
          const SizedBox(height: 10),
          detailsTitle(
            "Environment: ",
            state.data!["lighthouseResult"]["environment"]["networkUserAgent"],
          ),
          const SizedBox(height: 10),
          detailsTitle(
            "Emulated Form Factor: ",
            state.data!["lighthouseResult"]["configSettings"]
                ["emulatedFormFactor"],
          ),
          const SizedBox(height: 10),
          detailsTitle(
            "Locale: ",
            state.data!["lighthouseResult"]["configSettings"]["locale"],
          ),
          const SizedBox(height: 10),
          detailsTitle(
            "Analysis Time: ",
            state.data!["analysisUTCTimestamp"],
          ),
        ],
      );

  Widget card({Map<String, dynamic>? data, String? title}) {
    Color? color;

    switch (data!["category"]) {
      case "AVERAGE":
        color = CupertinoColors.systemOrange;
        break;
      case "SLOW":
        color = CupertinoColors.systemRed;
        break;
      case "FAST":
        color = CupertinoColors.systemGreen;
        break;
    }

    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 40,
            color: color,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Text(
                        data["category"],
                        style: TextStyle(fontSize: 10, color: color!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Loading page",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularPercentIndicator(
                        radius: 30.0,
                        lineWidth: 4.0,
                        percent: data["distributions"][0]["proportion"],
                        progressColor: CupertinoColors.activeGreen,
                      ),
                      CircularPercentIndicator(
                        radius: 30.0,
                        lineWidth: 4.0,
                        percent: data["distributions"][1]["proportion"],
                        progressColor: CupertinoColors.systemYellow,
                      ),
                      CircularPercentIndicator(
                        radius: 30.0,
                        lineWidth: 4.0,
                        percent: data["distributions"][2]["proportion"],
                        progressColor: CupertinoColors.systemRed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Good",
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.activeGreen,
                        ),
                      ),
                      Text(
                        "(≤ 2,5 sec.)",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${(data["distributions"][0]["proportion"] * 100).toStringAsFixed(2)}%",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Rework required",
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.activeOrange,
                        ),
                      ),
                      Text(
                        "(2.5 sec - 4 sec)",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${(data["distributions"][1]["proportion"] * 100).toStringAsFixed(2)}%",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Bad",
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemRed,
                        ),
                      ),
                      Text(
                        "(> 4 sec.)",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${(data["distributions"][2]["proportion"] * 100).toStringAsFixed(2)}%",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget metricsList(LoadedState state) => ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        children: [
          card(
            title: "Largest Contentful Paint (LCP)",
            data: state.data!["loadingExperience"]["metrics"]
                ["LARGEST_CONTENTFUL_PAINT_MS"],
          ),
          const SizedBox(height: 10),
          card(
            title: "First Input Delay (FID)",
            data: state.data!["loadingExperience"]["metrics"]
                ["FIRST_INPUT_DELAY_MS"],
          ),
          const SizedBox(height: 10),
          card(
            title: "Cumulative Layout Shift (CLS)",
            data: state.data!["loadingExperience"]["metrics"]
                ["CUMULATIVE_LAYOUT_SHIFT_SCORE"],
          ),
          const SizedBox(height: 10),
          card(
            title: "First Contentful Paint (FCP)",
            data: state.data!["loadingExperience"]["metrics"]
                ["FIRST_CONTENTFUL_PAINT_MS"],
          ),
          const SizedBox(height: 10),
          card(
            title: "Interaction to Next Paint (INP)",
            data: state.data!["loadingExperience"]["metrics"]
                ["EXPERIMENTAL_INTERACTION_TO_NEXT_PAINT"],
          ),
          const SizedBox(height: 10),
          card(
            title: "Time to First Byte (TTFB)",
            data: state.data!["loadingExperience"]["metrics"]
                ["EXPERIMENTAL_TIME_TO_FIRST_BYTE"],
          ),
        ],
      );

  Widget experienceList(LoadedState state) => ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(top: 10),
        children: [
          card(
            title: "Largest Contentful Paint (LCP)",
            data: state.data!["originLoadingExperience"]["metrics"]
                ["LARGEST_CONTENTFUL_PAINT_MS"],
          ),
          const SizedBox(height: 10),
          card(
            title: "First Input Delay (FID)",
            data: state.data!["originLoadingExperience"]["metrics"]
                ["FIRST_INPUT_DELAY_MS"],
          ),
          const SizedBox(height: 10),
          card(
            title: "Cumulative Layout Shift (CLS)",
            data: state.data!["originLoadingExperience"]["metrics"]
                ["CUMULATIVE_LAYOUT_SHIFT_SCORE"],
          ),
          const SizedBox(height: 10),
          card(
            title: "First Contentful Paint (FCP)",
            data: state.data!["originLoadingExperience"]["metrics"]
                ["FIRST_CONTENTFUL_PAINT_MS"],
          ),
          const SizedBox(height: 10),
          card(
            title: "Interaction to Next Paint (INP)",
            data: state.data!["originLoadingExperience"]["metrics"]
                ["EXPERIMENTAL_INTERACTION_TO_NEXT_PAINT"],
          ),
          const SizedBox(height: 10),
          card(
            title: "Time to First Byte (TTFB)",
            data: state.data!["originLoadingExperience"]["metrics"]
                ["EXPERIMENTAL_TIME_TO_FIRST_BYTE"],
          ),
        ],
      );

  Widget get view => BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          Widget child = Expanded(
            child: Center(
              child: Text(
                "Learn how to make your pages load faster on any device.",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          );
          if (state is LoadedState) {
            child = Expanded(
              child: SlidingSegment(
                tabs: ["Origin", "Loading", "Efficiency", "Details"],
                views: [
                  metricsList(state),
                  experienceList(state),
                  linechart,
                  lightHouseDetails(state),
                ],
              ),
            );
          }
          if (state is LoadingState) {
            child = Expanded(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is FailedState) {
            child = Text(
              state.detailedError.toString(),
              style: TextStyle(color: CupertinoColors.systemRed),
            );
          }
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        controller: controller,
                        padding: EdgeInsets.all(16),
                        placeholder: "Enter the URL of the page",
                        placeholderStyle: TextStyle(color: Colors.grey),
                        style: TextStyle(color: Colors.black),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CupertinoButton.filled(
                      child:
                          Text("Enter", style: TextStyle(color: Colors.white)),
                      onPressed: sendData,
                    )
                  ],
                ),
                child
              ],
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(child: view),
    );
  }
}
