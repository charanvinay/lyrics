import 'package:bloc/bloc.dart';
import 'package:lyrics/data/models/TracksListModel.dart';
import 'package:lyrics/bloc/TracksListBloc/TracksList_event.dart';
import 'package:lyrics/bloc/TracksListBloc/TracksList_state.dart';
import 'package:lyrics/data/repository/TracksListRepository.dart';

class TracksListBloc extends Bloc<TracksListEvent, TracksListState> {
  TracksListRepository repository;
  TracksListBloc({required this.repository}) : super(TracksListInitialState());
  @override
  Stream<TracksListState> mapEventToState(TracksListEvent event) async* {
    if (event is FetchTracksListEvent) {
      yield TracksListLoadingState();
      try {
        Message message = (await repository.getTracksList());
        yield TracksListLoadedState(message: message);
      } catch (e) {
        yield TracksListErrorState(err: e.toString());
      }
    }
  }
}
