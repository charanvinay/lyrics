import 'package:lyrics/data/models/TrackLyricsModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TrackLyricsRepository {
  Future<Message> getTrackLyrics(trackId);
}

class TrackLyricsImpl implements TrackLyricsRepository {
  @override
  Future<Message> getTrackLyrics(trackId) async {
    var res = await http.get(Uri.parse(
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=$trackId&apikey=7ddda4dd78a773b2277d1f8ef80cd916"));
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      Message message = TrackLyricsModel.fromJson(data).message;
      return message;
    } else
      throw Exception();
  }
}
