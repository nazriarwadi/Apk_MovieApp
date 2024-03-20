import 'package:app_movie_db/movie/pages/movie_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_movie_db/injector.dart';
import 'package:app_movie_db/movie/providers/movie_get_discover_provider.dart';
import 'package:app_movie_db/movie/providers/movie_get_now_playing_provider.dart';
import 'package:app_movie_db/movie/providers/movie_get_top_rated_provider.dart';
import 'movie/providers/movie_serach_provider.dart';
import 'package:lottie/lottie.dart';

void main() async{
  setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetDiscoverProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetTopRatedProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetNowPlayingProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieSearchProvider>(),
        ),
      ],
      child:const MaterialApp(
        title: 'Katalog Movie',
        home: SplashScreen(
          nextScreen: MoviePage(),
          duration: Duration(seconds: 4),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final Duration duration;

  const SplashScreen({
    Key? key,
    required this.nextScreen,
    required this.duration,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animationController.forward().then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.nextScreen),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/animation.json', // Replace with the path to your Lottie animation file
              controller: _animationController,
            ),
            const SizedBox(height: 18),
            const Text(
              'Welcome Katalog Movie',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}