import 'package:lyrics/data/models/TracksListModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TracksListRepository {
  Future<Message> getTracksList();
}

class TracksListImpl implements TracksListRepository {
  @override
  Future<Message> getTracksList() async {
    var res = await http.get(Uri.parse(
        "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=7ddda4dd78a773b2277d1f8ef80cd916"));

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      Message message = TracksListModel.fromJson(data).message;
      return message;
    } else
      throw Exception();
  }
}
