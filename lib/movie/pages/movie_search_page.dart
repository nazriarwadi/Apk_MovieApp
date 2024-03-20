import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_movie_db/movie/providers/movie_serach_provider.dart';
import 'package:app_movie_db/widget/image_widget.dart';

import 'movie_detail_page.dart';

class MovieSearchPage extends SearchDelegate {
  final TextEditingController _searchTextController = TextEditingController();

  @override
  String? get searchFieldLabel => "Search Movies";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          _searchTextController.clear();
          query = "";
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (query.isNotEmpty) {
        _saveSearchHistory(query);
        context.read<MovieSearchProvider>().search(context, query: query);
      }
    });

    return Consumer<MovieSearchProvider>(
      builder: (_, provider, __) {
        if (query.isEmpty) {
          return _buildSearchHistory(context);
        }

        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.movies.isEmpty) {
          return const Center(child: Text("Movies Not Found"));
        }

        if (provider.movies.isNotEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, index) {
              final movie = provider.movies[index];
              return Stack(
                children: [
                  Row(
                    children: [
                      ImageNetworkWidget(
                        imageSrc: movie.posterPath,
                        height: 120,
                        width: 80,
                        radius: 10,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movie.overview,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          close(context, null);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (_) {
                              return MovieDetailPage(id: movie.id);
                            },
                          ));
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: provider.movies.length,
          );
        }

        return const Center(child: Text("Another Error on search movies"));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchHistory(context);
  }

  Widget _buildSearchHistory(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getSearchHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final searchHistory = snapshot.data ?? [];

        if (searchHistory.isEmpty) {
          return const Center(child: Text("No Search History"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemBuilder: (_, index) {
            final query = searchHistory[index];
            return ListTile(
              title: Text(query),
              onTap: () {
                _searchTextController.text = query;
                close(context, query);
              },
              trailing: IconButton(
                icon:const Icon(Icons.delete),
                color: Colors.red,
                onPressed: () {
                  _deleteSearchHistory(query).then((_) {
                    showSuggestions(context);
                  });
                },
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: searchHistory.length,
        );
      },
    );
  }

  Future<List<String>> _getSearchHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final searchHistory = prefs.getStringList('searchHistory') ?? [];
    return searchHistory;
  }

  Future<void> _saveSearchHistory(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchHistory = prefs.getStringList('searchHistory') ?? [];
    searchHistory.insert(0, query);
    searchHistory = searchHistory.toSet().toList(); // Remove duplicates
    prefs.setStringList('searchHistory', searchHistory);
  }

  Future<void> _deleteSearchHistory(String query) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchHistory = prefs.getStringList('searchHistory') ?? [];
    searchHistory.remove(query);
    prefs.setStringList('searchHistory', searchHistory);
  }
}
