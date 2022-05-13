import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:metrics/repositories/analysis.dart';
import 'package:metrics/repositories/utils/exception.dart';
import 'package:http/http.dart' as http;
import 'package:metrics/settings.dart';
part 'analysis_event.dart';
part 'analysis_state.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final client = http.Client();
  AnalysisBloc() : super(AnalysisInitial()) {
    on<LoadEvent>((event, emit) async {
      emit(LoadingState());

      try {
        final data = await AnalysisRepository.loginEmail(client, data: {
          "strategy": "mobile",
          "url": event.queryParams,
          "key": key,
        });

        emit(LoadedState(data: data));
      } on Exception catch (e) {
        emit(FailedState(exception: e));
      }
    });
  }
}
