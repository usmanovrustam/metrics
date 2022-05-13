part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisEvent {}

class LoadEvent extends AnalysisEvent {
  final String? queryParams;
  LoadEvent({this.queryParams});
}
