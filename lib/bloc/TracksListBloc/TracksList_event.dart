import 'package:equatable/equatable.dart';

abstract class TracksListEvent extends Equatable {}

class FetchTracksListEvent extends TracksListEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
