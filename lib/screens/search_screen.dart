import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/music_service.dart';
import '../providers/favourites_provider.dart';
import '../models/track.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Track> _results = [];
  bool _isLoading = false;

  void _search(String query) async {
    setState(() => _isLoading = true);
    final results = await MusicService().searchTracks(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Escuchamos el proveedor para saber qué canciones son favoritas
    final favProvider = context.watch<FavouritesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('SENA Beats'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: 'Buscar artista o canción...',
                prefixIcon: const Icon(Icons.music_note),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final track = _results[index];
              final isFav = favProvider.favourites.any((t) => t.id == track.id);

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(track.image),
                ),
                title: Text(track.title, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(track.artist),
                trailing: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: () => favProvider.toggleFavourite(track),
                ),
              );
            },
          ),
    );
  }
}