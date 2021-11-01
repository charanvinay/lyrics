import 'package:equatable/equatable.dart';
import 'package:lyrics/data/models/TracksListModel.dart';

abstract class TracksListState extends Equatable {}

class TracksListInitialState extends TracksListState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class TracksListLoadingState extends TracksListState {
  @override
  List<Object> get props => throw UnimplementedError();
}

class TracksListLoadedState extends TracksListState {
  final Message message;
  TracksListLoadedState({required this.message});
  @override
  List<Object> get props => throw UnimplementedError();
}

class TracksListErrorState extends TracksListState {
  final String err;
  TracksListErrorState({required this.err});

  @override
  List<Object> get props => throw UnimplementedError();
}
