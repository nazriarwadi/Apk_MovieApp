import 'package:app_movie_db/movie/pages/movie_developer_page.dart';
import 'package:flutter/material.dart';
import 'package:app_movie_db/movie/components/movie_discover_component.dart';
import 'package:app_movie_db/movie/components/movie_now_playing_component.dart';
import 'package:app_movie_db/movie/components/movie_top_rated_component.dart';
import 'package:app_movie_db/movie/pages/movie_search_page.dart';

import 'movie_pagination_page.dart';

class MoviePage extends StatelessWidget {
  const MoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 100.0,
              color: Colors.white,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Katalog Movie',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: const Icon(Icons.developer_mode),
              title: const Text('Developer'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => const AboutDeveloperPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                const Text(
                  'Katalog Movie',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => showSearch(
                  context: context,
                  delegate: MovieSearchPage(),
                ),
                icon: const Icon(Icons.search),
              ),
            ],
            floating: true,
            snap: true,
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          _WidgetTitle(
            title: 'Discover Movie',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MoviePaginationPage(
                    type: TypeMovie.discover,
                  ),
                ),
              );
            },
          ),
          const MovieDiscoverComponent(),
          _WidgetTitle(
            title: 'Top Rated Movies',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MoviePaginationPage(
                    type: TypeMovie.topRated,
                  ),
                ),
              );
            },
          ),
          const MovieTopRatedComponent(),
          _WidgetTitle(
            title: 'Now Playing Movies',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MoviePaginationPage(
                    type: TypeMovie.nowPlaying,
                  ),
                ),
              );
            },
          ),
          const MovieNowPlayingComponent(),
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
        ],
      ),
    );
  }
}

class _WidgetTitle extends SliverToBoxAdapter {
  final String title;
  final void Function() onPressed;

  const _WidgetTitle({required this.title, required this.onPressed});

  @override
  Widget? get child => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                shape: const StadiumBorder(),
                side: const BorderSide(
                  color: Colors.black54,
                ),
              ),
              child: const Text('See All'),
            )
          ],
        ),
      );
}
