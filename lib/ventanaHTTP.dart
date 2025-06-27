import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:agronova/downloadRssFeed/downloadRss.dart';

class VentanaHTTP extends StatefulWidget {
  const VentanaHTTP({super.key});

  @override
  State<VentanaHTTP> createState() => _VentanaHTTPState();
}

class _VentanaHTTPState extends State<VentanaHTTP> {
  late Future<RssFeed> futureFeed;
  String fuente = 'BBC';

  @override
  void initState() {
    super.initState();
    futureFeed = getBBCNews();
  }

  void _cambiarFuente(String nuevaFuente) {
    setState(() {
      fuente = nuevaFuente;
      futureFeed = (fuente == 'BBC') ? getBBCNews() : getElPaisNews();
    });
  }

  String getImageFromItem(RssItem item) {
    String? url = item.enclosure?.url;

    if (url != null &&
        (url.startsWith('http://') || url.startsWith('https://'))) {
      return url;
    }

    final html = item.description ?? '';
    final regex = RegExp(r'<img.*?src="(.*?)"', caseSensitive: false);
    final match = regex.firstMatch(html);
    if (match != null && match.groupCount > 0) {
      String extractedUrl = match.group(1)!;
      if (extractedUrl.startsWith('http://') ||
          extractedUrl.startsWith('https://')) {
        return extractedUrl;
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        toolbarHeight: 60,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _cambiarFuente('BBC'),
              child: const Text("BBC", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () => _cambiarFuente('ElPais'),
              child: const Text(
                "El País",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<RssFeed>(
        future: futureFeed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar noticias"));
          } else if (!snapshot.hasData || snapshot.data!.items == null) {
            return const Center(child: Text("No hay noticias disponibles"));
          }

          final items = snapshot.data!.items!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final imageUrl = getImageFromItem(item);
              return Card(
                margin: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    imageUrl.isNotEmpty
                        ? Container(
                            width: 80, // Tamaño reducido
                            height: 80,
                            margin: const EdgeInsets.all(8),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 32,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            width: 80, // Tamaño reducido
                            height: 80,
                            margin: const EdgeInsets.all(8),
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 32,
                            ),
                          ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? 'Sin título',
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.pubDate?.toString() ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
