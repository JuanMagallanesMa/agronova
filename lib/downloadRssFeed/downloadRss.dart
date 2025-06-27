import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

Future<RssFeed> getBBCNews() async {
  final response = await http.get(
    Uri.parse("https://feeds.bbci.co.uk/mundo/rss.xml"),
  );
  return RssFeed.parse(response.body);
}

Future<RssFeed> getElPaisNews() async {
  final response = await http.get(
    Uri.parse(
      "https://feeds.elpais.com/mrss-s/pages/ep/site/elpais.com/section/internacional/portada",
    ),
  );
  return RssFeed.parse(response.body);
}
