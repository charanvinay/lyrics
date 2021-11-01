import 'package:flutter_offline/flutter_offline.dart';

import '../imports.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TracksListBloc tracksListBloc;
  @override
  void initState() {
    super.initState();
    tracksListBloc = BlocProvider.of<TracksListBloc>(context);
    tracksListBloc.add(FetchTracksListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      debounceDuration: Duration.zero,
      connectivityBuilder: (
        BuildContext context,
        ConnectivityResult connectivity,
        Widget child,
      ) {
        if (connectivity == ConnectivityResult.none) {
          return Scaffold(
            body: Center(
              child: Image.asset(
                "assets/net.png",
                width: MediaQuery.of(context).size.width * 0.6,
              ),
            ),
          );
        }
        return child;
      },
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Trending 🔥",
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Container(
          child: BlocListener<TracksListBloc, TracksListState>(
            listener: (context, state) {
              if (state is TracksListErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.err),
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            child: BlocBuilder<TracksListBloc, TracksListState>(
              builder: (context, state) {
                if (state is TracksListInitialState)
                  return loadingIndicator();
                else if (state is TracksListLoadingState)
                  return loadingIndicator();
                else if (state is TracksListLoadedState) {
                  return tracksList(state.message);
                } else if (state is TracksListErrorState)
                  return buildErrorUi(state.err);
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget tracksList(Message message) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: message.body.trackList.length,
      itemBuilder: (BuildContext context, int index) {
        var snapshot = message.body.trackList[index].track;
        return ListTile(
          title: Text(
            snapshot.trackName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            snapshot.artistName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TrackDetails(
                  trackId: snapshot.trackId.toString(),
                ),
              ),
            );
          },
          horizontalTitleGap: 0,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.library_music_rounded)],
          ),
        );
      },
    );
  }

  @override
  dispose() {
    super.dispose();
  }
}
