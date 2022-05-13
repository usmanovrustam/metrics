import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show DefaultMaterialLocalizations;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metrics/bloc/analysis_bloc.dart';
import 'package:metrics/screens/home.dart';

class MetricsApp extends StatefulWidget {
  const MetricsApp({Key? key}) : super(key: key);

  @override
  State<MetricsApp> createState() => _MetricsAppState();
}

class _MetricsAppState extends State<MetricsApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AnalysisBloc())],
      child: CupertinoApp(
        color: CupertinoColors.white,
        localizationsDelegates: [
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: HomeController(),
      ),
    );
  }
}
