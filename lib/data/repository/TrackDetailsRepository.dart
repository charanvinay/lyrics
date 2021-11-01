import 'package:lyrics/data/models/TrackDetailsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TrackDetailsRepository {
  Future<Message> getTrackDetails(String trackId);
}

class TrackDetailsImpl implements TrackDetailsRepository {
  @override
  Future<Message> getTrackDetails(String trackId) async {
    var res = await http.get(Uri.parse(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=7ddda4dd78a773b2277d1f8ef80cd916"));
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      Message message = TrackDetailsModel.fromJson(data).message;
      return message;
    } else
      throw Exception();
  }
}
