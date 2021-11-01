import 'package:bloc/bloc.dart';
import 'package:lyrics/data/models/TrackDetailsModel.dart';
import 'package:lyrics/bloc/TrackDetailsBloc/TrackDetails_state.dart';
import 'package:lyrics/data/repository/TrackDetailsRepository.dart';

import 'TrackDetails_event.dart';

class TrackDetailsBloc extends Bloc<TrackDetailsEvent, TrackDetailsState> {
  TrackDetailsRepository repository;
  String trackId;
  TrackDetailsBloc({required this.repository, required this.trackId})
      : super(TrackDetailsInitialState());

  @override
  Stream<TrackDetailsState> mapEventToState(TrackDetailsEvent event) async* {
    if (event is FetchTrackDetailsEvent) {
      yield TrackDetailsLoadingState();
      try {
        Message message = (await repository.getTrackDetails(trackId));
        yield TrackDetailsLoadedState(message: message);
      } catch (e) {
        yield TrackDetailsErrorState(err: e.toString());
      }
    }
  }
}
