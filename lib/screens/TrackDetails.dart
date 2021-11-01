import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../imports.dart';

class TrackDetails extends StatefulWidget {
  const TrackDetails({Key? key, required this.trackId}) : super(key: key);
  final String trackId;

  @override
  _TrackDetailsState createState() => _TrackDetailsState();
}

class _TrackDetailsState extends State<TrackDetails> {
  late Map resData;

  String apiKey = "7ddda4dd78a773b2277d1f8ef80cd916";
  String trackDet = "";
  String trackLyr = "";

  Future<Map> _getTrackDet() async {
    try {
      var res1 = await http.get(Uri.parse(trackDet));
      var res2 = await http.get(Uri.parse(trackLyr));
      // print("Hey");
      // print(res.body.toString());
      var temp = json.decode(res1.body);
      resData = temp["message"]["body"]["track"];
      temp = json.decode(res2.body);
      resData["lyrics"] = temp["message"]["body"]["lyrics"]["lyrics_body"];
    } catch (e) {
      print("error : $e");
    }
    return resData;
  }

  @override
  void initState() {
    setState(() {
      trackDet =
          "https://api.musixmatch.com/ws/1.1/track.get?track_id=${widget.trackId}&apikey=$apiKey";
      trackLyr =
          "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${widget.trackId}&apikey=$apiKey";
    });
    super.initState();
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
          title: Text(
            "Track Details",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: new FutureBuilder(
          future: _getTrackDet(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null)
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(color: Colors.grey),
              );
            else {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          snapshot.data["track_name"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(height: 10.0),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "By " + snapshot.data["artist_name"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                      Container(height: 5.0),
                      Align(
                        alignment: Alignment.center,
                        child: RatingBarIndicator(
                          rating: double.parse(
                                  snapshot.data["track_rating"].toString()) /
                              20,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          itemSize: 14,
                        ),
                      ),
                      Container(height: 40.0),
                      titleWidget("Album Name"),
                      Container(height: 2.0),
                      detailWidget(text: snapshot.data["album_name"]),
                      Container(height: 20.0),
                      titleWidget("Explicit"),
                      detailWidget(
                          text: toBoolean(snapshot.data["explicit"])
                              ? "True"
                              : "False"),
                      Container(height: 20.0),
                      titleWidget("Favourites"),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(width: 4),
                          detailWidget(
                              text: snapshot.data["num_favourite"].toString()),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            line(),
                            Text(
                              "Lyrics",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 12.0,
                              ),
                            ),
                            line(),
                          ],
                        ),
                      ),
                      Container(height: 5.0),
                      detailWidget(
                          text: snapshot.data["lyrics"] == null
                              ? "Can't fetch lyrics"
                              : snapshot.data["lyrics"],
                          height: 1.6),
                      Container(height: 20.0),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Container line() {
    return Container(
      width: 70,
      color: Colors.grey,
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
    );
  }

  Text detailWidget({required String text, double height = 1.2}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        height: height,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Text titleWidget(String text) {
    return Text(text, style: TextStyle(fontSize: 12.0));
  }

  bool toBoolean(int a) {
    return a == 1 ? true : false;
  }
}

Widget loadingIndicator() {
  return Container(
    alignment: Alignment.center,
    child: CircularProgressIndicator(color: Colors.grey[400]),
  );
}

Widget buildErrorUi(String err) {
  return Center(
    child: Text(err),
  );
}
