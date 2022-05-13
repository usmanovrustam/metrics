part of 'analysis_bloc.dart';

@immutable
abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}

class LoadingState extends AnalysisState {}

class LoadedState extends AnalysisState {
  final Map<String, dynamic>? data;
  LoadedState({this.data});
}

class FailedState extends AnalysisState {
  final Exception? exception;
  FailedState({this.exception});

  bool get isRepositoryException => exception is RepositoryException;

  RepositoryException get repositoryException =>
      exception as RepositoryException;

  String get detailedError =>
      json.decode(repositoryException.raw!.body)["error"]["errors"][0]
          ["message"];

  bool get hasException => exception != null;
}
